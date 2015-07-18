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

@interface colorSchemeViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonArray;
@property (weak, nonatomic) IBOutlet customHomeButtonView *backButton;
@end

@implementation colorSchemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.backButton setTitleColor:[[super colorPalette] objectAtIndex:3]  forState:UIControlStateNormal];
    UIColor *baseColor = [super centralColor];
    NSArray *colorScheme = [Globals colorsInPalette:baseColor];
    int i = 0;
    for (UIButton *b in self.buttonArray) {
        b.backgroundColor = [colorScheme objectAtIndex:i];
        i++;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
