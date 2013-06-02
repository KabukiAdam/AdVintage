//
//  SBAdImageManager.h
//  OldAds
//
//  Created by Simon Burbidge on 1/06/13.
//  Copyright (c) 2013 GovHack2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBAdImageOperation.h"
#import "SBPendingOperations.h"

@class SBAdImageManager;
@protocol SBAdImageManagerDelegate <NSObject>
@required
- (void)adImageManagerDidRetrieveImage:(UIImage*)image forAdID:(NSString*)adID indexPath:(NSIndexPath*)indexPath contextID:(NSInteger)contextID;
@end



@interface SBAdImageManager : NSObject <SBAdImageOperationDelegate> {
    __weak id <SBAdImageManagerDelegate> delegate;
}

@property (nonatomic, weak) id <SBAdImageManagerDelegate> delegate;
@property (nonatomic, strong) SBPendingOperations *pendingOperations;

- (void)startImageDownloadingForAdID:(NSString*)adID atIndexPath:(NSIndexPath *)indexPath contextID:(NSInteger)contextID;

/*
    Expects an Array of NSDictionary
    e.g.
        NSIndexPath *indexPath = [[NSIndexPath alloc] initWithIndex:1];
        [adImageManager startImageDownloadingForAdArray:@[@{@"indexPath":indexPath,@"adID":@"12345678"}]];
*/
- (void)startImageDownloadingForAdArray:(NSArray*)adArray;

@end
