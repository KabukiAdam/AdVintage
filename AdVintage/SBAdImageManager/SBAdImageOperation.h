//
//  SBAdImageOperation.h
//  OldAds
//
//  Created by Simon Burbidge on 1/06/13.
//  Copyright (c) 2013 GovHack2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBAdPartialImageOperation.h"

@class SBAdImageOperation;
@protocol SBAdImageOperationDelegate <NSObject>
@required
- (void)adImageOperationDidFinish:(SBAdImageOperation *)operation;

@end


@interface SBAdImageOperation : NSOperation  <SBAdPartialImageOperationDelegate> {
    __strong id <SBAdImageOperationDelegate> delegate;
}
@property (nonatomic,strong) id <SBAdImageOperationDelegate> delegate;

@property (nonatomic,strong) NSError* error;
@property (nonatomic,strong) UIImage *finalImage;
@property (nonatomic,strong) NSString *adID;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic) NSInteger contextID;
@property (nonatomic,strong) NSMutableArray *images;

- (id)initWithAdID:(NSString *)newAdID atIndexPath:(NSIndexPath*)newIndexPath contextID:(NSInteger)contextID;

@end
