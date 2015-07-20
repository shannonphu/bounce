//
//  homeViewController.m
//  bounce
//
//  Created by Shannon Phu on 7/17/15.
//  Copyright (c) 2015 Shannon Phu. All rights reserved.
//

#import "homeViewController.h"
#import "gameViewController.h"
#import "barView.h"
#import "colorSchemeViewController.h"
#import "bubbleView.h"
#import "customHomeButtonView.h"
#import "Globals.h"

CGFloat dimension = 12;

@interface homeViewController ()
@property (weak, nonatomic) IBOutlet customHomeButtonView *settingsButton;
@property (weak, nonatomic) IBOutlet customHomeButtonView *playButton;
@end

@implementation homeViewController

#pragma mark - View Set-Up

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    [self.settingsButton setTitleColor:[[super colorPalette] objectAtIndex:3]  forState:UIControlStateNormal];
    [self.playButton setTitleColor:[[super colorPalette] objectAtIndex:3]  forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(rainBubbles) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Background Effect

- (void)rainBubbles
{
    CGFloat xLocation = [Globals sideRandomXLocation:self.view.bounds.size.width];
    CGRect start = CGRectMake(xLocation, 0, dimension, dimension);
    __block bubbleView *newBubble = [[bubbleView alloc] initWithFrame:start];
    [Globals setBubbleColors:newBubble colorChoices:[super colorPalette]];
    CGRect fin = CGRectMake(xLocation, self.view.bounds.size.height + 10, dimension, dimension);
    [UIView animateWithDuration:50
                          delay:0
         usingSpringWithDamping:2
          initialSpringVelocity:1
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         newBubble.frame = fin;
                     }
                     completion:^(BOOL finished) {
                         [newBubble removeFromSuperview];
                     }];
    [self.view addSubview:newBubble];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"homeToPlay"]) {
        if ([segue.destinationViewController isKindOfClass:[gameViewController class]]) {
            gameViewController *gameView = (gameViewController *)segue.destinationViewController;
            [Globals setViewAttributes:gameView background:self.view.backgroundColor];
            gameView.bar.barColor = [self.colorPalette objectAtIndex:1];
        }
    }
    else if ([segue.identifier isEqualToString:@"homeToSettings"])
    {
        if ([segue.destinationViewController isKindOfClass:[colorSchemeViewController class]]) {
            colorSchemeViewController *settingsView = (colorSchemeViewController *)segue.destinationViewController;
            [Globals setViewAttributes:settingsView background:self.view.backgroundColor];
            [settingsView colorSettingsUnderline:self.colorPalette];
        }
    }
}

@end
