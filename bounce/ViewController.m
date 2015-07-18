//
//  ViewController.m
//  bounce
//
//  Created by Shannon Phu on 7/16/15.
//  Copyright (c) 2015 Shannon Phu. All rights reserved.
//

#import "ViewController.h"
#import "Globals.h"
#import "Colours.h"


@interface ViewController ()
{
    UIColor *defaultBackgroundColor;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    defaultBackgroundColor = [UIColor steelBlueColor];
    
    // set up color scheme
    self.centralColor = [UIColor lavenderColor];
    self.colorPalette = [Globals colorsInPalette:self.centralColor];
    self.view.backgroundColor = [self.colorPalette lastObject];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*- (void)setRandomColorPaletteForView
{
    self.centralColor = [Globals randomCentralColor];
}*/

@end
