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
#import "Article.h"
#import "AdImageCache.h"
#import "FavoritesManager.h"

#define BORDER_WIDTH 2

@interface FullScreenViewController ()

@property (nonatomic) BOOL infoMinimised;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeRec;
@property (nonatomic, strong) SLComposeViewController *SLComposerSheet;
@property (nonatomic, strong) Article *article;

@end

@implementation FullScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withArticle:(Article *)newArticle
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _article = newArticle;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = BEIGE;
    
    //_mainImageView.layer.borderColor = [[UIColor whiteColor]CGColor];
    //_mainImageView.layer.borderWidth = 5;
    _borderView.layer.shadowOpacity = 0.8;
    _borderView.layer.shadowRadius = 2.0;
    _borderView.layer.shadowOffset = CGSizeMake(0, 1.0);
    _borderView.layer.cornerRadius = 4;
    //[_mainImageView setContentMode:UIViewContentModeScaleAspectFit];
    [_mainImageView setImage:[AdImageCache imageForArticleID:_article.articleID]];
    
    
    _pubLabel.font = [UtilClass appFontWithSize:36];
    _stateLabel.font = [UtilClass appFontWithSize:24];
    _dateLabel.font = [UtilClass appFontWithSize:24];
    
    _pubLabel.text = _article.title;
    _stateLabel.text = @"National";    
    
    _dateLabel.text = [_article getNiceDate];
    
    _swipeRec = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(toggleInfoView:)];
    [_swipeRec setDirection:UISwipeGestureRecognizerDirectionDown];
    [_infoView addGestureRecognizer:self.swipeRec];
    
    _favButton.selected = [[FavoritesManager sharedInstance] isFavoriteArticle:_article];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self layoutImageViews];
}


- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)toggleInfoView:(id)sender {
    CGRect frame = _infoView.frame;
    NSLog(@"ToggleInfoView!");
    
    if (self.infoMinimised) {
        NSLog(@"InfoMinim");
        frame.origin.y = self.view.bounds.size.height - 196.0f;
        [UIView animateWithDuration:0.3 animations:^{
            _infoView.frame = frame;
        }];
        [self.swipeRec setDirection:UISwipeGestureRecognizerDirectionDown];
        self.infoMinimised = NO;
        
    } else {
        NSLog(@"InfoMAXIM");
        frame.origin.y = self.view.bounds.size.height - 30.0f;
        [UIView animateWithDuration:0.3 animations:^{
            _infoView.frame = frame;
        }];
        [self.swipeRec setDirection:UISwipeGestureRecognizerDirectionUp];
        self.infoMinimised = YES;
    }
    
}

- (IBAction)toggleFave:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected)
        [[FavoritesManager sharedInstance] favoriteArticle:self.article];
    else
        [[FavoritesManager sharedInstance] unfavoriteArticle:self.article];
}

/*- (IBAction)shareToFacebook:(id)sender {
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
}*/

- (IBAction)share:(UIButton *)sender {
    
    BOOL postToTwitter = sender.tag == 1 ? NO : YES;
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) //check if Facebook Account is linked
    {
        self.SLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller
        self.SLComposerSheet = postToTwitter ? [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter] : [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook]; //Tell him with what social plattform to use it, e.g. facebook or twitter
        [self.SLComposerSheet setInitialText:@"Take a look at this old timey ad from the AdVintage app!"]; //the message you want to post
        [self.SLComposerSheet addURL:[NSURL URLWithString:@"http://www.facebook.com/advintageapp"]];
        [self.SLComposerSheet addImage:_mainImageView.image]; //an image you could post
        [self presentViewController:self.SLComposerSheet animated:YES completion:nil];
    }
    [self.SLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSString *output;
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                if (postToTwitter) [self dismissViewControllerAnimated:YES completion:nil];
                break;
            case SLComposeViewControllerResultDone:
                output = @"Thanks for sharing!";
                /*NSString *title = postToTwitter ? @"Twitter" : @"Facebook";
                 
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];*/
                break;
            default:
                break;
        } //check if everythink worked properly. Give out a message on the state.
    }];
}

#pragma mark - UI

- (void)layoutImageViews
{
    if ((_mainImageView.image.size.width == 0) || (_mainImageView.image.size.height == 0))
    {
        NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!NOOOOOOOOOOOOOOOO!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        return;
    }
    
    float imageAspect = _mainImageView.image.size.width / _mainImageView.image.size.height;
    float viewAspect = self.view.bounds.size.width / self.view.bounds.size.height;
    
    // larger width
    if (imageAspect > viewAspect)
    {
        float newImageWidth = self.view.bounds.size.width-(BORDER_WIDTH*2);
        float newImageHeight = roundf(newImageWidth / imageAspect);
        float newBorderWidth = self.view.bounds.size.width;
        float newBorderHeight = newImageHeight+(BORDER_WIDTH*2);
        
        CGRect newFrame = CGRectMake(0, roundf((self.view.bounds.size.height-newBorderHeight)/2.0), newBorderWidth, newBorderHeight);
        NSLog(@"LAYOUT FULL VIEW (W) %@", NSStringFromCGRect(newFrame));
        _borderView.frame = newFrame;
    }
    // larger height
    else
    {
        float newImageHeight = self.view.bounds.size.height-(BORDER_WIDTH*2);
        float newImageWidth = roundf(newImageHeight * imageAspect);
        
        float newBorderHeight = self.view.bounds.size.height;
        float newBorderWidth = newImageWidth+(BORDER_WIDTH*2);
        
        CGRect newFrame = CGRectMake(roundf((self.view.bounds.size.width-newBorderWidth)/2.0), 0, newBorderWidth, newBorderHeight);
        NSLog(@"LAYOUT FULL VIEW (H) %@", NSStringFromCGRect(newFrame));
        _borderView.frame = newFrame;
        
        if (newBorderWidth > self.view.bounds.size.width) NSLog(@"");
    }
}

#pragma mark - Interface Orientation

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self layoutImageViews];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
}

#pragma mark - Cleanup

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
