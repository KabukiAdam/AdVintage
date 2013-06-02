//
//  ViewController.m
//  AdVintage
//
//  Created by Adam Shaw on 1/06/13.
//  Copyright (c) 2013 AdVintage. All rights reserved.
//

#import "AdViewController.h"
#import "SBAdImageManager.h"
#import "ArticleCell.h"
#import "AdImageCache.h"
#import "FullScreenViewController.h"

#define LOAD_ROW_MARGIN 50
#define LOAD_IMAGE_ROW_MARGIN 10


@interface AdViewController ()

@end

@implementation AdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor colorWithRed:0.929 green:0.894 blue:0.855 alpha:1];
    
    // create collection layout
    self.collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    
    // create colleciton view and add it to this view
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectInset(self.view.bounds, self.collectionLayout.minimumInteritemSpacing, 0) collectionViewLayout:self.collectionLayout];
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.929 green:0.894 blue:0.855 alpha:1];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.collectionView.clipsToBounds = NO;
    [self.collectionView setAllowsSelection:YES];
    [self.view addSubview:self.collectionView];
    [self.view sendSubviewToBack:self.collectionView];
    
    
    
    // register for cell creation
    [self.collectionView registerClass:[ArticleCell class] forCellWithReuseIdentifier:@"AD_CELL"];
    
    // start article loading
    self.articleLoader = [[ArticleLoader alloc] init];
    self.articleLoader.delegate = self;
    [self.articleLoader loadArticleRange:NSMakeRange(0, 100) withSearchCategory:SBSearchCategoryHealth sortBy:@"dateasc"];
    
    self.imageManager = [[SBAdImageManager alloc] init];
    self.imageManager.delegate = self;
    
    // scroll inset
    float bottomTitleBar = self.titleBarView.frame.origin.y+self.titleBarView.frame.size.height;
    self.collectionView.contentInset = UIEdgeInsetsMake(bottomTitleBar + self.collectionLayout.minimumLineSpacing, 0, 0, 0);;
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(bottomTitleBar, 0, 0, 0);;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self configureCellSize];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self configureCellSize];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self configureCellSize];
}

- (void)configureCellSize
{
    float width = roundf((self.collectionView.frame.size.width-self.collectionLayout.minimumInteritemSpacing)/2.0);
    float height = roundf(width*1.3);
    self.collectionLayout.itemSize = CGSizeMake(width, height);
}

#pragma mark - UICollectionViewDelegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FullScreenViewController *fullScreenViewController = [[FullScreenViewController alloc] initWithNibName:@"FullScreenViewController" bundle:nil];
    [self.navigationController pushViewController:fullScreenViewController animated:YES];
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


- (ArticleCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"AD_CELL" forIndexPath:indexPath];
    
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
    
}

- (void)configureCell:(ArticleCell*)cell forIndexPath:(NSIndexPath*)indexPath
{
    Article *article = [self.articleLoader getArticleByIndex:indexPath.row];
    if (article)
        [cell configureWithArticle:article];
    NSLog(@"&&&&&&&&&&&&&&&&&&&&& CONFIGURECELL WITH INDEX=%d ARTICLE=%d",indexPath.row, article.articleID);
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
    
    [self.articleLoader loadArticleRange:NSMakeRange(highestToLoad, LOAD_ROW_MARGIN) withSearchCategory:SBSearchCategoryHealth sortBy:@"dateasc"];
    
    // load visible images as needed
    int lowestImageToLoad = MAX(lowestRow-LOAD_IMAGE_ROW_MARGIN,0);
    int highestImageToLoad = MIN(highestRow+LOAD_IMAGE_ROW_MARGIN, self.articleLoader.numArticles-1);
    NSMutableArray *imagesToLoad = [NSMutableArray array];
    for (int i=lowestImageToLoad; i <= highestImageToLoad; i++)
    {
        Article *article = [self.articleLoader getArticleByIndex:i];
        if (article)
        {
            if (![AdImageCache imageIsCachedForArticleID:article.articleID])
            {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                [imagesToLoad addObject:@{
                 @"indexPath":indexPath,
                 @"adID":[NSString stringWithFormat:@"%d",article.articleID]
                 }];
                NSLog(@"********** IMAGETOLOAD %d (%d)", article.articleID, i);
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
            ArticleCell *cell = (ArticleCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            [self configureCell:cell forIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        }
    }
}


#pragma mark - Image Loader delegate
- (void)adImageManagerDidRetrieveImage:(UIImage*)image forAdID:(NSString*)adID indexPath:(NSIndexPath*)indexPath
{
    NSLog(@"---------- LOADEDIMAGE %@ (%d)", adID, indexPath.row);
    
    Article *article = [self.articleLoader getArticleByIndex:indexPath.row];
    if (article)
    {
        [AdImageCache cacheImage:image forArticleID:article.articleID];
        
        ArticleCell *cell = (ArticleCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
        [cell setImage:image];
    }
}

- (IBAction)buttonPressedCategory:(id)sender {
}
@end
