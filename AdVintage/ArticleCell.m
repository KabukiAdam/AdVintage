//
//  UIArticleCell.m
//  AdVintage
//
//  Created by Adam Shaw on 1/06/13.
//  Copyright (c) 2013 AdVintage. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ArticleCell.h"
#import "Article.h"
#import "AdImageCache.h"
#import "UtilClass.h"


#define BORDER_WIDTH 4

@implementation ArticleCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.autoresizesSubviews = YES;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        self.layer.shadowRadius = 3.0;
        self.layer.shadowOpacity = 0.6;
        
        CGRect bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.borderView = [[UIView alloc] initWithFrame:bounds];
        self.borderView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.borderView.autoresizesSubviews = YES;
        self.borderView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.borderView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectInset(bounds, BORDER_WIDTH, BORDER_WIDTH)];
        [_titleLabel setFont:[UtilClass appFontWithSize:20.0f]];
        [_titleLabel setTextColor:[UIColor darkGrayColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setNumberOfLines:0];
        [self.borderView addSubview:_titleLabel];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectInset(bounds, BORDER_WIDTH, BORDER_WIDTH)];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.borderView addSubview:self.imageView];
    }
    return self;
}

- (void)configureWithArticle:(Article*)article
{
    UIImage *image = [AdImageCache imageForArticleID:article.articleID];
    if (image)
    {
        [self setUserInteractionEnabled:YES];
        self.imageView.image = image;
        [_titleLabel setHidden:YES];
        [self layoutImageViews];
    }
    else
    {
        [self setUserInteractionEnabled:NO];
        self.imageView.image = nil;
        self.borderView.frame = CGRectInset(self.bounds, BORDER_WIDTH*2, BORDER_WIDTH*2);
        
        // Hack the title...
        NSString *title = article.title;
        if ([article.title isEqualToString:@"The Australian Women's Weekly (1933 - 1982)"]) title = @"Australian Women's Weekly";
        
        [_titleLabel setHidden:NO];
        [_titleLabel setText:[NSString stringWithFormat:@"%@\n%@\n%@",title,@"National",[article getNiceDate]]];
    }
}

- (void)setImage:(UIImage*)image
{
    self.imageView.image = image;
    [self layoutImageViews];
}

- (void)layoutImageViews
{
    if ((self.imageView.image.size.width == 0) || (self.imageView.image.size.height == 0))
    {
        NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!NOOOOOOOOOOOOOOOO!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        return;
    }
    
    float imageAspect = self.imageView.image.size.width / self.imageView.image.size.height;
    float cellAspect = self.bounds.size.width / self.bounds.size.height;
    
    // larger width
    if (imageAspect > cellAspect)
    {
        float newImageWidth = self.bounds.size.width-(BORDER_WIDTH*2);
        float newImageHeight = roundf(newImageWidth / imageAspect);
        float newBorderWidth = self.bounds.size.width;
        float newBorderHeight = newImageHeight+(BORDER_WIDTH*2);
        
        CGRect newFrame = CGRectMake(0, roundf((self.bounds.size.height-newBorderHeight)/2.0), newBorderWidth, newBorderHeight);
        NSLog(@"LAYOUT CELL (W) %@", NSStringFromCGRect(newFrame));
        self.borderView.frame = newFrame;
    }
    // larger height
    else
    {
        float newImageHeight = self.bounds.size.height-(BORDER_WIDTH*2);
        float newImageWidth = roundf(newImageHeight * imageAspect);
        
        float newBorderHeight = self.bounds.size.height;
        float newBorderWidth = newImageWidth+(BORDER_WIDTH*2);
        
        CGRect newFrame = CGRectMake(roundf((self.bounds.size.width-newBorderWidth)/2.0), 0, newBorderWidth, newBorderHeight);
        NSLog(@"LAYOUT CELL (H) %@", NSStringFromCGRect(newFrame));
        self.borderView.frame = newFrame;
        
        if (newBorderWidth > self.bounds.size.width)
            NSLog(@"");
    }
}

@end
