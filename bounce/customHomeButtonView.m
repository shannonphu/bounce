//
//  customHomeButtonView.m
//  bounce
//
//  Created by Shannon Phu on 7/16/15.
//  Copyright (c) 2015 Shannon Phu. All rights reserved.
//

#import "customHomeButtonView.h"

@implementation customHomeButtonView

- (void)drawRect:(CGRect)rect {
    UIBezierPath *buttonpath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:15];
    [buttonpath addClip];
    [self.buttonColor setFill];
    [buttonpath fill];
}


@end
