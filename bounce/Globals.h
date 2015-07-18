//
//  Globals.h
//  bounce
//
//  Created by Shannon Phu on 7/17/15.
//  Copyright (c) 2015 Shannon Phu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class bubbleView;

@interface Globals : NSObject
+ (void)setBubbleColors:(bubbleView *)bubble colorChoices:(NSArray *)palette;
+ (CGFloat)randValBetw0And1;
+ (CGFloat)randomXLocation:(CGFloat)width;
+ (CGFloat)sideRandomXLocation:(CGFloat)margin;
+ (CGFloat)randomYLocation:(CGFloat)height;
+ (NSMutableArray *)getColorPaletteChoices;
+ (UIColor *)randomCentralColor;
+ (NSArray *)colorsInPalette:(UIColor *)centralColor;
@end
