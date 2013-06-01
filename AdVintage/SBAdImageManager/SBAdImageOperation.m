//
//  SBAdImageOperation.m
//  OldAds
//
//  Created by Simon Burbidge on 1/06/13.
//  Copyright (c) 2013 GovHack2013. All rights reserved.
//

#import "SBAdImageOperation.h"
#import "TFHpple.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "SBAdPartialImageOperation.h"


#define kArbitraryCropHeight 25.0f

@interface UIImage (Combining)

- (UIImage*)combineWithImage:(UIImage*)image;

@end

@implementation UIImage (Combining)

- (UIImage*)combineWithImage:(UIImage*)image
{
    CGSize size = CGSizeMake(image.size.width, self.size.height + image.size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    CGPoint selfPoint = CGPointMake(0.0f, 0.0f);
    [self drawAtPoint:selfPoint];
    
    CGPoint imagePoint = CGPointMake(0.0f, self.size.height);
    [image drawAtPoint:imagePoint];
    
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

@end


@interface SBAdImageOperation ()

@property (nonatomic) BOOL finished;
@property (nonatomic) NSInteger imageCount;

@end

@implementation SBAdImageOperation
@synthesize adID, finalImage, delegate, indexPath, finished, images, imageCount;

- (id)initWithAdID:(NSString *)newAdID atIndexPath:(NSIndexPath*)newIndexPath
{
    if( (self = [super init]) ) {
        adID = newAdID;
        indexPath = newIndexPath;
        NSLog(@"New Operation for AdID: %@",adID);
    }
    return self;
}

#pragma mark -
#pragma mark - Main operation


- (void)main {
    @autoreleasepool {
        ////NSLog(@"Main!");
        if (self.isCancelled)
            return;
                
        [self loadImage];
        
        if (self.isCancelled)
            return;
        
        while (!finished) {
            // Wait until we're finished
            [NSThread sleepForTimeInterval:0.1f];
        }
        [(NSObject*)delegate performSelectorOnMainThread:@selector(adImageOperationDidFinish:) withObject:self waitUntilDone:NO];
    }
}



#pragma mark - Image Processing

- (void)prepareAdImageFromImageArray:(NSMutableArray*)images
{
    NSLog(@"PrepareAdImageFromArray - Article: %@",adID);
    //NSLog(@"Images: %f %f",((UIImage*)[[images objectAtIndex:0] objectForKey:@"image"]).size.height, ((UIImage*)[[images objectAtIndex:1] objectForKey:@"image"]).size.height);
    
    //NSLog(@"Images Before: %@", images);
    NSSortDescriptor *sortIndex = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
    [images sortUsingDescriptors:[NSArray arrayWithObject:sortIndex]];
    //NSLog(@"Images After: %@", images);
    
    UIImage *final = [[UIImage alloc] init];
    float combinedHeight = 0.0f;
    NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
    for (NSDictionary *imageDict in images) {
        [imagesArray addObject:[imageDict objectForKey:@"image"]];
        combinedHeight = combinedHeight + ((UIImage*)[imageDict objectForKey:@"image"]).size.height;
    }
    float finalHeight = combinedHeight / 2.0f;
    NSInteger scale = ((UIImage*)[imagesArray objectAtIndex:0]).scale;
    finalHeight = finalHeight * scale;
    combinedHeight = combinedHeight * scale;
    
    //NSLog(@"Final Height: %f - Combined Height: %f",finalHeight, combinedHeight);
    
    if (finalHeight < 900) {
        // Whole image is in Image1
        CGImageRef imageRef = CGImageCreateWithImageInRect([((UIImage*)[imagesArray objectAtIndex:0]) CGImage], CGRectMake(0.0f, 0.0f, ((UIImage*)[imagesArray objectAtIndex:0]).size.width * scale, finalHeight-kArbitraryCropHeight * scale));
        // or use the UIImage wherever you like
        final = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
    } else if (finalHeight < 1350) {
        // Ad Image is split between Image1 and Image2
        CGImageRef imageRef = CGImageCreateWithImageInRect([((UIImage*)[imagesArray objectAtIndex:1]) CGImage], CGRectMake(0.0f, 29.0f * scale, ((UIImage*)[imagesArray objectAtIndex:0]).size.width * scale, (finalHeight-900.0f)-kArbitraryCropHeight * scale));
        // or use the UIImage wherever you like
        final = [((UIImage*)[imagesArray objectAtIndex:0]) combineWithImage:[UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp]];
        CGImageRelease(imageRef);
    }
    
    finalImage = final;
    finished = YES;
}

#pragma mark - Image Scraping

- (void)loadImage {
    NSURL *imagesUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://trove.nla.gov.au/ndp/del/printArticleJpg/%@/6?print=n",adID]];
    

    NSData * imagesHtmlData = [NSData dataWithContentsOfURL:imagesUrl];
    
    TFHpple *imagesParser = [TFHpple hppleWithHTMLData:imagesHtmlData];
    
    NSString *imagesXpathQueryString = @"//img";
    NSArray *imagesNodes = [imagesParser searchWithXPathQuery:imagesXpathQueryString];
    
    images = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSInteger index = 0;
    ////NSLog(@"ImageNodes Count: %d",imagesNodes.count);
    
    NSOperationQueue *partialsQueue = [[NSOperationQueue alloc] init];
    [partialsQueue setMaxConcurrentOperationCount:4];
    imageCount = imagesNodes.count;
    
    for (TFHppleElement *element in imagesNodes) {
        NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://trove.nla.gov.au%@",[element objectForKey:@"src"]]];
        NSLog(@"Image: %@",imageUrl);
        
        SBAdPartialImageOperation *partialImageOperation = [[SBAdPartialImageOperation alloc] initWithURL:imageUrl andIndex:index];
        [partialImageOperation setDelegate:self];
        [partialsQueue addOperation:partialImageOperation];
        index ++;
    }
}

- (void)adPartialImageOperationDidFinish:(SBAdPartialImageOperation *)operation
{
    NSLog(@"ImageReturned AdID: %@ : %@",adID,operation.image);
    [images addObject:@{@"index":[NSNumber numberWithInteger:operation.index],@"image":operation.image}];
    if (images.count == imageCount) [self prepareAdImageFromImageArray:images];
}

@end
