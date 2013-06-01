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
@property (nonatomic,strong) NSMutableData *imageData;

@end

@implementation SBAdPartialImageOperation
@synthesize image, error, finished, delegate, index, url, imageData;


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
        //NSLog(@"Main!");
        if (self.isCancelled)
            return;
        
        // Download the image
        [self getImage];
        
        if (self.isCancelled)
            return;
        
        while (!finished) {
            [NSThread sleepForTimeInterval:0.1f];
        }
        [(NSObject*)delegate performSelectorOnMainThread:@selector(adPartialImageOperationDidFinish:) withObject:self waitUntilDone:NO];
    }
}

- (void)getImage {
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:url
                                              cachePolicy:NSURLCacheStorageAllowedInMemoryOnly
                                          timeoutInterval:60.0];
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self startImmediately:NO];
    
    [theConnection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                          forMode:NSDefaultRunLoopMode];
    [theConnection start];
    
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // imageData is an instance variable declared elsewhere.
        imageData = [NSMutableData data];
    } else {
        // Inform the user that the connection failed.
        NSLog(@"ERRRRRRRROOORRR!");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // imageData is an instance variable declared elsewhere.
    //NSLog(@"Did REceive REsponse!");
    [imageData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // imageData is an instance variable declared elsewhere.
    //NSLog(@"Connection Did Receive Data!!");
    [imageData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)newError
{    
    // inform the user
    error = newError;
    NSLog(@"Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    //NSLog(@"Succeeded! Received %d bytes of data",[imageData length]);
    image = [UIImage imageWithData:imageData];
    finished = YES;
}


@end
