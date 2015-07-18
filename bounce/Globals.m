//
//  Globals.m
//  bounce
//
//  Created by Shannon Phu on 7/17/15.
//  Copyright (c) 2015 Shannon Phu. All rights reserved.
//

#import "Globals.h"
#import "bubbleView.h"
#import "barView.h"

@implementation Globals

+ (CGFloat)randValBetw0And1
{
    return (CGFloat)rand()/RAND_MAX;
}

+ (void)setBubbleColors:(bubbleView *)bubble
{
    bubble.red = [self randValBetw0And1];
    bubble.green = [self randValBetw0And1];
    bubble.blue = [self randValBetw0And1];
    [bubble setNeedsDisplay];
}

+ (CGFloat)randomXLocation:(CGFloat)width
{
    CGFloat x = [Globals randValBetw0And1] * width;
    return x;
}

+ (CGFloat)sideRandomXLocation:(CGFloat)margin
{
    CGFloat choice1 = [Globals randValBetw0And1] * margin / 5;
    CGFloat choice2 = margin - ([Globals randValBetw0And1] * margin / 4);
    int choice = rand() % 2;
    return choice ? choice1 : choice2;
}

+ (CGFloat)randomYLocation:(CGFloat)height
{
    CGFloat y = [Globals randValBetw0And1] * height;
    return y;
}



@end
