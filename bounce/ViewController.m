//
//  ViewController.m
//  bounce
//
//  Created by Shannon Phu on 7/16/15.
//  Copyright (c) 2015 Shannon Phu. All rights reserved.
//

#import "ViewController.h"
#import "bubbleView.h"
#import "customHomeButtonView.h"
#import "Globals.h"

CGFloat dimension = 12;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet customHomeButtonView *playButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(rainBubbles) userInfo:nil repeats:YES];
}

- (void)rainBubbles
{
    CGFloat xLocation = [Globals sideRandomXLocation:self.view.bounds.size.width];
    CGRect start = CGRectMake(xLocation, 0, dimension, dimension);
    __block bubbleView *newBubble = [[bubbleView alloc] initWithFrame:start];
    [Globals setBubbleColors:newBubble];
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

@end
