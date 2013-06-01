//
//  ViewController.h
//  AdVintage
//
//  Created by Adam Shaw on 1/06/13.
//  Copyright (c) 2013 AdVintage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICollectionViewWaterfallLayout.h"
#import "ArticleLoader.h"


@interface AdViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, ArticleLoaderDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionLayout;

@property (strong, nonatomic) ArticleLoader *articleLoader;

@end
