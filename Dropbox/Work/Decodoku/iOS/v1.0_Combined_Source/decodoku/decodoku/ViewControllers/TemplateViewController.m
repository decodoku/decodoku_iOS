//
//  TemplateViewController.m
//  Decodoku
//
//  Created by James on 14/01/16.
//  Copyright © 2015 Decodoku. All rights reserved.
//

#import "TemplateViewController.h"

@interface TemplateViewController (){
    
    // declare global variables here
    UIButton *_buttonM;
    
    double wS, hS, fSize;
    
}
@end


@implementation TemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // size of screen
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    wS = screenRect.size.width;
    hS = screenRect.size.height;
    
    [self makeButtons];
    
}

- (void)makeButtons {
    
    double wB = 0.27*wS;
    double hB = 0.06*hS;
    
    fSize = 0.035 * wS;
    
    // add menu button
    _buttonM = [UIButton buttonWithType:UIButtonTypeSystem];  // initialize
    [_buttonM addTarget:self action:@selector(menuButton:) forControlEvents:UIControlEventTouchDown]; // action
    _buttonM.frame = CGRectMake(0.95 * wS - wB, 0.9 * hS, wB, hB); // frame
    _buttonM.backgroundColor = [UIColor blueColor];// background
    [_buttonM setTitle:@"Menu" forState:UIControlStateNormal]; // text
    [_buttonM setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ]; // text colour
    _buttonM.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:fSize]; // text font
    [self.view addSubview:_buttonM]; // add to view
    
}


- (IBAction)menuButton:(id)sender {
    
    [self performSegueWithIdentifier:@"fromTemplate" sender:self];
    
}

@end
