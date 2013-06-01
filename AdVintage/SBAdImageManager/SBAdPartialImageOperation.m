//
//  SBAdPartialImageOperation.m
//  AdVintage
//
//  Created by Simon Burbidge on 1/06/13.
//  Copyright (c) 2013 AdVintage. All rights reserved.
//

#import "SBAdPartialImageOperation.h"

@interface SBAdPartialImageOperation ()

@property (nonatomic) BOOL finished;

@end

@implementation SBAdPartialImageOperation
@synthesize image, error, finished, delegate, index, url;


- (id)initWithURL:(NSURL*)newURL andIndex:(NSInteger)newIndex
{
    if( (self = [super init]) ) {
        index = newIndex;
        url = newURL;
    }
    return self;
}

#pragma mark -
#pragma mark - Main operation


- (void)main {
    @autoreleasepool {
        NSLog(@"Main!");
        if (self.isCancelled)
            return;
        
        // Download the image
        [self getImage];
        
        if (self.isCancelled)
            return;
        
        while (!finished) {

        }
        [(NSObject*)delegate performSelectorOnMainThread:@selector(adPartialImageOperationDidFinish:) withObject:self waitUntilDone:NO];
    }
}

- (void)getImage {
    image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    finished = YES;
    
    /*NSURLRequest *theRequest=[NSURLRequest requestWithURL:url
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        receivedData = [[NSMutableData data] retain];
    } else {
        // Inform the user that the connection failed.
    }*/
}




@end
