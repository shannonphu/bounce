//
//  ViewController.m
//  bounce
//
//  Created by Shannon Phu on 7/16/15.
//  Copyright (c) 2015 Shannon Phu. All rights reserved.
//

#import "ViewController.h"
#import "colorSchemeViewController.h"
#import "Globals.h"
#import "Colours.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.centralColor = [UIColor carrotColor];
    self.colorPalette = [Globals colorsInPalette:self.centralColor];
    self.view.backgroundColor = [self.colorPalette lastObject];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
