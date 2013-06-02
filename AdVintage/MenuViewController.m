//
//  MenuViewController.m
//  advintage
//
//  Created by James White on 1/06/13.
//  Copyright (c) 2013 James White. All rights reserved.
//

#import "MenuViewController.h"
#import "UtilClass.h"
#import <QuartzCore/QuartzCore.h>


@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.background.image = [UIImage imageNamed:@"popover_bg.png"];
    
    self.divider.image = [[UIImage imageNamed:@"divider"]stretchableImageWithLeftCapWidth:0 topCapHeight:4];
    
    
    for (UIButton *button in self.buttons)
    {
        NSString *title = [self nameForButtonTag:button.tag];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UtilClass appFontWithSize:24];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        if ([[UtilClass stringForCategory:self.currentCategory] isEqualToString:button.titleLabel.text])
        {
            button.selected = YES;
        }
        
        [button addTarget:self action:@selector(selectCategory:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    for (UIButton *button in self.iconButtons)
    {
        button.backgroundColor = [UIColor clearColor];
        NSString *imageString = [NSString stringWithFormat:@"caticon_%@.png",[[self nameForButtonTag:button.tag] stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
        [button setBackgroundImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(selectCategory:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.contentSizeForViewInPopover = self.view.bounds.size;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectCategory:(UIButton *)sender
{
    NSNumber *category = [self categories][sender.tag-1];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCategory" object:category];
}

-(NSArray*)categories
{
    NSArray *sortedArray = @[@(SBSearchCategoryAll),
                             @(SBSearchCategoryAlcohol),
                             @(SBSearchCategoryChildren),
                             @(SBSearchCategoryCleaning),
                             @(SBSearchCategoryClothing),
                             @(SBSearchCategoryElectronics),
                             @(SBSearchCategoryEntertainment),
                             @(SBSearchCategoryFood),
                             @(SBSearchCategoryHealth),
                             @(SBSearchCategoryHousehold),
                             @(SBSearchCategoryMen),
                             @(SBSearchCategoryTobacco),
                             @(SBSearchCategoryTransport),
                             @(SBSearchCategoryWomen),
                             @(SBSearchCategoryFavourites)
                             ];

//    NSMutableArray *sortedArray = [[unsortedArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]mutableCopy];
//
//    [sortedArray insertObject:@"all categories" atIndex:0];
//    [sortedArray addObject:@"favourites"];

    return sortedArray;
}

-(NSString *)nameForButtonTag:(int)tag
{
    NSArray *catArray = [self categories];
    NSNumber *catNumber = catArray[tag-1];
    SBSearchCategory cat = [catNumber intValue];
    return [UtilClass stringForCategory:cat];
}


@end
