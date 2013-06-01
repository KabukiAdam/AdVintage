//
//  SBAdPartialImageOperation.h
//  AdVintage
//
//  Created by Simon Burbidge on 1/06/13.
//  Copyright (c) 2013 AdVintage. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SBAdPartialImageOperation;
@protocol SBAdPartialImageOperationDelegate <NSObject>
@required
- (void)adPartialImageOperationDidFinish:(SBAdPartialImageOperation *)operation;
- (void)adPartialImageOperationDidFail:(SBAdPartialImageOperation *)operation;
@end


@interface SBAdPartialImageOperation : NSOperation  <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    __strong id <SBAdPartialImageOperationDelegate> delegate;
}

@property (nonatomic,strong) id <SBAdPartialImageOperationDelegate> delegate;

@property (nonatomic,strong) NSError* error;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic) NSInteger index;
@property (nonatomic,strong) NSURL *url;

- (id)initWithURL:(NSURL*)newURL andIndex:(NSInteger)newIndex;

@end
