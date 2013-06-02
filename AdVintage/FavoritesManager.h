//
//  FavoritesManager.h
//  AdVintage
//
//  Created by Adam Shaw on 2/06/13.
//  Copyright (c) 2013 AdVintage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Article.h"

@interface FavoritesManager : NSObject

@property (strong, nonatomic) NSMutableDictionary *favoriteArticles;

+ (FavoritesManager *)sharedInstance;

- (void)favoriteArticle:(Article *)article;
- (void)unfavoriteArticle:(Article *)article;
- (BOOL)isFavoriteArticle:(Article*)article;

@end
