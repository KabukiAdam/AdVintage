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
#import "SBAdImageManager.h"
#import "UtilClass.h"
#import "Spinner.h"

@interface AdViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, ArticleLoaderDelegate, SBAdImageManagerDelegate>

@property (weak, nonatomic) IBOutlet UIView *titleBarView;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (weak, nonatomic) IBOutlet UIView *progressView;


@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *collectionLayout;
@property (strong, nonatomic) UIPopoverController *menuPopoverController;
@property (strong, nonatomic) ArticleLoader *articleLoader;
@property (strong, nonatomic) SBAdImageManager *imageManager;
@property (assign, nonatomic) SBSearchCategory currentCategory;

@property (assign, nonatomic) int contextID;
@property (assign, nonatomic) int lastScrollBlock;

- (IBAction)buttonPressedCategory:(id)sender;


@end
