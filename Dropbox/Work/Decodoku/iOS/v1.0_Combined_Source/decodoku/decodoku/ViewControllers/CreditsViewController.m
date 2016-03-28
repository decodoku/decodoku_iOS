//
//  CreditsViewController.m
//  decode:active_v2
//
//  Copyright © 2016 James R. Wootton.

#import "CreditsViewController.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface CreditsViewController (){
    
    // declare global variables here
    UIButton *_buttonM;
    
    double wS, hS, fSize;
    
}
@end


@implementation CreditsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // size of screen
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    wS = screenRect.size.width;
    hS = screenRect.size.height;
    
    [self makeBackground];
    
    [self makeButtons];
    
}

- (void) makeBackground {
    
    
    // background colour
    UIColor *backColour1 = [UIColor colorWithRed: 229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:.69]; // colour at sides
    UIColor *backColour2 = [UIColor colorWithRed: 229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1]; // colour in center
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.frame;
    gradient.colors = [NSArray arrayWithObjects:(id)[backColour1 CGColor], (id)[backColour2 CGColor], (id)[backColour1 CGColor], nil];
    gradient.startPoint = CGPointMake(0.0, 0.5);
    gradient.endPoint = CGPointMake(1, 0.5);
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    // home sizes and positions
    double homeWidth1 = wS * 0.45;
    double homeWidth2 = wS * 0.5;
    double homeWidth3 = homeWidth1 * 1.5;
    double homeWidth4 = homeWidth1 * 0.6;
    double homeWidth5 = homeWidth4;
    double homeHeight1 = homeWidth1 * 1853.0 / 1866.0;
    double homeHeight2 = homeWidth2 * 992.0 /1429.0;
    double homeHeight3 = homeWidth3 * 1853.0 / 1866.0;
    double homeHeight4 = homeWidth4 * 1853.0 / 1866.0;
    double homeHeight5 = homeHeight4;
    double homeX1 = 0;
    double homeX2 = wS - homeWidth2;
    double homeX3 = -0.4 * homeWidth3;
    double homeX4 = wS - 0.4 * homeWidth4;
    double homeX5 = wS - 0.6 * homeWidth4;
    double homeY1 = 0;
    double homeY2 = hS - homeHeight2;
    double homeY3 = 0.5 * wS;
    double homeY4 = 0;
    double homeY5 = 0.5 * (hS - homeHeight4);
    
    
    // add homes
    UIImageView *home1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home1.png"]]; // initialize and set image
    home1.frame = CGRectMake(homeX1, homeY1, homeWidth1, homeHeight1); //frame
    [self.view addSubview:home1];
    UIImageView *home2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home2.png"]]; // initialize and set image
    home2.frame = CGRectMake(homeX2, homeY2, homeWidth2, homeHeight2); //frame
    [self.view addSubview:home2];
    UIImageView *home3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home1.png"]]; // initialize and set image
    home3.frame = CGRectMake(homeX3, homeY3, homeWidth3, homeHeight3); //frame
    [self.view addSubview:home3];
    UIImageView *home4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home3.png"]]; // initialize and set image
    home4.frame = CGRectMake(homeX4, homeY4, homeWidth4, homeHeight4); //frame
    [self.view addSubview:home4];
    UIImageView *home5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home3.png"]]; // initialize and set image
    home5.frame = CGRectMake(homeX5, homeY5, homeWidth5, homeHeight5); //frame
    [self.view addSubview:home5];
    
}

- (void)makeButtons {
    
    
    // add menu button
    double wB = 0.27*wS;
    double hB = 0.048*hS;
    _buttonM = [UIButton buttonWithType:UIButtonTypeSystem];  // initialize
    [_buttonM addTarget:self action:@selector(menuButton:) forControlEvents:UIControlEventTouchDown]; // action
    _buttonM.frame = CGRectMake(0.95 * wS - wB, 0.9 * hS, wB, hB); // frame
    _buttonM.backgroundColor = [UIColor colorWithRed: 219.0/255.0 green:119.0/255.0 blue:147.0/255.0 alpha:1.0];// background
    [_buttonM setTitle:[NSString stringWithFormat:NSLocalizedString(@"Menu", nil), @(1000000)] forState:UIControlStateNormal]; // text
    [_buttonM setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ]; // text colour
    _buttonM.titleLabel.font = [UIFont fontWithName:@"QuicksandBold-Regular" size:0.035 * wS]; // text font
    [self.view addSubview:_buttonM]; // add to view
    
    // add text
    UILabel *_text = [[UILabel alloc] init]; // initialize
    _text.frame = CGRectMake(0.1 * wS, 0.2 * hS, 0.8*wS, 0.0); // frame
    _text.text = [NSString stringWithFormat:NSLocalizedString(@"credits", nil), @(1000000)]; // text
    _text.textColor = [UIColor blackColor]; //text colour
    _text.font = [UIFont fontWithName:@"QuicksandBook-Regular" size:MAX(0.035 * wS,16)]; // text font
    [_text setTextAlignment:NSTextAlignmentLeft]; // text alignment
    _text.numberOfLines = 0; // word wrap
    [_text sizeToFit]; // height in frame is set to zero, but set to fit text here
    [self.view addSubview:_text]; // add to view
    
    
}


- (IBAction)menuButton:(id)sender {
    
    [self performSegueWithIdentifier:@"fromCredits" sender:self];
    
}

@end
