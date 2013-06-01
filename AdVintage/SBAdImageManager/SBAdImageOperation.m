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
#import "AFNetworking.h"

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

@end

@implementation SBAdImageOperation

@synthesize adID, finalImage, delegate, indexPath, finished;

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
            [NSThread sleepForTimeInterval:0.1];
            // Wait until we're finished
            ////NSLog(@"Not Finished Yet!");
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
    
    //dispatch_queue_t callerQueue = dispatch_get_main_queue();
    //dispatch_queue_t downloadQueue = dispatch_queue_create("com.advintage.processimagequeue", NULL);
    //dispatch_async(downloadQueue, ^{
        NSData * imagesHtmlData = [NSData dataWithContentsOfURL:imagesUrl];
        
    //dispatch_async(callerQueue, ^{
            TFHpple *imagesParser = [TFHpple hppleWithHTMLData:imagesHtmlData];
            
            NSString *imagesXpathQueryString = @"//img";
            NSArray *imagesNodes = [imagesParser searchWithXPathQuery:imagesXpathQueryString];
            
            NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:0];
            
            NSInteger index = 0;
            ////NSLog(@"ImageNodes Count: %d",imagesNodes.count);
            for (TFHppleElement *element in imagesNodes) {
                NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://trove.nla.gov.au%@",[element objectForKey:@"src"]]];
                NSLog(@"Image: %@",imageUrl);
                
                [self getImageFromURL:imageUrl imageIndex:index callback:^(UIImage *responseImage, NSInteger imageIndex) {
                    NSLog(@"ImageReturned AdID: %@ : %@",adID,responseImage);
                    if (responseImage == nil)
                    {
                        finished = YES;
                        return;
                    }
                    [images addObject:@{@"index":[NSNumber numberWithInteger:imageIndex],@"image":responseImage}];
                    if (images.count == imagesNodes.count) [self prepareAdImageFromImageArray:images];
                }];
                index ++;
            }
    //});
    //});
}


- (void)getImageFromURL:(NSURL*)url imageIndex:(NSInteger)imageIndex callback:(void (^)(UIImage *responseImage, NSInteger imageIndex))imageCallback {
    
    //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:30.0f];
    [request setHTTPMethod:@"GET"];
    
//    AFImageRequestOperation *requestOperation = [AFImageRequestOperation imageRequestOperationWithRequest:request success:^(UIImage *image) {
//        /*NSData *imageData = UIImagePNGRepresentation(image);
//         NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/myImage%d.png",imageIndex]];
//         [imageData writeToFile:imagePath atomically:YES];*/
//        imageCallback(image, imageIndex);
//    }];
    
    
    
    AFImageRequestOperation *requestOperation = [AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:nil
                                                                                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                                                 {
                                                     NSLog(@"Success!!!!--------------");
                                                     imageCallback(image, imageIndex);
                                                 }
                                                                                                  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
                                                 {
                                                     NSLog(@"----------FAILED!!!!");
                                                     imageCallback(nil, imageIndex);
                                                 }];
    [requestOperation start];
}


@end
