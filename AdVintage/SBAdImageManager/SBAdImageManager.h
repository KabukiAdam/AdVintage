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
- (void)adImageManagerDidRetrieveImage:(UIImage*)image forAdID:(NSString*)adID indexPath:(NSIndexPath*)indexPath;
@end



@interface SBAdImageManager : NSObject <SBAdImageOperationDelegate> {
    __weak id <SBAdImageManagerDelegate> delegate;
}

@property (nonatomic, weak) id <SBAdImageManagerDelegate> delegate;
@property (nonatomic, strong) SBPendingOperations *pendingOperations;

- (void)startImageDownloadingForAdID:(NSString*)adID atIndexPath:(NSIndexPath *)indexPath;
- (void)setCurrentPriorities:(NSArray*)prioritiesArray;

@end
