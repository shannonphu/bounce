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
#import "Colours.h"
#import "ViewController.h"
#import "customHomeButtonView.h"

@interface Globals ()

@end

@implementation Globals

+ (CGFloat)randValBetw0And1
{
    return (CGFloat)rand()/RAND_MAX;
}

+ (void)setBubbleColors:(bubbleView *)bubble colorChoices:(NSArray *)palette
{
    NSMutableArray *bubbleColorChoices = [[NSMutableArray alloc] initWithObjects: palette.firstObject, [palette objectAtIndex:1], [palette objectAtIndex:2], [UIColor colorWithWhite:5 alpha:0.5], [UIColor grayColor], nil];
    NSUInteger index = rand() % [bubbleColorChoices count];
    bubble.bubbleColor = [bubbleColorChoices objectAtIndex:index];
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

+ (NSMutableArray *)getColorPaletteChoices
{
    // load color palette choices
    NSArray *pre = @[[UIColor robinEggColor], [UIColor emeraldColor], [UIColor babyBlueColor], [UIColor paleGreenColor], [UIColor palePurpleColor], [UIColor paleRoseColor], [UIColor lavenderColor], [UIColor periwinkleColor], [UIColor sandColor], [UIColor icebergColor], [UIColor coolGrayColor], [UIColor goldenrodColor], [UIColor peachColor], [UIColor carrotColor], [UIColor steelBlueColor], [UIColor moneyGreenColor], [UIColor fadedBlueColor], [UIColor warmGrayColor], [UIColor easterPinkColor], [UIColor turquoiseColor], [UIColor pastelOrangeColor], [UIColor black50PercentColor], [UIColor brickRedColor], [UIColor plumColor], [UIColor coralColor], [UIColor mustardColor], [UIColor burntOrangeColor]];
    return [NSMutableArray arrayWithArray:pre];
}

+ (UIColor *)randomCentralColor
{
    NSMutableArray *colors = [self getColorPaletteChoices];
    NSUInteger count = [colors count];
    NSUInteger index = rand() % count;
    return [colors objectAtIndex:index];
}

+ (NSArray *)colorsInPalette:(UIColor *)centralColor
{
    NSArray *colorScheme = [centralColor colorSchemeOfType:ColorSchemeMonochromatic];
    NSMutableArray *adjustedArray = [NSMutableArray arrayWithArray:colorScheme];
    [adjustedArray addObject:centralColor];
    return  [NSArray arrayWithArray:adjustedArray];
}

+ (void)setViewAttributes:(ViewController *)vc background:(UIColor*)backgroundColor
{
    vc.view.backgroundColor = backgroundColor;
    vc.centralColor = backgroundColor;
    vc.colorPalette = [Globals colorsInPalette:backgroundColor];
    for (UIView *view in vc.view.subviews) {
        if ([view isKindOfClass:[customHomeButtonView class]])
        {
            UIButton *button = (UIButton *)view;
            [button setTitleColor:[vc.colorPalette objectAtIndex:3]  forState:UIControlStateNormal];
        }
    }
}

@end











