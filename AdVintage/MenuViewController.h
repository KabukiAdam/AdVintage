//
//  MenuViewController.h
//  advintage
//
//  Created by James White on 1/06/13.
//  Copyright (c) 2013 James White. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UtilClass.h"


@interface MenuViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UIImageView *divider;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

- (IBAction)selectCategory:(UIButton *)sender;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *iconButtons;

@property (nonatomic, assign) SBSearchCategory currentCategory;

@end
