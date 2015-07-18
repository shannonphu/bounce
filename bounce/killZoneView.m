//
//  killZoneView.m
//  bounce
//
//  Created by Shannon Phu on 7/17/15.
//  Copyright (c) 2015 Shannon Phu. All rights reserved.
//

#import "killZoneView.h"

@implementation killZoneView

- (void)drawRect:(CGRect)rect {
    // give graph gradient color
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    UIColor *startColor = [UIColor colorWithWhite:1 alpha:0];
    UIColor *endColor = [UIColor colorWithWhite:1 alpha:0.4];
    gradient.colors = [NSArray arrayWithObjects:(id)[startColor CGColor], (id)[endColor CGColor], nil];
    [self.layer insertSublayer:gradient atIndex:0];
}


@end
