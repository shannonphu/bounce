//
//  bubbleView.h
//  bounce
//
//  Created by Shannon Phu on 7/16/15.
//  Copyright (c) 2015 Shannon Phu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bubbleView : UIView
@property (strong, nonatomic) UIColor *bubbleColor;
@property (nonatomic) BOOL active;
@property (nonatomic) BOOL hit;
@property (nonatomic) int numRebounds;
@end
