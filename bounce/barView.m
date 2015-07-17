//
//  barView.m
//  bounce
//
//  Created by Shannon Phu on 7/16/15.
//  Copyright (c) 2015 Shannon Phu. All rights reserved.
//

#import "barView.h"

@implementation barView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
    return self;
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *bar = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:15];
    [bar addClip];
    UIColor *color = [UIColor colorWithRed:83/255.0f green:210/255.0f blue:194/255.0f alpha:1.0f];
    [color setFill];
    [bar fill];
}


@end
