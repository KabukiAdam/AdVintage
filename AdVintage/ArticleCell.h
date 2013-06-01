//
//  UIArticleCell.h
//  AdVintage
//
//  Created by Adam Shaw on 1/06/13.
//  Copyright (c) 2013 AdVintage. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Article;

@interface ArticleCell : UICollectionReusableView

@property (strong, nonatomic) UIView *borderView;
@property (strong, nonatomic) UIImageView *imageView;

- (void)configureWithArticle:(Article*)article;
- (void)setImage:(UIImage*)image;

@end
