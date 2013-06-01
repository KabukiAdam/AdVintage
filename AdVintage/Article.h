//
//  Article.h
//  TroveFeed
//
//  Created by Adam Shaw on 31/05/13.
//  Copyright (c) 2013 Advintage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject

- (id)initWithDictionary:(NSDictionary*)dictionary;

@property (nonatomic, assign) int       articleID;
@property (nonatomic, copy)   NSString  *title;
@property (nonatomic, assign) int       titleID;
@property (nonatomic, copy)   NSString  *date;
@property (nonatomic, copy)   NSString  *snippet;
@property (nonatomic, strong) UIImage   *image;

@end
