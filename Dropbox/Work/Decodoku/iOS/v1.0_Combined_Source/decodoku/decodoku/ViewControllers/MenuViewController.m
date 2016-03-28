//
//  MenuViewController.m
//  decodoku
//
//  Copyright © 2016 James R. Wootton.

#import "MenuViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MenuViewController (){
    
    UIButton *_playButton, *_tutorialButton, *_resultsButton, *_scienceButton, *_creditsButton, *_musicButton, *_lingoButton;
    
    double wS, hS;
    
    int musicState;
    
}

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // set up the screen
    // size of screen
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    wS = screenRect.size.width;
    hS = screenRect.size.height;
    
    [self loadMusicState];
    
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
    // home1 = top left
    // home2 = bottom right
    // home3 = bottom left
    // home4 = top right
    // home5 = middle right
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
    
    // background colour
    UIColor *backColour = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];

    // declare buttons
    
    _playButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_playButton addTarget:self action:@selector(pressPlay:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_playButton];
    
    _tutorialButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_tutorialButton addTarget:self action:@selector(pressTutorial:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_tutorialButton];
    
    _resultsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_resultsButton addTarget:self action:@selector(pressResults:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_resultsButton];
    
    _scienceButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_scienceButton addTarget:self action:@selector(pressScience:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_scienceButton];
    
    _creditsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_creditsButton addTarget:self action:@selector(pressCredits:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_creditsButton];

    
    // set frames
    
    double buttonWidth = 0.6 * wS;
    double buttonHeight = 0.2 * buttonWidth;
    double buttonX = 0.5 * wS - 0.5 * buttonWidth;
    
    _playButton.frame = CGRectMake(buttonX, 0.2 * hS - buttonHeight/2, buttonWidth, buttonHeight);
    _tutorialButton.frame = CGRectMake(buttonX, 0.35 * hS - buttonHeight/2, buttonWidth, buttonHeight);
    _resultsButton.frame = CGRectMake(buttonX, 0.5 * hS - buttonHeight/2, buttonWidth, buttonHeight);
    _scienceButton.frame = CGRectMake(buttonX, 0.65 * hS - buttonHeight/2, buttonWidth, buttonHeight);
    _creditsButton.frame = CGRectMake(buttonX, 0.8 * hS - buttonHeight/2, buttonWidth, buttonHeight);
    
    // set label
    
    double fontSize = 0.04 * wS;
    UIFont *buttonFont = [UIFont fontWithName:@"QuicksandBold-Regular" size:fontSize];
    UIColor *borderColour = [UIColor colorWithRed: 219.0/255.0 green:119.0/255.0 blue:147.0/255.0 alpha:1.0];
    
    [_playButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"PLAY", nil), @(1000000)] forState:UIControlStateNormal];
    [_playButton setTintColor:borderColour];
    _playButton.titleLabel.font = buttonFont;
    _playButton.backgroundColor = backColour;
    
    [_tutorialButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"HOW TO PLAY", nil), @(1000000)] forState:UIControlStateNormal];
    [_tutorialButton setTintColor:borderColour];
    _tutorialButton.titleLabel.font = buttonFont;
    _tutorialButton.backgroundColor = backColour;
    
    [_resultsButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"RESULTS", nil), @(1000000)] forState:UIControlStateNormal];
    [_resultsButton setTintColor:borderColour];
    _resultsButton.titleLabel.font = buttonFont;
    _resultsButton.backgroundColor = backColour;
    
    [_scienceButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"SCIENCE", nil), @(1000000)] forState:UIControlStateNormal];
    [_scienceButton setTintColor:borderColour];
    _scienceButton.titleLabel.font = buttonFont;
    _scienceButton.backgroundColor = backColour;

    [_creditsButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"CREDITS", nil), @(1000000)] forState:UIControlStateNormal];
    [_creditsButton setTintColor:borderColour];
    _creditsButton.titleLabel.font = buttonFont;
    _creditsButton.backgroundColor = backColour;


    [[_playButton layer] setBorderWidth:2.0f];
    [[_playButton layer] setBorderColor:borderColour.CGColor];
    [[_tutorialButton layer] setBorderWidth:2.0f];
    [[_tutorialButton layer] setBorderColor:borderColour.CGColor];
    [[_resultsButton layer] setBorderWidth:2.0f];
    [[_resultsButton layer] setBorderColor:borderColour.CGColor];
    [[_scienceButton layer] setBorderWidth:2.0f];
    [[_scienceButton layer] setBorderColor:borderColour.CGColor];
    [[_creditsButton layer] setBorderWidth:2.0f];
    [[_creditsButton layer] setBorderColor:borderColour.CGColor];
    
    
    
    // music button
    // add reset Z10 button
    _musicButton = [UIButton buttonWithType:UIButtonTypeSystem];  // initialize
    [_musicButton addTarget:self action:@selector(changeMusic:) forControlEvents:UIControlEventTouchDown]; // action
    _musicButton.frame = CGRectMake(buttonX, 0.9 * hS, 0.3 * buttonWidth, 0.5 * buttonHeight); // frame
    _musicButton.backgroundColor = backColour;// background
    if (musicState==0) {
        [_musicButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"OFF", nil), @(1000000)] forState:UIControlStateNormal]; // text
    } else {
        [_musicButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"ON", nil), @(1000000)] forState:UIControlStateNormal]; // text
    }
    _musicButton.titleLabel.font = [UIFont fontWithName:@"QuicksandBold-Regular" size:0.5*fontSize];
    [_musicButton setTitleColor:borderColour forState:UIControlStateNormal ]; // text colour
    [[_musicButton layer] setBorderWidth:2.0f];
    [[_musicButton layer] setBorderColor:borderColour.CGColor];
    [self.view addSubview:_musicButton]; // add to view
    
//    // language button
//    _lingoButton = [UIButton buttonWithType:UIButtonTypeSystem];  // initialize
//    //[_lingoButton addTarget:self action:@selector(changeLingo:) forControlEvents:UIControlEventTouchDown]; // action
//    _lingoButton.frame = CGRectMake(buttonX + buttonWidth - 0.3 * buttonWidth, 0.9 * hS, 0.3 * buttonWidth, 0.5 * buttonHeight); // frame
//    _lingoButton.backgroundColor = backColour;// background
//    [_lingoButton setTitle:@"EN" forState:UIControlStateNormal]; // text
//    _lingoButton.titleLabel.font = [UIFont fontWithName:@"QuicksandBold-Regular" size:0.5*fontSize];
//    [_lingoButton setTitleColor:borderColour forState:UIControlStateNormal ]; // text colour
//    [[_lingoButton layer] setBorderWidth:2.0f];
//    [[_lingoButton layer] setBorderColor:borderColour.CGColor];
//    [self.view addSubview:_lingoButton]; // add to view
    
    
}

- (void) loadMusicState {
    
    // set up path to music file
    NSFileManager *fileMan;
    NSString *musicFile, *docsDir;
    NSArray *dirPaths;
    fileMan = [NSFileManager defaultManager];
    dirPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    musicFile = [docsDir stringByAppendingPathComponent: @"musicFile.dat"];
    
    
    // take data from music file

    // if the file already exists
    if ([fileMan fileExistsAtPath: musicFile]) {
        // load high score from file
        NSData *buffer = [fileMan contentsAtPath: musicFile];
        NSString *tempString = [[NSString alloc] initWithData: buffer encoding:NSASCIIStringEncoding];
        musicState = [tempString intValue];
    } else {
        // otherwise set it to 1
        musicState = 1;
    }

    
    
    
}


- (void)saveMusicState {
    
    // set up path to music file
    NSFileManager *fileMan;
    NSString *musicFile, *docsDir;
    NSArray *dirPaths;
    fileMan = [NSFileManager defaultManager];
    dirPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    musicFile = [docsDir stringByAppendingPathComponent: @"musicFile.dat"];
    
    
    // save the highscores
    NSData *buffer;
    NSString *tempString = [ [NSString alloc] initWithFormat:@"%d", musicState ];
    buffer = [tempString dataUsingEncoding: NSASCIIStringEncoding];
    [fileMan createFileAtPath: musicFile contents: buffer attributes:nil];
    
    // change button text
    if (musicState==0) {
        [_musicButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"OFF", nil), @(1000000)] forState:UIControlStateNormal]; // text
    } else {
        [_musicButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"ON", nil), @(1000000)] forState:UIControlStateNormal]; // text
    }
    
}



- (IBAction)pressPlay:(id)sender {
    
    [self performSegueWithIdentifier:@"playSegue" sender:self];
    
}

- (IBAction)pressTutorial:(id)sender {
    
    [self performSegueWithIdentifier:@"tutorialSegue" sender:self];
    
}

- (IBAction)pressResults:(id)sender {
    
    [self performSegueWithIdentifier:@"resultsSegue" sender:self];
    
}

- (IBAction)pressScience:(id)sender {
    
    [self performSegueWithIdentifier:@"scienceSegue" sender:self];
    
}

- (IBAction)pressCredits:(id)sender {
    
    [self performSegueWithIdentifier:@"creditsSegue" sender:self];
    
}


- (IBAction)changeMusic:(id)sender {
    
    musicState = (musicState + 1) %2;
    
    [self saveMusicState];
    
}

@end
