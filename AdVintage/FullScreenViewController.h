//
//  FullScreenViewController.h
//  advintage
//
//  Created by James White on 1/06/13.
//  Copyright (c) 2013 James White. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface FullScreenViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;


@end
