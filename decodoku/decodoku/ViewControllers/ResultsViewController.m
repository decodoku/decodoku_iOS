//
//  ResultsViewController.m
//  decode:active_v2
//
//  Copyright © 2016 James R. Wootton.

#import "ResultsViewController.h"

@interface ResultsViewController (){
    
    // the buttons
    UIButton *_buttonM, *_buttonZ, *_buttonP;
    

    
    NSString *tempString[7];
    double wS, hS, fSize;
    
}
@end


@implementation ResultsViewController

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
    
    fSize = MAX(0.035 * wS,15);
    
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
    
    // add reset Z10 button
    _buttonZ = [UIButton buttonWithType:UIButtonTypeSystem];  // initialize
    [_buttonZ addTarget:self action:@selector(deleteZ:) forControlEvents:UIControlEventTouchDown]; // action
    _buttonZ.frame = CGRectMake(0.95 * wS - wB, 0.1 * hS, wB, hB); // frame
    _buttonZ.backgroundColor = [UIColor colorWithRed: 219.0/255.0 green:119.0/255.0 blue:147.0/255.0 alpha:1.0];// background
    [_buttonZ setTitle:[NSString stringWithFormat:NSLocalizedString(@"Delete", nil), @(1000000)] forState:UIControlStateNormal]; // text
    [_buttonZ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ]; // text colour
    _buttonZ.titleLabel.font = [UIFont fontWithName:@"QuicksandBold-Regular" size:0.035 * wS]; // text font
    [self.view addSubview:_buttonZ]; // add to view
    
    // add reset Phi-Lambda button
    _buttonP = [UIButton buttonWithType:UIButtonTypeSystem];  // initialize
    [_buttonP addTarget:self action:@selector(deleteP:) forControlEvents:UIControlEventTouchDown]; // action
    _buttonP.frame = CGRectMake(0.95 * wS - wB, 0.5 * hS, wB, hB); // frame
    _buttonP.backgroundColor = [UIColor colorWithRed: 219.0/255.0 green:119.0/255.0 blue:147.0/255.0 alpha:1.0];// background
    [_buttonP setTitle:[NSString stringWithFormat:NSLocalizedString(@"Delete", nil), @(1000000)] forState:UIControlStateNormal]; // text
    [_buttonP setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ]; // text colour
    _buttonP.titleLabel.font = [UIFont fontWithName:@"QuicksandBold-Regular" size:0.035 * wS]; // text font
    [self.view addSubview:_buttonP]; // add to view
    
    // add score labels
    
    double wL = 0.5 * wS;
    
    _highZ = [[UILabel alloc] init]; // initialize
    _highZ.frame = CGRectMake(0.9 * wS - wL, 0.2 * hS, wL, hB); // frame
    _highZ.textColor = [UIColor blackColor]; //text colour
    _highZ.font = [UIFont fontWithName:@"QuicksandBook-Regular" size:fSize]; // text font
    [_highZ setTextAlignment:NSTextAlignmentRight]; // text alignment
    [self.view addSubview:_highZ]; // add to view
    
    
    _sampleZ = [[UILabel alloc] init]; // initialize
    _sampleZ.frame = CGRectMake(0.9 * wS - wL, 0.4 * hS, wL, hB); // frame
    _sampleZ.textColor = [UIColor blackColor]; //text colour
    _sampleZ.font = [UIFont fontWithName:@"QuicksandBook-Regular" size:fSize]; // text font
    [_sampleZ setTextAlignment:NSTextAlignmentRight]; // text alignment
    [self.view addSubview:_sampleZ]; // add to view
    
    _meanZ = [[UILabel alloc] init]; // initialize
    _meanZ.frame = CGRectMake(0.9 * wS - wL, 0.3 * hS, wL, hB); // frame
    _meanZ.textColor = [UIColor blackColor]; //text colour
    _meanZ.font = [UIFont fontWithName:@"QuicksandBook-Regular" size:fSize]; // text font
    [_meanZ setTextAlignment:NSTextAlignmentRight]; // text alignment
    [self.view addSubview:_meanZ]; // add to view
    
    _highP = [[UILabel alloc] init]; // initialize
    _highP.frame = CGRectMake(0.9 * wS - wL, 0.6 * hS, wL, hB); // frame
    _highP.textColor = [UIColor blackColor]; //text colour
    _highP.font = [UIFont fontWithName:@"QuicksandBook-Regular" size:fSize]; // text font
    [_highP setTextAlignment:NSTextAlignmentRight]; // text alignment
    [self.view addSubview:_highP]; // add to view
    
    _sampleP = [[UILabel alloc] init]; // initialize
    _sampleP.frame = CGRectMake(0.9 * wS - wL, 0.8 * hS, wL, hB); // frame
    _sampleP.textColor = [UIColor blackColor]; //text colour
    _sampleP.font = [UIFont fontWithName:@"QuicksandBook-Regular" size:fSize]; // text font
    [_sampleP setTextAlignment:NSTextAlignmentRight]; // text alignment
    [self.view addSubview:_sampleP]; // add to view
    
    _meanP = [[UILabel alloc] init]; // initialize
    _meanP.frame = CGRectMake(0.9 * wS - wL, 0.7 * hS, wL, hB); // frame
    _meanP.textColor = [UIColor blackColor]; //text colour
    _meanP.font = [UIFont fontWithName:@"QuicksandBook-Regular" size:fSize]; // text font
    [_meanP setTextAlignment:NSTextAlignmentRight]; // text alignment
    [self.view addSubview:_meanP]; // add to view
    
    // add text labels
    
    UILabel *_resultsZ = [[UILabel alloc] init]; // initialize
    _resultsZ.frame = CGRectMake(0.1 * wS, 0.1 * hS, wL, hB); // frame
    _resultsZ.text = [NSString stringWithFormat:NSLocalizedString(@"Results Z", nil), @(1000000)]; // text
    _resultsZ.textColor = [UIColor blackColor]; //text colour
    _resultsZ.font = [UIFont fontWithName:@"QuicksandBold-Regular" size:fSize]; // text font
    [_resultsZ setTextAlignment:NSTextAlignmentLeft]; // text alignment
    [self.view addSubview:_resultsZ]; // add to view
    
    UILabel *_resultsP = [[UILabel alloc] init]; // initialize
    _resultsP.frame = CGRectMake(0.1 * wS, 0.5 * hS, wL, hB); // frame
    _resultsP.text = [NSString stringWithFormat:NSLocalizedString(@"Results P-L", nil), @(1000000)]; // text
    _resultsP.textColor = [UIColor blackColor]; //text colour
    _resultsP.font = [UIFont fontWithName:@"QuicksandBold-Regular" size:fSize]; // text font
    [_resultsP setTextAlignment:NSTextAlignmentLeft]; // text alignment
    [self.view addSubview:_resultsP]; // add to view
    
    UILabel *_text_highZ = [[UILabel alloc] init]; // initialize
    _text_highZ.frame = CGRectMake(0.1 * wS, 0.2 * hS, wL, hB); // frame
    _text_highZ.text = [NSString stringWithFormat:NSLocalizedString(@"High2", nil), @(1000000)]; // text
    _text_highZ.textColor = [UIColor blackColor]; //text colour
    _text_highZ.font = [UIFont fontWithName:@"QuicksandBook-Regular" size:fSize]; // text font
    [_text_highZ setTextAlignment:NSTextAlignmentLeft]; // text alignment
    [self.view addSubview:_text_highZ]; // add to view
    
    UILabel *_text_sampleZ = [[UILabel alloc] init]; // initialize
    _text_sampleZ.frame = CGRectMake(0.1 * wS, 0.4 * hS, wL, hB); // frame
    _text_sampleZ.text = [NSString stringWithFormat:NSLocalizedString(@"Number", nil), @(1000000)]; // text
    _text_sampleZ.textColor = [UIColor blackColor]; //text colour
    _text_sampleZ.font = [UIFont fontWithName:@"QuicksandBook-Regular" size:fSize]; // text font
    [_text_sampleZ setTextAlignment:NSTextAlignmentLeft]; // text alignment
    [self.view addSubview:_text_sampleZ]; // add to view
    
    UILabel *_text_meanZ = [[UILabel alloc] init]; // initialize
    _text_meanZ.frame = CGRectMake(0.1 * wS, 0.3 * hS, wL, hB); // frameCGRectMake(0.1 * wS, 0.3 * hS, wL, hB); // frame
    _text_meanZ.text = [NSString stringWithFormat:NSLocalizedString(@"Average", nil), @(1000000)]; // text
    _text_meanZ.textColor = [UIColor blackColor]; //text colour
    _text_meanZ.font = [UIFont fontWithName:@"QuicksandBook-Regular" size:fSize]; // text font
    [_text_meanZ setTextAlignment:NSTextAlignmentLeft]; // text alignment
    [self.view addSubview:_text_meanZ]; // add to view
    
    UILabel *_text_highP = [[UILabel alloc] init]; // initialize
    _text_highP.frame = CGRectMake(0.1 * wS, 0.6 * hS, wL, hB); // frame
    _text_highP.text = [NSString stringWithFormat:NSLocalizedString(@"High2", nil), @(1000000)]; // text
    _text_highP.textColor = [UIColor blackColor]; //text colour
    _text_highP.font = [UIFont fontWithName:@"QuicksandBook-Regular" size:fSize]; // text font
    [_text_highP setTextAlignment:NSTextAlignmentLeft]; // text alignment
    [self.view addSubview:_text_highP]; // add to view
    
    UILabel *_text_sampleP = [[UILabel alloc] init]; // initialize
    _text_sampleP.frame = CGRectMake(0.1 * wS, 0.8 * hS, wL, hB); // frame
    _text_sampleP.text = [NSString stringWithFormat:NSLocalizedString(@"Number", nil), @(1000000)]; // text
    _text_sampleP.textColor = [UIColor blackColor]; //text colour
    _text_sampleP.font = [UIFont fontWithName:@"QuicksandBook-Regular" size:fSize]; // text font
    [_text_sampleP setTextAlignment:NSTextAlignmentLeft]; // text alignment
    [self.view addSubview:_text_sampleP]; // add to view
    
    UILabel *_text_meanP = [[UILabel alloc] init]; // initialize
    _text_meanP.frame = CGRectMake(0.1 * wS, 0.7 * hS, wL, hB); // frame
    _text_meanP.text = [NSString stringWithFormat:NSLocalizedString(@"Average", nil), @(1000000)]; // text
    _text_meanP.textColor = [UIColor blackColor]; //text colour
    _text_meanP.font = [UIFont fontWithName:@"QuicksandBook-Regular" size:fSize]; // text font
    [_text_meanP setTextAlignment:NSTextAlignmentLeft]; // text alignment
    [self.view addSubview:_text_meanP]; // add to view
    
    
    // load and print results
    [self showResults];
    
    
}




- (void) showResults {
    
    // set up path to data files
    NSFileManager *fileMan;
    NSString *highFile[7], *docsDir;
    NSArray *dirPaths;
    fileMan = [NSFileManager defaultManager];
    dirPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    highFile[0] = [docsDir stringByAppendingPathComponent: @"highfile0.dat"];
    highFile[1] = [docsDir stringByAppendingPathComponent: @"highfile1.dat"];
    highFile[2] = [docsDir stringByAppendingPathComponent: @"highfile2.dat"];
    highFile[3] = [docsDir stringByAppendingPathComponent: @"highfile3.dat"];
    highFile[4] = [docsDir stringByAppendingPathComponent: @"highfile4.dat"];
    highFile[5] = [docsDir stringByAppendingPathComponent: @"highfile5.dat"];
    highFile[6] = [docsDir stringByAppendingPathComponent: @"highfile6.dat"];
    
    
    // take all data from save files
    double tempScore[7];
    for (int pp=0;pp<7;pp++){
        // if the file already exists
        if ([fileMan fileExistsAtPath: highFile[pp]]) {
            // load high score from file
            NSData *buffer = [fileMan contentsAtPath: highFile[pp]];
            tempString[pp] = [[NSString alloc] initWithData: buffer encoding:NSASCIIStringEncoding];
            tempScore[pp] = [tempString[pp] doubleValue];
            
        } else {
            // otherwise set it to zero
            tempScore[pp] = 0;
            tempString[pp] = @"0";
        }
    }
    
    // sort the means
    double temp0, temp1;
    if (tempScore[4]>0){
        temp0 = tempScore[2] / tempScore[4];
    } else {
        temp0 = 0;
    }
    if (tempScore[5]>0){
        temp1 = tempScore[3] / tempScore[5];
    } else {
        temp1 = 0;
    }
    tempString[2] = [ [NSString alloc] initWithFormat:@"%.1f", temp0 ];
    tempString[3] = [ [NSString alloc] initWithFormat:@"%.1f", temp1 ];
    
    // put it where it needs to be
    _highZ.text = tempString[0];
    _highP.text = tempString[1];
    _meanZ.text = tempString[2];
    _meanP.text = tempString[3];
    _sampleZ.text = tempString[4];
    _sampleP.text = tempString[5];
    
    
}


- (void)saveResults {
    
    // set up path to data files
    NSFileManager *fileMan;
    NSString *highFile[7], *docsDir;
    NSArray *dirPaths;
    fileMan = [NSFileManager defaultManager];
    dirPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    highFile[0] = [docsDir stringByAppendingPathComponent: @"highfile0.dat"];
    highFile[1] = [docsDir stringByAppendingPathComponent: @"highfile1.dat"];
    highFile[2] = [docsDir stringByAppendingPathComponent: @"highfile2.dat"];
    highFile[3] = [docsDir stringByAppendingPathComponent: @"highfile3.dat"];
    highFile[4] = [docsDir stringByAppendingPathComponent: @"highfile4.dat"];
    highFile[5] = [docsDir stringByAppendingPathComponent: @"highfile5.dat"];
    highFile[6] = [docsDir stringByAppendingPathComponent: @"highfile6.dat"];

    
    // save the highscores
    NSData *buffer;
    for (int pp=0;pp<7;pp++){
        buffer = [tempString[pp] dataUsingEncoding: NSASCIIStringEncoding];
        [fileMan createFileAtPath: highFile[pp] contents: buffer attributes:nil];
    }
    
    // and print them
    _highZ.text = tempString[0];
    _highP.text = tempString[1];
    _meanZ.text = tempString[2];
    _meanP.text = tempString[3];
    _sampleZ.text = tempString[4];
    _sampleP.text = tempString[5];
    
}


- (IBAction)deleteZ:(id)sender {
    
    // set Z10 related stuff to zero
    tempString[0] = @"0";
    tempString[2] = @"0.0";
    tempString[4] = @"0";
    
    // then save
    [self saveResults];
    
}

- (IBAction)deleteP:(id)sender {
    
    // set phi-lambda related stuff to zero
    tempString[1] = @"0";
    tempString[3] = @"0.0";
    tempString[5] = @"0";
    
    // then save
    [self saveResults];
    
}


- (IBAction)menuButton:(id)sender {
    
    [self performSegueWithIdentifier:@"fromResults" sender:self];
    
}


@end
