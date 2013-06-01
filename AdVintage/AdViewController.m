//
//  ViewController.m
//  AdVintage
//
//  Created by Adam Shaw on 1/06/13.
//  Copyright (c) 2013 AdVintage. All rights reserved.
//

#import "AdViewController.h"

#define LOAD_ROW_MARGIN 100


@interface AdViewController ()

@end

@implementation AdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // create collection layout
//    self.collectionLayout = [[UICollectionViewWaterfallLayout alloc] init];
//    self.collectionLayout.delegate = self;
//    self.collectionLayout.columnCount = 3;
//    self.collectionLayout.itemWidth = 200;
//    self.collectionLayout.sectionInset = UIEdgeInsetsMake(50, 50, 50, 50);
    
    self.collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionLayout.itemSize = CGSizeMake(379, 379);
    
    // create colleciton view and add it to this view
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.collectionLayout];
    self.collectionView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:self.collectionView];
    
    // register for cell creation
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"AD_CELL"];
    
    // start article loading
    self.articleLoader = [[ArticleLoader alloc] init];
    self.articleLoader.delegate = self;
    [self.articleLoader loadArticleRange:NSMakeRange(0, 100)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSArray *colors = @[[UIColor redColor], [UIColor blueColor], [UIColor greenColor]];
    
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"AD_CELL" forIndexPath:indexPath];
    
//    int color = indexPath.row % 3;
//    cell.contentView.backgroundColor = colors[color];
    cell.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    
    Article *article = [self.articleLoader getArticleByIndex:indexPath.row];
    if (article)
    {
        UILabel *label = (UILabel*)[cell.contentView viewWithTag:1];
        if (!label)
        {
            int tallWide = article.articleID % 2;
            float aspect = ((float)(article.articleID % 10) / 9.0 * 0.5) + 0.5;
            
            NSLog(@"aspect=%f",aspect);
            CGSize size;
            if (tallWide)
                size = CGSizeMake(cell.contentView.bounds.size.width, cell.contentView.bounds.size.width*aspect);
            else
                size = CGSizeMake(cell.contentView.bounds.size.height*aspect, cell.contentView.bounds.size.height);
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(roundf((cell.contentView.bounds.size.width-size.width)/2), roundf((cell.contentView.bounds.size.height-size.height)/2), size.width, size.height)];
        }
            
        label.tag = 1;
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%d",article.articleID];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:label];
    }
    
    return cell;
    
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(300, 300);
//}

#pragma mark - UICollectionViewWaterfallLayout delegate

//- (CGFloat)collectionView:(UICollectionView *)collectionView
//                   layout:(UICollectionViewWaterfallLayout *)collectionViewLayout
// heightForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    Article *article = [self.articleLoader getArticleByIndex:indexPath.row];
//    if (article)
//    {
//        int height = (article.articleID % 200) + 150;
//        return height;
//    }
//    else
//        return 200;
//    
//}




#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.collectionView numberOfItemsInSection:0] == 0)
        return;
    
    if (scrollView.isTracking)
    {
        int highestRow = 0;
        for (NSIndexPath *path in self.collectionView.indexPathsForVisibleItems)
        {
            if (path.row > highestRow)
                highestRow = path.row;
        }
        
        int highestToLoad = MIN(highestRow+LOAD_ROW_MARGIN, self.articleLoader.numArticles-1);
        //NSLog(@"scrollViewDidScroll (%d)", highestToLoad);
        [self.articleLoader loadArticleRange:NSMakeRange(highestToLoad, LOAD_ROW_MARGIN)];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.collectionView numberOfItemsInSection:0] == 0)
        return;
    
    int highestRow = 0;
    int lowestRow = self.articleLoader.numArticles;
    for (NSIndexPath *path in self.collectionView.indexPathsForVisibleItems)
    {
        if (path.row > highestRow)
            highestRow = path.row;
        
        if (path.row < lowestRow)
            lowestRow = path.row;
    }
    
    int lowestToLoad = MAX(lowestRow-LOAD_ROW_MARGIN,0);
    int highestToLoad = MIN(highestRow+LOAD_ROW_MARGIN, self.articleLoader.numArticles-1);
    
    //NSLog(@"scrollViewDidEndDecelerating (%d, %d)", lowestToLoad, highestToLoad);
    
    [self.articleLoader loadArticleRange:NSMakeRange(lowestToLoad, highestToLoad-lowestToLoad)];
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
            Article *article = [self.articleLoader getArticleByIndex:i];
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            UILabel *label = (UILabel*)[cell.contentView viewWithTag:1];
            if (!label)
            {
                int tallWide = article.articleID % 2;
                int bin = (article.articleID % 10);
                float binperc = bin / 9.0;
                float aspect = binperc * 0.5 + 0.5;
                
                //float aspect = ((float)(article.articleID % 10) / 9.0 * 0.5) + 0.5;
                
                NSLog(@"aspect=%f",aspect);
                CGSize size;
                if (tallWide)
                    size = CGSizeMake(cell.contentView.bounds.size.width, cell.contentView.bounds.size.width*aspect);
                else
                    size = CGSizeMake(cell.contentView.bounds.size.height*aspect, cell.contentView.bounds.size.height);
                
                label = [[UILabel alloc] initWithFrame:CGRectMake(roundf((cell.contentView.bounds.size.width-size.width)/2), roundf((cell.contentView.bounds.size.height-size.height)/2), size.width, size.height)];
            }
            
            label.tag = 1;
            label.backgroundColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = [NSString stringWithFormat:@"%d",article.articleID];
            label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [cell.contentView addSubview:label];

        }
    
    }
}

@end
