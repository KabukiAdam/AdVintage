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

@interface MenuViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UIImageView *divider;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
- (IBAction)selectCategory:(UIButton *)sender;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *iconButtons;


@end

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
    NSLog(@"%@",self.currentCategory);
    
    
    for (UIButton *button in self.buttons) {
        NSString *title = [self categories][button.tag-1];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UtilClass appFontWithSize:24];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        if ([self.currentCategory isEqualToString:button.titleLabel.text]) {
            button.selected = YES;
        }
    }
    
    for (UIButton *button in self.iconButtons) {
        button.backgroundColor = [UIColor clearColor];
        NSString *imageString = [NSString stringWithFormat:@"caticon_%@.png",[[self categories][button.tag-1]stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
        [button setBackgroundImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectCategory:(UIButton *)sender {
    NSString *category = [self categories][sender.tag-1];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeCategory" object:category];
}

-(NSArray*)categories {
    NSArray *unsortedArray = @[@"food",
                               @"health",
                               @"electronics",
                               @"household",
                               @"men",
                               @"tobacco",
                               @"women",
                               @"alcohol",
                               @"children",
                               @"transport",
                               @"entertainment",
                               @"cleaning",
                               @"clothing"
                               ];

    NSMutableArray *sortedArray = [[unsortedArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]mutableCopy];

    [sortedArray insertObject:@"all categories" atIndex:0];
    [sortedArray addObject:@"favourites"];

    return sortedArray;
}


@end
