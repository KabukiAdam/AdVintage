#import <Foundation/Foundation.h>

@interface SBPendingOperations : NSObject

@property (nonatomic, strong) NSMutableDictionary *downloadsInProgress;
@property (nonatomic, strong) NSOperationQueue *downloadQueue;

@end