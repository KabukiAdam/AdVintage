//
//  FavoritesManager.m
//  AdVintage
//
//  Created by Adam Shaw on 2/06/13.
//  Copyright (c) 2013 AdVintage. All rights reserved.
//

#import "FavoritesManager.h"

#define FAVORITES_KEY @"FAVORITES"


@implementation FavoritesManager

static FavoritesManager *sharedObject = nil;

+ (FavoritesManager *)sharedInstance
{
    static dispatch_once_t _singletonPredicate;
    
    dispatch_once(&_singletonPredicate, ^{
        sharedObject = [[super allocWithZone:nil] init];
        sharedObject.favoriteArticles = [NSMutableDictionary dictionary];
        [sharedObject loadFavorites];
    });
    
    return sharedObject;
}

- (void)favoriteArticle:(Article *)article
{
    [self.favoriteArticles setObject:article forKey:@(article.articleID)];
    [self saveFavorites];
}

- (void)unfavoriteArticle:(Article *)article
{
    [self.favoriteArticles removeObjectForKey:@(article.articleID)];
    [self saveFavorites];
}

- (BOOL)isFavoriteArticle:(Article*)article
{
    return ([self.favoriteArticles objectForKey:@(article.articleID)] != nil);
}

- (void)loadFavorites
{
    NSArray *favArray = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITES_KEY];
    [self.favoriteArticles removeAllObjects];
    for (NSDictionary *artDict in favArray)
    {
        Article *article = [[Article alloc] initWithDictionary:artDict];
        [self.favoriteArticles setObject:article forKey:@(article.articleID)];
    }
}

- (void)saveFavorites
{
    NSMutableArray *prefArray = [NSMutableArray array];
    for (NSNumber *artID in self.favoriteArticles)
    {
        Article *article = self.favoriteArticles[artID];
        NSDictionary *artDict = [article getDictionary];
        [prefArray addObject:artDict];
    }
    [[NSUserDefaults standardUserDefaults] setObject:prefArray forKey:FAVORITES_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
