//
//  ArticleLoader.h
//  TroveFeed
//
//  Created by Adam Shaw on 1/06/13.
//  Copyright (c) 2013 Advintage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Article.h"
#import "UtilClass.h"

//food",@"health",@"household",@"men",@"tobacco",@"transport",@"women",@"alcohol",@"children",@"classified",@"cleaning",@"clothing",@"electronics"


@protocol ArticleLoaderDelegate <NSObject>

- (void)loadedArticleRange:(NSRange)range contextID:(int)contextID;
- (int)getCurrentContextID;

@end


@interface ArticleLoader : NSObject

@property (nonatomic, weak)     id<ArticleLoaderDelegate>   delegate;
@property (nonatomic, readonly) NSMutableDictionary *articleCache;
@property (nonatomic, readonly) NSMutableSet *pendingChunks;
@property (nonatomic, readonly) int numArticles;

- (Article *)getArticleByIndex:(int)index;
- (void)loadArticleRange:(NSRange)range withSearchCategory:(SBSearchCategory)searchCategory sortBy:(NSString*)sortBy contextID:(int)contextID;
- (void)emptyArticles;

@end
