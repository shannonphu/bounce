//
//  gameViewController.m
//  bounce
//
//  Created by Shannon Phu on 7/16/15.
//  Copyright (c) 2015 Shannon Phu. All rights reserved.
//

#import "gameViewController.h"
#import "barView.h"
#import "bubbleView.h"

CGFloat bubbleDimension = 18.0f;
NSTimeInterval normalDropTime = 1.8;

@interface gameViewController () <UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *killZone;
@property (weak, nonatomic) IBOutlet UIView *barRegion;
@property (strong, nonatomic) NSMutableArray *bubbleArray;
@property (strong, nonatomic) barView *bar;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation gameViewController

@synthesize bar = _bar;
@synthesize bubbleArray = _bubbleArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setupGame];
}

- (NSMutableArray *)bubbleArray
{
    if (!_bubbleArray) {
        _bubbleArray = [[NSMutableArray alloc] init];
    }
    return _bubbleArray;
}

- (void)setupGame
{
    // set up bar and tap recognizer
    CGFloat initialY = self.view.bounds.size.height - 70;
    self.bar = [[barView alloc] initWithFrame:CGRectMake(0, initialY, 80.0f, 8.0f)];
    self.bar.center = CGPointMake(self.view.bounds.size.width / 2, initialY);
    [self.view addSubview:self.bar];
    UITapGestureRecognizer *tappedbar =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapMoveBar:)];
    [self.barRegion addGestureRecognizer:tappedbar];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(play) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkCollision) userInfo:nil repeats:YES];
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

- (CGFloat)randomXLocation
{
    CGFloat x = [self randValBetw0And1] * self.view.bounds.size.width;
    return x;
}

- (CGFloat)randomYLocation
{
    CGFloat y = [self randValBetw0And1] * self.view.bounds.size.height;
    return y;
}

- (void)play
{
    [self addBubble];
}

                                                                                            // PROBLEMATIC PART BUBBLES WONT DISAPPEAR
                                                                                            // PROGRAM CRASH WHEN REMOVE BUBBLE FROM ARRAY
- (void)checkCollision
{
    for (bubbleView *bubble in self.bubbleArray) {
        CALayer *bubbleLayer = (CALayer*)[bubble.layer presentationLayer];
        CALayer *barLayer = (CALayer*)[self.bar.layer presentationLayer];
        
        if(CGRectIntersectsRect(bubbleLayer.frame, barLayer.frame))
        {
            //[self pauseLayer:bubbleLayer];
            bubble.hit = YES;
            [self reboundBubble:bubble];
            continue;
        }
        
        if (CGRectIntersectsRect(bubbleLayer.frame, self.killZone.frame) || [self bubbleOutOfView:bubble]) {
            bubble.hit = NO;
            CGRect fin = CGRectMake(bubble.center.x, self.view.bounds.size.height, bubbleDimension, bubbleDimension);
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
    for (bubbleView *bubble in self.bubbleArray) {
        if (bubble.active) {
            active++;
        }
    }
    return active;
}

- (bubbleView *)makeBubbleAtFrame:(CGRect)frame
{
    bubbleView *newBubble = [[bubbleView alloc] initWithFrame:frame];
    // set colors of new patch
    [self setBubbleColors:newBubble];
    return newBubble;
}

- (void)addBubble
{
    if ([self numActiveBubbles] < 10) {
        __weak gameViewController* weakSelf = self;
        __block bubbleView *newBubble;
        // create random origin and have bubble to be bubbleDimension size
        CGFloat xLocation = [self randomXLocation];
        CGRect start = CGRectMake(xLocation, 0, bubbleDimension, bubbleDimension);
        newBubble = [weakSelf makeBubbleAtFrame:start];
        [self.bubbleArray addObject:newBubble];
        
        [self fallBubble:newBubble xLocation:xLocation];
        // add subview
        [self.view addSubview:newBubble];
        NSLog(@"%d bubbles", [self numActiveBubbles]);
    }
}

- (void)fallBubble:(bubbleView *)bubble xLocation:(CGFloat)xLocation
{
    CGRect fin = CGRectMake(xLocation, self.view.bounds.size.height - 90, bubbleDimension, bubbleDimension);
    
    [UIView animateWithDuration:normalDropTime
                          delay:0
         usingSpringWithDamping:0.75
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         bubble.frame = fin;
                     }
                     completion:^(BOOL finished) {
                         //Completion Block
                     }];
}

- (void)reboundBubble:(bubbleView *)bubble
{
    CGFloat newY = [self randomYLocation];
    CGRect fin = CGRectMake(bubble.center.x, newY, bubbleDimension, bubbleDimension);
    [UIView animateWithDuration:normalDropTime
                     animations:^{
                         bubble.frame = fin;
                     } completion:^(BOOL finished) {
                         [self fallBubble:bubble xLocation:bubble.center.x];
                     }];
}

- (void)setBubbleColors:(bubbleView *)bubble
{
    bubble.red = [self randValBetw0And1];
    bubble.green = [self randValBetw0And1];
    bubble.blue = [self randValBetw0And1];
    [bubble setNeedsDisplay];
}

- (CGFloat)randValBetw0And1
{
    return (CGFloat)rand()/RAND_MAX;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
