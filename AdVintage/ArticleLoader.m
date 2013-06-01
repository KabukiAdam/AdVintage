//
//  ArticleLoader.m
//  TroveFeed
//
//  Created by Adam Shaw on 1/06/13.
//  Copyright (c) 2013 Advintage. All rights reserved.
//

#import "ArticleLoader.h"
#import "AFNetworking.h"

#define kTroveAPIKey @"e5grvpqht7bik0gs"
#define kPublicationID 112

@implementation ArticleLoader

- (id)init
{
    self = [super init];
    if (self)
    {
        _articleCache = [NSMutableDictionary dictionary];
        _pendingChunks = [NSMutableSet set];
        _numArticles = 0;
    }
    
    return self;
}

- (Article *)getArticleByIndex:(int)index;
{
    return self.articleCache[@(index)];
}

- (void)loadArticleRange:(NSRange)range withSearchTerms:(NSArray*)searchTerms sortBy:(NSString*)sortBy
{
    // break range into 100-size chunks
    int firstChunk = (range.location/100);
    int lastChunk = (range.location+range.length)/100;
    
    for (int chunk = firstChunk; chunk <= lastChunk; chunk++)
    {
        if (![self.pendingChunks containsObject:@(chunk)])
        {
            NSLog(@"Loading articles %d-%d",chunk*100, (chunk*100)+99);
            
            NSString *searchString = [[NSString alloc] init];
            for (NSString *searchTerm in searchTerms) {
                if (searchString.length<1) searchString = [NSString stringWithFormat:@"&q=fulltext:%@",searchTerm];
                else searchString = [NSString stringWithFormat:@"%@ OR fulltext:%@",searchString,searchTerm];
            }
            //NSLog(@"SearchString: %@",searchString);
            
            NSString *urlString = [NSString stringWithFormat:@"http://api.trove.nla.gov.au/result?key=%@&zone=newspaper%@&reclevel=full&l-category=Advertising&l-illustrated=Y&sortby=%@&l-title=%d&encoding=json&s=%d&n=%d",kTroveAPIKey,searchString,sortBy,kPublicationID,chunk*100,100];
            urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            
            NSURL *url = [NSURL URLWithString:urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                                 {
                                                     NSDictionary *js = (NSDictionary*)JSON;
                                                     NSArray *zone = (NSArray*)[js valueForKeyPath:@"response.zone"];
                                                     NSArray *articles = [(NSDictionary*)zone[0] valueForKeyPath:@"records.article"];
                                                     int start = [(NSNumber*)[(NSDictionary*)zone[0] valueForKeyPath:@"records.s"] intValue];
                                                     _numArticles = [(NSNumber*)[(NSDictionary*)zone[0] valueForKeyPath:@"records.total"] intValue];
                                                     
                                                     int num = start;
                                                     for (NSDictionary *artDict in articles)
                                                     {
                                                         Article *article = [[Article alloc] initWithDictionary:artDict];
                                                         [self.articleCache setObject:article forKey:@(num)];
                                                         num++;
                                                     }
                                                     
                                                     if ([self.delegate respondsToSelector:@selector(loadedArticleRange:)])
                                                         [self.delegate loadedArticleRange:NSMakeRange(chunk*100, 100)];
                                                 }
                                                                                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error , id JSON) { NSLog(@"FAILURE %@", error); }
                                                 ];
            
            [self.pendingChunks addObject:@(chunk)];
            [operation start];
        }
    }
    
}

@end
