//
//  gameViewController.m
//  bounce
//
//  Created by Shannon Phu on 7/16/15.
//  Copyright (c) 2015 Shannon Phu. All rights reserved.
//

#import "gameViewController.h"
#import "homeViewController.h"
#import "barView.h"
#import "customHomeButtonView.h"
#import "bubbleView.h"
#import "killZoneView.h"
#import "Globals.h"

// BUBBLE INFO
CGFloat BUBBLE_DIMENSIONS = 18.0f;
const int MAXBUBBLES = 10;

// SCORES INFO
const int LOST_BUBBLE_PENALTY = 5;
const int REBOUND_BUBBLE_BONUS = 3;
const int ACTIVE_BUBBLE_BONUS = 1.5;

// ANIMATION INFO
NSTimeInterval DROP_TIME = 1;
NSTimeInterval TIME_BETW_BUBBLE_DROPS = 1.5;
NSUInteger ANIMATION_OPTION = UIViewAnimationOptionCurveEaseInOut;


@interface gameViewController () <UIGestureRecognizerDelegate> {
    int tenthSeconds;
}

// UI LABELS and BUTTONS
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *pauseLabel;
@property (weak, nonatomic) IBOutlet customHomeButtonView *backButton;

// SCORE PROPERTY
@property (nonatomic) int score;

// REGIONS TO DETECT BUBBLES IN
@property (strong, nonatomic) IBOutlet UILabel *killZone;
@property (weak, nonatomic) IBOutlet UIView *barRegion;

// ARRAY FOR ALL BUBBLES MADE
@property (strong, nonatomic) NSMutableArray *bubbleArray;

@end


@implementation gameViewController

#pragma mark - View Set-Up

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set Storyboard Features
    self.navigationController.navigationBarHidden = YES;
    [self.backButton setTitleColor:[[super colorPalette] objectAtIndex:3]  forState:UIControlStateNormal];
    
    // Bar Position Set-up
    CGFloat initialY = self.view.bounds.size.height - 70;
    _bar = [[barView alloc] initWithFrame:CGRectMake(0, initialY, 80.0f, 8.0f)];
    self.bar.barColor = [self.colorPalette objectAtIndex:1];
    [self.view addSubview:self.bar];
    
    // Bubble Array Initialization
    _bubbleArray = [[NSMutableArray alloc] init];
    
    // Gesture Set-up
    UITapGestureRecognizer *tappedbar =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapMoveBar:)];
    [self.barRegion addGestureRecognizer:tappedbar];
    
    // Timer Set-up
    [NSTimer scheduledTimerWithTimeInterval:TIME_BETW_BUBBLE_DROPS target:self selector:@selector(play) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkCollision) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setupGame];
}

- (void)setupGame
{
    self.bar.center = CGPointMake(self.view.bounds.size.width / 2, self.bar.center.y);
    self.paused = YES;
    self.pauseLabel.hidden = YES;
    [self play];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.pauseLabel.alpha = 0;
    self.pauseLabel.hidden = NO;
    [UIView animateWithDuration:1
                          delay:0
                        options: UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
                     animations:^{
                         self.pauseLabel.alpha = 1;
                     } completion:nil];
}

- (void)updateScoreLabel
{
    int active = [self numActiveBubbles];
    self.score += ACTIVE_BUBBLE_BONUS * active;
    self.score -= ((int)[self.bubbleArray count] - active);
    if (self.score < 0)
        self.score = 0;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.score];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Timer Info

- (void)incrementTimerSeconds
{
    tenthSeconds++;
    int tenths = tenthSeconds % 10;
    int seconds = (tenthSeconds / 10) % 60;
    int minutes = tenthSeconds / 600;
    self.timerLabel.text = [NSString stringWithFormat:@"%02d:%02d:%d",minutes, seconds, tenths];
}

#pragma mark - Touch Handlers

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // unpause if paused
    if (self.paused) {
        [UIView animateWithDuration:0.8
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^ {
                             self.pauseLabel.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             [self.pauseLabel removeFromSuperview];
                         }];
        self.paused = NO;
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(incrementTimerSeconds) userInfo:nil repeats:YES];
    }
}

- (void)singleTapMoveBar:(UITapGestureRecognizer *)recognizer
{
    CGPoint newLocation = CGPointMake([recognizer locationInView:self.barRegion].x, self.bar.center.y);
    self.bar.center = newLocation;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self.view];
    if (CGRectContainsPoint(self.barRegion.frame, location)) {
        self.bar.center = CGPointMake(location.x, self.bar.center.y);
    }
}

#pragma mark - Play Details

- (void)play
{
    if (self.paused == NO) {
        [self addBubble];
    }
    [self updateScoreLabel];
}

- (void)checkCollision
{
    for (bubbleView *bubble in self.bubbleArray) {
        CALayer *bubbleLayer = (CALayer*)[bubble.layer presentationLayer];
        CALayer *barLayer = (CALayer*)[self.bar.layer presentationLayer];
        
        if(CGRectIntersectsRect(bubbleLayer.frame, barLayer.frame))
        {
            bubble.hit = YES;
            continue;
        }
        
        // if missed hit, suck bubble down off screen else rebound will execute in fallBubble's finished block
        if (CGRectIntersectsRect(bubbleLayer.frame, self.killZone.frame) || [self bubbleOutOfView:bubble]) {
            bubble.hit = NO;
            CGRect fin = CGRectMake(bubble.center.x, self.view.bounds.size.height, BUBBLE_DIMENSIONS, BUBBLE_DIMENSIONS);
            [UIView animateWithDuration:0.5
                                  delay:0
                 usingSpringWithDamping:0.8
                  initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 bubble.frame = fin;
                             }
                             completion:^(BOOL finished) {
                                 [bubble removeFromSuperview];
                             }];
        }
    }
}

- (BOOL)bubbleOutOfView:(bubbleView *)bubble
{
    CGFloat maxWidth = self.view.bounds.size.width;
    if (bubble.center.x >= maxWidth || bubble.center.x <= 0 || bubble.center.y > self.bar.center.y) {
        return YES;
    }
    return NO;
}

- (int)numActiveBubbles
{
    int active = 0;
    int inactive = 0;
    for (bubbleView *bubble in self.bubbleArray) {
        if (bubble.active)
        {
            active++;
            self.score += bubble.numRebounds * REBOUND_BUBBLE_BONUS;
        }
        else
        {
            inactive++;
        }
    }
    return active;
}

- (void)fallBubble:(bubbleView *)bubble xLocation:(CGFloat)xLocation
{
    [UIView animateWithDuration:DROP_TIME * ([Globals randValBetw0And1] / 2 + 0.5)
                          delay:0
                        options: ANIMATION_OPTION
                     animations:^{
                         CGRect fin = CGRectMake(xLocation, self.view.bounds.size.height - 80, BUBBLE_DIMENSIONS, BUBBLE_DIMENSIONS);
                         bubble.frame = fin;
                     }
                     completion:^(BOOL finished) {
                        [self reboundBubble:bubble xLocation:xLocation];
                     }];
}

- (void)reboundBubble:(bubbleView *)bubble xLocation:(CGFloat)xLocation
{
    bubble.numRebounds++;
    [UIView animateWithDuration:DROP_TIME * ([Globals randValBetw0And1] / 2 + 0.5)
                          delay:0
                        options: ANIMATION_OPTION
                     animations:^{
                         CGRect start = CGRectMake(xLocation, 0.5 * [Globals randValBetw0And1] * self.view.bounds.size.height, BUBBLE_DIMENSIONS, BUBBLE_DIMENSIONS);
                         bubble.frame = start;
                     }
                     completion:^(BOOL finished) {
                         [self fallBubble:bubble xLocation:xLocation];
                     }];
}

#pragma mark - Bubble Forming

- (bubbleView *)makeBubbleAtFrame:(CGRect)frame
{
    bubbleView *newBubble = [[bubbleView alloc] initWithFrame:frame];
    // set colors of new patch
    [Globals setBubbleColors:newBubble colorChoices:[super colorPalette]];
    return newBubble;
}

- (void)addBubble
{
    if ([self numActiveBubbles] < MAXBUBBLES) {
        __weak gameViewController* weakSelf = self;
        __block bubbleView *newBubble;
        // create random origin and have bubble to be BUBBLE_DIMENSIONS size
        CGFloat xLocation = [Globals randomXLocation:self.view.bounds.size.width];
        CGRect start = CGRectMake(xLocation, 0, BUBBLE_DIMENSIONS, BUBBLE_DIMENSIONS);
        newBubble = [weakSelf makeBubbleAtFrame:start];
        [self.bubbleArray addObject:newBubble];
        [self fallBubble:newBubble xLocation:xLocation];
        // add subview
        [self.view addSubview:newBubble];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"playToHome"]) {
        if ([segue.destinationViewController isKindOfClass:[homeViewController class]]) {
            homeViewController *homeView = (homeViewController *)segue.destinationViewController;
            [Globals setViewAttributes:homeView background:self.view.backgroundColor];
        }
    }
}

@end
