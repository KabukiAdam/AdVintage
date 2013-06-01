//
//  ViewController.m
//  AdVintage
//
//  Created by Adam Shaw on 1/06/13.
//  Copyright (c) 2013 AdVintage. All rights reserved.
//

#import "AdViewController.h"
#import "SBAdImageManager.h"


#define LOAD_ROW_MARGIN 100
#define LOAD_IMAGE_ROW_MARGIN 10


@interface AdViewController ()

@end

@implementation AdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // create collection layout
    self.collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    
    // create colleciton view and add it to this view
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.collectionLayout];
    self.collectionView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:self.collectionView];
    
    [self configureCellSize];
    
    // register for cell creation
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"AD_CELL"];
    
    // start article loading
    self.articleLoader = [[ArticleLoader alloc] init];
    self.articleLoader.delegate = self;
    [self.articleLoader loadArticleRange:NSMakeRange(0, 100) withSearchCategory:SBSearchCategoryAll sortBy:@"dateasc"];
    
    self.imageManager = [[SBAdImageManager alloc] init];
    self.imageManager.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self configureCellSize];
}

- (void)configureCellSize
{
    float width = roundf(self.collectionView.frame.size.width/2.0)-self.collectionLayout.minimumInteritemSpacing;
    float height = roundf(width*1.3);
    self.collectionLayout.itemSize = CGSizeMake(width, height);
}


#pragma mark - UICollectionView data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.articleLoader.numArticles;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"AD_CELL" forIndexPath:indexPath];
    
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
    
}

- (void)configureCell:(UICollectionViewCell*)cell forIndexPath:(NSIndexPath*)indexPath
{
    cell.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    UIImageView *imageView = (UIImageView*)[cell.contentView viewWithTag:1];
    if (!imageView)
    {
        imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = 1;
        [cell.contentView addSubview:imageView];
    }
    
    Article *article = [self.articleLoader getArticleByIndex:indexPath.row];
    imageView.image = article.image;
    NSLog(@"&&&&&&&&&&&&&&&&&&&&& CONFIGURECELL WITH INDEX=%d IMAGE=%@ ARTICLE=%d",indexPath.row, imageView.image, article.articleID);
}




#pragma mark - UIScrollView delegate

- (void)handleScrollPositionUpdate
{
    int highestRow = 0;
    int lowestRow = self.articleLoader.numArticles;
    for (NSIndexPath *path in self.collectionView.indexPathsForVisibleItems)
    {
        if (path.row > highestRow)
            highestRow = path.row;
        
        if (path.row < lowestRow)
            lowestRow = path.row;
    }
    
    int highestToLoad = MIN(highestRow+LOAD_ROW_MARGIN, self.articleLoader.numArticles-1);
    //NSLog(@"scrollViewDidScroll (%d)", highestToLoad);
    
    [self.articleLoader loadArticleRange:NSMakeRange(highestToLoad, LOAD_ROW_MARGIN) withSearchCategory:SBSearchCategoryAll sortBy:@"dateasc"];
    
    // load visible images as needed
    int lowestImageToLoad = MAX(lowestRow-LOAD_IMAGE_ROW_MARGIN,0);
    int highestImageToLoad = MIN(highestRow+LOAD_IMAGE_ROW_MARGIN, self.articleLoader.numArticles-1);
    NSMutableArray *imagesToLoad = [NSMutableArray array];
    for (int i=lowestImageToLoad; i <= highestImageToLoad; i++)
    {
        Article *article = [self.articleLoader getArticleByIndex:i];
        if (article)
        {
            if (!article.image)
            {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                [imagesToLoad addObject:@{
                 @"indexPath":indexPath,
                 @"adID":[NSString stringWithFormat:@"%d",article.articleID]
                 }];
                //NSLog(@"********** IMAGETOLOAD %d (%d)", article.articleID, i);
            }
        }
    }
    
    if (imagesToLoad.count > 0)
        [self.imageManager startImageDownloadingForAdArray:imagesToLoad];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.collectionView numberOfItemsInSection:0] == 0)
        return;
    
    if (scrollView.isTracking)
        [self handleScrollPositionUpdate];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.collectionView numberOfItemsInSection:0] == 0)
        return;
    
    [self handleScrollPositionUpdate];
}




#pragma mark - ArticleLoader delegate

- (void)loadedArticleRange:(NSRange)range
{
    if ([self.collectionView numberOfItemsInSection:0] == 0)
        [self.collectionView reloadData];
    else
    {
        int highestRow = 0;
        int lowestRow = self.articleLoader.numArticles;
        for (NSIndexPath *path in self.collectionView.indexPathsForVisibleItems)
        {
            if (path.row > highestRow)
                highestRow = path.row;
            
            if (path.row < lowestRow)
                lowestRow = path.row;
        }
        
        NSRange rangeToUpdate = NSIntersectionRange(range, NSMakeRange(lowestRow, highestRow-lowestRow));
        for (int i = rangeToUpdate.location; i < rangeToUpdate.location + rangeToUpdate.length; i++)
        {
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            [self configureCell:cell forIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        }
    }
}


#pragma mark - ArticleLoader delegate
- (void)adImageManagerDidRetrieveImage:(UIImage*)image forAdID:(NSString*)adID indexPath:(NSIndexPath*)indexPath
{
    NSLog(@"---------- LOADEDIMAGE %@ (%d)", adID, indexPath.row);
    
    Article *article = [self.articleLoader getArticleByIndex:indexPath.row];
    if (article)
    {
        article.image = image;
        
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        UIImageView *imageView = (UIImageView*)[cell.contentView viewWithTag:1];
        if (!imageView)
        {
            imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
            imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [cell.contentView addSubview:imageView];
        }
        
        imageView.image = article.image;
    }
}

@end
