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
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *paletteButtonArray;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *randomColorButtonArray;
@property (weak, nonatomic) IBOutlet customHomeButtonView *backButton;
@end

@implementation colorSchemeViewController

#pragma mark - View Set-Up

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
    
    [self colorSettingsUnderline:colorScheme];
    
    // get all possible central colors
    NSMutableArray *allColors = [[NSMutableArray alloc] initWithArray:[Globals getColorPaletteChoices]];
    [allColors removeObject:self.view.backgroundColor];
    for (int i = 0; i < [allColors count] - [self.randomColorButtonArray count]; i++) {
        [allColors removeObjectAtIndex:(rand()%[self.randomColorButtonArray count])];
    }
    
    // set button colors as each color in altered array of all other colors
    for (UIButton *button in self.randomColorButtonArray) {
        UIColor *chosenColor = [allColors objectAtIndex:(rand()%[allColors count])];
        button.backgroundColor = chosenColor;
        [allColors removeObject:chosenColor];
    }
}

- (void)colorSettingsUnderline:(NSArray *)palette
{
    // set colors of color palette bar under settings title
    int i = 0;
    for (UIButton *b in self.paletteButtonArray)
    {
        b.backgroundColor = [palette objectAtIndex:i];
        i++;
    }
}

#pragma mark - Color Scheme Set-up

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

- (IBAction)chooseParticularColorScheme:(id)sender {
    UIButton *button = sender;
    self.view.backgroundColor = button.backgroundColor;
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
