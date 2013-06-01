//
//  AdImageCache.h
//  AdVintage
//
//  Created by Adam Shaw on 1/06/13.
//  Copyright (c) 2013 AdVintage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdImageCache : NSObject

+ (UIImage*)imageForArticleID:(int)articleID;
+ (void)cacheImage:(UIImage*)image forArticleID:(int)articleID;
+ (BOOL)imageIsCachedForArticleID:(int)articleID;

@end
