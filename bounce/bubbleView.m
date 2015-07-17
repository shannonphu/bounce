//
//  bubbleView.m
//  bounce
//
//  Created by Shannon Phu on 7/16/15.
//  Copyright (c) 2015 Shannon Phu. All rights reserved.
//

#import "bubbleView.h"

@implementation bubbleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
    self.active = YES;
    self.hit = NO;
    return self;
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *bubblePath = [UIBezierPath bezierPathWithOvalInRect:rect];
    [bubblePath addClip];
    [[UIColor colorWithRed:self.red green:self.green blue:self.blue alpha:1] setFill];
    [bubblePath fill];
}

- (void)removeFromSuperview
{
    if (self.hit) {
        self.hit = NO;
        return;
    }
    self.active = NO;
    [super removeFromSuperview];
}


@end
