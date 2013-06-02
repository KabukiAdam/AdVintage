//
//  SBAdImageManager.m
//  OldAds
//
//  Created by Simon Burbidge on 1/06/13.
//  Copyright (c) 2013 GovHack2013. All rights reserved.
//

#import "SBAdImageManager.h"
#import "SBAdImageOperation.h"

@interface SBAdImageManager ()

@property (nonatomic,strong) NSOperationQueue *operationQueue;

@end


@implementation SBAdImageManager
@synthesize delegate, pendingOperations;


- (id)init
{
    // Call superclass's initializer
    self = [super init];
    if( !self ) return nil;
        
    return self;
}


- (void)startImageDownloadingForAdID:(NSString*)adID atIndexPath:(NSIndexPath *)indexPath contextID:(NSInteger)contextID {
    if (![self.pendingOperations.downloadsInProgress.allKeys containsObject:indexPath]) {
        SBAdImageOperation *operation = [[SBAdImageOperation alloc] initWithAdID:adID atIndexPath:indexPath contextID:contextID];
        [operation setDelegate:self];
        
        [pendingOperations.downloadsInProgress setObject:operation forKey:indexPath];
        
        [pendingOperations.downloadQueue addOperation:operation];
    }
}


- (void)startImageDownloadingForAdArray:(NSArray*)adArray {
    for (SBAdImageOperation *operation in pendingOperations.downloadQueue.operations) {
        [operation setQueuePriority:NSOperationQueuePriorityLow];
    }
    
    for (NSDictionary *adDict in adArray) {
        if (![self.pendingOperations.downloadsInProgress.allKeys containsObject:[adDict objectForKey:@"indexPath"]]) {
            SBAdImageOperation *operation = [[SBAdImageOperation alloc] initWithAdID:[adDict objectForKey:@"adID"] atIndexPath:[adDict objectForKey:@"indexPath"] contextID:[[adDict objectForKey:@"contextID"] integerValue]];
            [operation setDelegate:self];
            [operation setQueuePriority:NSOperationQueuePriorityVeryHigh];
            
            [pendingOperations.downloadsInProgress setObject:operation forKey:[adDict objectForKey:@"indexPath"]];
            [pendingOperations.downloadQueue addOperation:operation];
        }
    }
}

- (void)adImageOperationDidFinish:(SBAdImageOperation *)operation
{
    ////NSLog(@"AdImageOperationDidFinishWithAdID");
    UIImage *image = [operation finalImage];
    NSIndexPath *indexPath = [operation indexPath];
    NSInteger contextID = [operation contextID];
    NSString *adID = [operation adID];
    NSError *error = [operation error];
    if (error != nil) {
        ////NSLog(@"Error: %d - %@", error.code, error.description);
    } else {
        [delegate adImageManagerDidRetrieveImage:image forAdID:adID indexPath:indexPath contextID:contextID];
        [pendingOperations.downloadsInProgress removeObjectForKey:indexPath];
    }
}

#pragma mark - SBPendingOperations Lazy Init

- (SBPendingOperations *)pendingOperations {
    if (!pendingOperations) {
        pendingOperations = [[SBPendingOperations alloc] init];
    }
    return pendingOperations;
}

@end
