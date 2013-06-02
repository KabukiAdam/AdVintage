//
//  FullScreenViewController.m
//  advintage
//
//  Created by James White on 1/06/13.
//  Copyright (c) 2013 James White. All rights reserved.
//

#import "FullScreenViewController.h"
#import "UtilClass.h"
#import <QuartzCore/QuartzCore.h>


@interface FullScreenViewController ()

@property (nonatomic) BOOL infoMinimised;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeRec;
@property (nonatomic, strong) SLComposeViewController *SLComposerSheet;

@end

@implementation FullScreenViewController

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
	
    self.view.backgroundColor = BEIGE;
    
    _mainImageView.layer.borderColor = [[UIColor whiteColor]CGColor];
    _mainImageView.layer.borderWidth = 5;
    _mainImageView.layer.shadowOpacity = 0.8;
    _mainImageView.layer.shadowRadius = 2.0;
    _mainImageView.layer.shadowOffset = CGSizeMake(0, 1.0);
    _mainImageView.layer.cornerRadius = 4;
    
    /*
    self.pubLabel.font = [UtilClass appFontWithSize:36];
    self.stateLabel.font = [UtilClass appFontWithSize:24];
    self.dateLabel.font = [UtilClass appFontWithSize:24];
    
    self.pubLabel.text = @"The Mercury";
    self.stateLabel.text = @"Tasmania";
    self.dateLabel.text = @"14 February 1952";
    */
    
    self.swipeRec = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(toggleInfoView)];
    [self.swipeRec setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.infoView addGestureRecognizer:self.swipeRec];    
}



- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(IBAction)toggleInfoView {
    CGRect frame = self.infoView.frame;
    
    if (self.infoMinimised) {
        frame.origin.y = 808;
        [UIView animateWithDuration:0.3 animations:^{
            self.infoView.frame = frame;
        }];
        [self.swipeRec setDirection:UISwipeGestureRecognizerDirectionDown];
        self.infoMinimised = NO;
        
    } else {
        frame.origin.y = 974;
        [UIView animateWithDuration:0.3 animations:^{
            self.infoView.frame = frame;
        }];
        [self.swipeRec setDirection:UISwipeGestureRecognizerDirectionUp];
        self.infoMinimised = YES;
    }
    
}

- (IBAction)toggleFave:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)shareToFacebook:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) //check if Facebook Account is linked
    {
        self.SLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller
        self.SLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook]; //Tell him with what social plattform to use it, e.g. facebook or twitter
        [self.SLComposerSheet setInitialText:@"Take a look at this old timey ad from the AdVintage app!"]; //the message you want to post
        [self.SLComposerSheet addImage:[UIImage imageNamed:@"cola.jpg"]]; //an image you could post
        [self presentViewController:self.SLComposerSheet animated:YES completion:nil];
    }
    [self.SLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSString *output;
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                output = @"Action Cancelled";
                break;
            case SLComposeViewControllerResultDone:
                output = @"Thanks for sharing.";
                break;
            default:
                break;
        } //check if everythink worked properly. Give out a message on the state.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }];
}

- (IBAction)share:(UIButton *)sender {
    
    BOOL postToTwitter = sender.tag == 1 ? NO : YES;
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) //check if Facebook Account is linked
    {
        self.SLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller
        self.SLComposerSheet = postToTwitter ? [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter] : [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook]; //Tell him with what social plattform to use it, e.g. facebook or twitter
        [self.SLComposerSheet setInitialText:@"Take a look at this old timey ad from the AdVintage app!"]; //the message you want to post
        [self.SLComposerSheet addImage:[UIImage imageNamed:@"cola.jpg"]]; //an image you could post
        [self presentViewController:self.SLComposerSheet animated:YES completion:nil];
    }
    [self.SLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSString *output;
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                output = @"Action Cancelled";
                break;
            case SLComposeViewControllerResultDone:
                output = @"Thanks for sharing.";
                break;
            default:
                break;
        } //check if everythink worked properly. Give out a message on the state.
        
        NSString *title = postToTwitter ? @"Twitter" : @"Facebook";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
