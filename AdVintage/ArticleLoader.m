//
//  ArticleLoader.m
//  TroveFeed
//
//  Created by Adam Shaw on 1/06/13.
//  Copyright (c) 2013 Advintage. All rights reserved.
//

#import "ArticleLoader.h"
#import "AFNetworking.h"
#import "UtilClass.h"

#define kTroveAPIKey @"e5grvpqht7bik0gs"
#define kPublicationID 112

@interface ArticleLoader ()

- (NSString*)searchTermsForCategory:(SBSearchCategory)searchCategory;

@end

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

- (void)loadArticleRange:(NSRange)range withSearchCategory:(SBSearchCategory)searchCategory sortBy:(NSString*)sortBy contextID:(int)contextID
{
    // break range into 100-size chunks
    int firstChunk = (range.location/100);
    int lastChunk = (range.location+range.length)/100;
    
    for (int chunk = firstChunk; chunk <= lastChunk; chunk++)
    {
        if (![self.pendingChunks containsObject:@(chunk)])
        {
            NSLog(@"Loading articles %d-%d",chunk*100, (chunk*100)+99);
            
            NSString *searchString = [self searchTermsForCategory:searchCategory];
            
            NSString *urlString = [NSString stringWithFormat:@"http://api.trove.nla.gov.au/result?key=%@&zone=newspaper%@&reclevel=full&l-category=Advertising&l-illustrated=Y&sortby=%@&l-title=%d&encoding=json&s=%d&n=%d",kTroveAPIKey,searchString,sortBy,kPublicationID,chunk*100,100];
            urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            
            NSURL *url = [NSURL URLWithString:urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                                 {
                                                     if ([self.delegate respondsToSelector:@selector(getCurrentContextID)])
                                                     {
                                                         if ([self.delegate getCurrentContextID] != contextID)
                                                             return;
                                                     }
                                                     
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
                                                     
                                                     if ([self.delegate respondsToSelector:@selector(loadedArticleRange:contextID:)])
                                                         [self.delegate loadedArticleRange:NSMakeRange(chunk*100, 100) contextID:contextID];
                                                 }
                                                                                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error , id JSON) { NSLog(@"FAILURE %@", error); }
                                                 ];
            
            [self.pendingChunks addObject:@(chunk)];
            [operation start];
        }
    }
    
}

#pragma mark - Category Search Terms

- (NSString*)searchTermsForCategory:(SBSearchCategory)searchCategory
{
    NSArray *searchTerms;
    switch (searchCategory) {
        case SBSearchCategoryAlcohol:
            searchTerms = @[@"alcohol",@"beer",@"wine",@"spirits",@"liquor"];
            break;
        case SBSearchCategoryChildren:
            searchTerms = @[@"child",@"children",@"parent"];
            break;
        case SBSearchCategoryClassified:
            break;
        case SBSearchCategoryCleaning:
            break;
        case SBSearchCategoryClothing:
            break;
        case SBSearchCategoryElectronics:
            break;
        case SBSearchCategoryFood:
            break;
        case SBSearchCategoryHealth:
            searchTerms = @[@"medicine",@"health",@"hospital",@"doctor",@"sick",@"disease",@"illness",@"sickness",@"nurse"];
            break;
        case SBSearchCategoryHousehold:
            break;
        case SBSearchCategoryMen:
            break;
        case SBSearchCategoryTobacco:
            break;
        case SBSearchCategoryTransport:
            break;
        case SBSearchCategoryWomen:
            searchTerms = @[@"wife",@"housewife",@"woman",@"girl",@"marriage"];
            break;
        case SBSearchCategoryEntertainment:
            break;
        case SBSearchCategoryAll:
            searchTerms = @[@"alcohol",@"children",@"classified",@"cleaning",@"clothing",@"electronics",@"food",@"health",@"household",@"men",@"tobacco",@"transport",@"women"];
            break;
        default:
            break;
    }
    
    // 
    NSString *searchString = [[NSString alloc] init];
    for (NSString *searchTerm in searchTerms) {
        if (searchString.length<1) searchString = [NSString stringWithFormat:@"&q=fulltext:%@",searchTerm];
        else searchString = [NSString stringWithFormat:@"%@ OR fulltext:%@",searchString,searchTerm];
    }
    NSLog(@"SearchString: %@",searchString);
    return searchString;
}

- (void)emptyArticles
{
    _numArticles = 0;
    [self.pendingChunks removeAllObjects];
    [self.articleCache removeAllObjects];
}

@end
