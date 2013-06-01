
#import "SBPendingOperations.h"

@implementation SBPendingOperations
@synthesize downloadsInProgress, downloadQueue;


- (NSMutableDictionary *)downloadsInProgress {
    if (!downloadsInProgress) {
        downloadsInProgress = [[NSMutableDictionary alloc] init];
    }
    return downloadsInProgress;
}

- (NSOperationQueue *)downloadQueue {
    if (!downloadQueue) {
        downloadQueue = [[NSOperationQueue alloc] init];
        downloadQueue.name = @"Download Queue";
        downloadQueue.maxConcurrentOperationCount = 10;
    }
    return downloadQueue;
}

@end