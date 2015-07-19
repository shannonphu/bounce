//
//  gameViewController.h
//  bounce
//
//  Created by Shannon Phu on 7/16/15.
//  Copyright (c) 2015 Shannon Phu. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "ViewController.h"
@class  barView;

@interface gameViewController : ViewController
@property (nonatomic) BOOL paused;
@property (strong, nonatomic) barView *bar;
@end
