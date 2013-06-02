//
//  Article.m
//  TroveFeed
//
//  Created by Adam Shaw on 31/05/13.
//  Copyright (c) 2013 Advintage. All rights reserved.
//

#import "Article.h"

@implementation Article

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
        self.articleID = [(NSNumber*)dictionary[@"id"] intValue];
        
        NSDictionary *titleDict = dictionary[@"title"];
        self.title = titleDict[@"value"];
        self.titleID = [(NSNumber*)titleDict[@"id"] intValue];
        
        self.date = dictionary[@"date"];
        self.snippet = dictionary[@"snippet"];
    }
    return self;
}

- (NSString*)getNiceDate
{
    NSString *str = self.date;
    NSDateFormatter *fromStringformatter = [[NSDateFormatter alloc]init];
    [fromStringformatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [fromStringformatter setTimeZone:gmt];
    NSDate *date = [fromStringformatter dateFromString:str];
    
    
    NSDateFormatter *toStringformatter = [[NSDateFormatter alloc] init];
    [toStringformatter setDateFormat:@"dd MMMM yyyy"];
    
    //Optionally for time zone converstions
    //[toStringformatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    
    return [toStringformatter stringFromDate:date];
}

@end
