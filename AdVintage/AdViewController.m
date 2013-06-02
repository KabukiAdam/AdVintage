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
#import "UtilClass.h"
#import "MenuViewController.h"
#import "KSCustomPopoverBackgroundView.h"
#import "FavoritesManager.h"

#define LOAD_ROW_MARGIN 50
#define LOAD_IMAGE_ROW_MARGIN 10


@interface AdViewController ()

@end

@implementation AdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentCategory = -1;
    self.lastScrollBlock = -1;
    self.contextID = 0;
    
	self.view.backgroundColor = [UIColor colorWithRed:0.929 green:0.894 blue:0.855 alpha:1];
    self.categoryButton.titleLabel.font = [UtilClass appFontWithSize:24];
    
   
    // create colleciton view and add it to this view
    //self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectInset(self.view.bounds, self.collectionLayout.minimumInteritemSpacing, 0) collectionViewLayout:self.collectionLayout];
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.929 green:0.894 blue:0.855 alpha:1];
    [self.collectionView setUserInteractionEnabled:YES];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.collectionView.clipsToBounds = NO;
    [self.collectionView setAllowsSelection:YES];
    
    // register for cell creation
    [self.collectionView registerClass:[ArticleCell class] forCellWithReuseIdentifier:@"AD_CELL"];
    
    // start article loading
    self.articleLoader = [[ArticleLoader alloc] init];
    self.articleLoader.delegate = self;
    
    self.imageManager = [[SBAdImageManager alloc] init];
    self.imageManager.delegate = self;
    
    // scroll inset
    float bottomTitleBar = self.titleBarView.frame.origin.y+self.titleBarView.frame.size.height;
    self.collectionView.contentInset = UIEdgeInsetsMake(bottomTitleBar + self.collectionLayout.minimumLineSpacing, 0, 0, 0);;
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(bottomTitleBar, 0, 0, 0);
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeCategoryNotification:) name:@"changeCategory" object:nil];
    
    [self changeCategory:SBSearchCategoryAll];
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
    [self.menuPopoverController dismissPopoverAnimated:NO];
}

- (void)configureCellSize
{
    float width = roundf((self.collectionView.frame.size.width-self.collectionLayout.minimumInteritemSpacing)/2.0);
    float height = roundf(width*1.3);
    self.collectionLayout.itemSize = CGSizeMake(width, height);
}

-(void)changeCategoryNotification:(NSNotification *)notification
{
    SBSearchCategory newCat = [(NSNumber*)notification.object intValue];
    [self changeCategory:newCat];
}

-(void)changeCategory:(SBSearchCategory)category
{
    if (category == self.currentCategory)
        return;
    
    self.contextID++;
    self.currentCategory = category;
    
    [self.categoryButton setTitle:[UtilClass stringForCategory:category] forState:UIControlStateNormal];
    [self.menuPopoverController dismissPopoverAnimated:YES];
    
    [self resizeMenuButton];
    
    if (self.currentCategory != SBSearchCategoryFavourites)
    {
        [self.articleLoader emptyArticles];
        [self.collectionView reloadData];
        
        [self.articleLoader loadArticleRange:NSMakeRange(0, 100) withSearchCategory:self.currentCategory sortBy:@"dateasc" contextID:self.contextID];
    }
    else
    {
        [self.articleLoader emptyArticles];
        
        int index=0;
        for (NSNumber *artID in [FavoritesManager sharedInstance].favoriteArticles)
        {
            Article *article = [[FavoritesManager sharedInstance].favoriteArticles objectForKey:artID];
            [self.articleLoader.articleCache setObject:article forKey:@(index)];
            
            index++;
        }
        self.articleLoader.numArticles = index;
        [self.collectionView reloadData];
    }
}

-(void)resizeMenuButton
{
    CGRect frame = self.categoryButton.frame;
    
    [self.categoryButton sizeToFit];
    CGRect newFrame = self.categoryButton.frame;
    
    self.categoryButton.frame = CGRectMake((frame.origin.x+frame.size.width)-newFrame.size.width,frame.origin.y,newFrame.size.width,frame.size.height);
}

- (IBAction)buttonPressedCategory:(UIButton *)sender
{
    MenuViewController *menu = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
    menu.currentCategory = self.currentCategory;
    
    self.menuPopoverController = [[UIPopoverController alloc] initWithContentViewController:menu];
    self.menuPopoverController.popoverBackgroundViewClass = [KSCustomPopoverBackgroundView class];
    
    [self.menuPopoverController presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}



#pragma mark - UICollectionViewDelegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Did Select Item");
    [self setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    FullScreenViewController *fullScreenViewController = [[FullScreenViewController alloc] initWithNibName:@"FullScreenViewController" bundle:nil withArticle:[self.articleLoader getArticleByIndex:indexPath.row]];
    [self presentViewController:fullScreenViewController animated:YES completion:nil];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Should Touch!");
    return YES;
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
    //cell.contentView.backgroundColor = [UIColor blackColor];
    
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
    int scrollBlock = self.collectionView.contentOffset.y / 768;
    if (scrollBlock == self.lastScrollBlock)
        return;
    
    self.lastScrollBlock = scrollBlock;
    
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
    
    [self.articleLoader loadArticleRange:NSMakeRange(highestToLoad, LOAD_ROW_MARGIN) withSearchCategory:SBSearchCategoryHealth sortBy:@"dateasc" contextID:self.contextID];
    
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
                 @"adID":[NSString stringWithFormat:@"%d",article.articleID],
                 @"contextID":@(self.contextID)
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

- (void)loadedArticleRange:(NSRange)range contextID:(int)contextID
{
    if (contextID != self.contextID)    // ignore old contexts
        return;
    
    if ([self.collectionView numberOfItemsInSection:0] == 0)
    {
        [self.collectionView reloadData];
        [self handleScrollPositionUpdate];
    }
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

- (int)getCurrentContextID
{
    return self.contextID;
}



#pragma mark - Image Loader delegate
- (void)adImageManagerDidRetrieveImage:(UIImage*)image forAdID:(NSString*)adID indexPath:(NSIndexPath*)indexPath contextID:(NSInteger)contextID
{
    NSLog(@"---------- LOADEDIMAGE %@ (%d)", adID, indexPath.row);
    
    Article *article = [self.articleLoader getArticleByIndex:indexPath.row];
    if (article)
    {
        [AdImageCache cacheImage:image forArticleID:article.articleID];
        
        if (contextID == self.contextID)
        {
            ArticleCell *cell = (ArticleCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
            [cell setImage:image];
        }
    }
}

@end
