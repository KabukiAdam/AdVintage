//
//  ViewController.m
//  advintage
//
//  Created by James White on 31/05/13.
//  Copyright (c) 2013 James White. All rights reserved.
//

#import "ViewController.h"
#import "Spinner.h"
#import "KSCustomPopoverBackgroundView.h"
#import "MenuViewController.h"
#import "UtilClass.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (nonatomic, strong) UIPopoverController *menuPopoverController;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UIView *brownBar;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.menuBtn.titleLabel.font = [UtilClass appFontWithSize:24];
    [self.menuBtn setTitle:@"all categories" forState:UIControlStateNormal];
    
    self.brownBar.layer.shadowColor = [[UIColor blackColor]CGColor];
    self.brownBar.layer.shadowOffset = CGSizeMake(0, 6);
    self.brownBar.layer.shadowOpacity = 0.8;
    self.brownBar.layer.shadowRadius = 6;
    
    [self resizeMenuBtn];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeCategory:) name:@"changeCategory" object:nil];
    
   // [self performSelector:@selector(addLoadingView) withObject:nil afterDelay:2];
   [self addLoadingView];
}

-(void)addLoadingView {
    
    CGRect frame = CGRectMake(15, 532, 344, 260);
    
    UIView *articleView = [[UIView alloc]initWithFrame:frame];
    articleView.backgroundColor = [UIColor whiteColor];
    articleView.layer.shadowColor = [[UIColor blackColor]CGColor];
    articleView.layer.shadowOpacity = 0.8;
    articleView.layer.shadowRadius = 2.0;
    articleView.layer.shadowOffset = CGSizeMake(0, 1.0);
    articleView.layer.cornerRadius = 4;
    
    #define SPINNER_W 80
    
    Spinner *spinner = [[Spinner alloc]initWithFrame:CGRectMake(frame.size.width/2-(SPINNER_W/2), 40, SPINNER_W, SPINNER_W)];
    spinner.size = spinner.frame.size;
    [articleView addSubview:spinner];
    [spinner animate];
    
    float w = frame.size.width-20;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 120, w, 130)];
    label.font = [UtilClass appFontWithSize:24];
    label.numberOfLines = 3;
    label.textColor = [UIColor darkGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    NSString *publication = @"The Bugle";
    NSString *state = @"South Australia";
    NSString *date = @"8 May 1952";
    label.text = [NSString stringWithFormat:@"%@\n%@\n%@\n",publication,state,date];
    [articleView addSubview:label];
    
    [self.view addSubview:articleView];
}

- (IBAction)showMenu:(UIButton *)sender {
    MenuViewController *menuViewCont = [self.storyboard instantiateViewControllerWithIdentifier:@"menu"];
    menuViewCont.currentCategory = self.menuBtn.titleLabel.text;
    
    self.menuPopoverController = [[UIPopoverController alloc]initWithContentViewController:menuViewCont];
    self.menuPopoverController.popoverBackgroundViewClass = [KSCustomPopoverBackgroundView class];
    
    [self.menuPopoverController presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void)changeCategory:(NSNotification *)notification {
    [self.menuBtn setTitle:notification.object forState:UIControlStateNormal];
    [self.menuPopoverController dismissPopoverAnimated:YES];

    [self resizeMenuBtn];
}

-(void)resizeMenuBtn {
    CGRect frame = self.menuBtn.frame;
    
    [self.menuBtn sizeToFit];
    CGRect newFrame = self.menuBtn.frame;
    
    self.menuBtn.frame = CGRectMake((frame.origin.x+frame.size.width)-newFrame.size.width,frame.origin.y,newFrame.size.width,frame.size.height);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
