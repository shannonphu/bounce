//
//  colorSchemeViewController.m
//  bounce
//
//  Created by Shannon Phu on 7/17/15.
//  Copyright (c) 2015 Shannon Phu. All rights reserved.
//

#import "colorSchemeViewController.h"
#import "customHomeButtonView.h"
#import "Colours.h"
#import "Globals.h"
#import "homeViewController.h"

@interface colorSchemeViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonArray;
@property (weak, nonatomic) IBOutlet customHomeButtonView *backButton;
@end

@implementation colorSchemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateUI
{
    [self.backButton setTitleColor:[self.colorPalette objectAtIndex:3]  forState:UIControlStateNormal];
    NSArray *colorScheme = [Globals colorsInPalette:self.centralColor];
    int i = 0;
    for (UIButton *b in self.buttonArray) {
        b.backgroundColor = [colorScheme objectAtIndex:i];
        i++;
    }
}

- (void)setCentralAndPaletteColors:(UIColor *)color
{
    self.centralColor = color;
    self.colorPalette = [Globals colorsInPalette:color];
}


- (IBAction)randomizeColorScheme:(id)sender {
    self.view.backgroundColor = [Globals randomCentralColor];
    [self setCentralAndPaletteColors:self.view.backgroundColor];
    [self updateUI];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"settingsToHome"]) {
        if ([segue.destinationViewController isKindOfClass:[homeViewController class]]) {
            homeViewController *homeView = (homeViewController *)segue.destinationViewController;
            [Globals setViewAttributes:homeView background:self.view.backgroundColor];
        }
    }
}


@end
