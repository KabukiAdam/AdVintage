//
//  AdImageCache.m
//  AdVintage
//
//  Created by Adam Shaw on 1/06/13.
//  Copyright (c) 2013 AdVintage. All rights reserved.
//

#import "AdImageCache.h"

@implementation AdImageCache


+ (UIImage*)imageForArticleID:(int)articleID
{
    NSString *filePath = [[AdImageCache cachePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.jpg", articleID]];
    return [UIImage imageWithContentsOfFile:filePath];
}

+ (void)cacheImage:(UIImage*)image forArticleID:(int)articleID
{
    NSString *filePath = [[AdImageCache cachePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.jpg", articleID]];
    [UIImageJPEGRepresentation(image, 0.8) writeToFile:filePath atomically:YES];
}

+ (BOOL)imageIsCachedForArticleID:(int)articleID
{
    NSString *filePath = [[AdImageCache cachePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.jpg", articleID]];
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

+ (NSString *)cachePath
{
    NSArray* cachePathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* cachePath = [cachePathArray lastObject];
    return cachePath;
}

@end
