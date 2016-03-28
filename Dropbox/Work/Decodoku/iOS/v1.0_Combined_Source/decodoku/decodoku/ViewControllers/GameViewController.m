//
//  MenuViewController.m
//  decodoku
//
//  Copyright © 2016 James R. Wootton.

#import "GameViewController.h"
#import <AVFoundation/AVAudioPlayer.h>


@interface GameViewController (){
    
    // A bunch of stuff is declared to we can use it throughout the functions
    
    // the buttons
    UIButton *_gridButton, *_buttonZ, *_buttonP, *_buttonM;
    
    // the labels
    UILabel *_grid0, *_grid1,  *_grid2,  *_grid3,  *_grid4,  *_grid5,  *_grid6,  *_grid7;
    UILabel *_stateLabel, *_timeLabel, *_highLabel, *_scoreText, *_highText;
    
    // system and spin sizes
    int L, d;
    // noise
    int errorNum[2], errorRate[2];
    double pLambda;
    // game type
    int phi;
    NSString *phiString;
    // coordinates for touch events
    int Xd, Yd, Xu, Yu;
    double xd, yd, xu, yu, tu, td;
    // storage of anyons and their clusters
    int anyons[51][8][8], clusters[8][8], clusterNum, spanClus;
    //time
    int secs, secsShown;
    // other
    int gameOver;
    int highScore[2], meanScore[2], samples[2];
    NSString *timeString, *stateString, *highString[2];
    NSString *letterPhi, *letterLambda, *letterZ;
    // screen, grid, cell and font sizes
    double wS, wC, hC, hS;
    // grid font colours
    UIColor *gridColour;
    UIColor *gridColourPast;
    // music state
    int musicState;
    
}

@property (nonatomic, strong) AVAudioPlayer *theMusic;


@end

// function to generate random double between 0 and 1
double prandA() {
    return (double)arc4random() / UINT_MAX ;
}

@implementation GameViewController

// and so it begins...
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // load the info on whether to play music or not
    [self loadMusic];
    
    // load current data
    [self loadResults];
    
    // set parameters of game
    d = 10;
    
    // in the following, a sec is a single move in the game and a min is the number of secs before new errors come
    
    // number of errors per min for Z10
    errorNum[0] = 6;
    
    // number of secs per min for Z10
    errorRate[0] = 5;
    
    
    // number of errors per min for Phi-Lambda
    errorNum[1] = 6;
    
    
    // number of secs per min for Phi-Lambda,
    errorRate[1] = 5;
    
    
    // prob of lambdas for phi-lambda
    pLambda = 0.33;
    
    letterPhi = @"\u03A6";
    letterLambda = @"\u039B";
    letterZ = @"\u2124";
    
    // set up the screen
    // size of screen
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    wS = screenRect.size.width;
    hS = screenRect.size.height;
    
    // set background colour and images
    [self makeBackground];
    
    // put the buttons in
    [self makeButtons];

    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    
    // stop the music
    self.theMusic.delegate = nil;
    [self.theMusic stop];
    self.theMusic = nil;
    
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
    
    // glyph sizes and positions
    double glyphWidth1 = wS * 0.1746;
    double glyphWidth2 = glyphWidth1 * 2768.0 / 1597.0;
    double glyphWidth3 = glyphWidth1 * 1724.0 / 1597.0;
    double glyphWidth4 = glyphWidth1 * 1694.0 / 1597.0;
    double glyphHeight1 = glyphWidth1 * 1854.0 / 1597.0;
    double glyphHeight2 = glyphHeight1 * 2807.0 / 1854.0;
    double glyphHeight3 = glyphHeight1 * 3899.0 / 1854.0;
    double glyphHeight4 = glyphHeight1 * 1928.0 / 1854.0;
    double glyphX1 = 0;
    double glyphX2 = wS - glyphWidth2;
    double glyphX3 = wS - glyphWidth4;
    double glyphX4 = 0;
    double glyphY1 = hS - glyphHeight1;
    double glyphY2 = hS - glyphHeight2;
    double glyphY3 = 0;
    double glyphY4 = glyphHeight4 / 2;
    
    
    // add glyphs
    UIImageView *glyph1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"glyph1.png"]]; // initialize and set image
    glyph1.frame = CGRectMake(glyphX1, glyphY1, glyphWidth1, glyphHeight1); //frame
    [self.view addSubview:glyph1];
    UIImageView *glyph2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"glyph2.png"]]; // initialize and set image
    glyph2.frame = CGRectMake(glyphX2, glyphY2, glyphWidth2, glyphHeight2); //frame
    [self.view addSubview:glyph2];
    UIImageView *glyph3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"glyph3.png"]]; // initialize and set image
    glyph3.frame = CGRectMake(glyphX3, glyphY3, glyphWidth3, glyphHeight3); //frame
    [self.view addSubview:glyph3];
    UIImageView *glyph4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"glyph4.png"]]; // initialize and set image
    glyph4.frame = CGRectMake(glyphX4, glyphY4, glyphWidth4, glyphHeight4); //frame
    [self.view addSubview:glyph4];
    
}

- (void)makeButtons {
    
    // determine how many squares should be in the grid (given the screen size)
    // L=7 for iPhone and L=8 for iPad
    if (wS>500){
        L = 8;
    } else {
        L = 7;
    }
    
    
    // First: Set positions and sizes
    
    // For grid:
    
    // x, y, width and height
    double gridWidth = (0.873 * (L==8) + 0.95 * (L==7) ) * wS;
    double gridHeight = gridWidth * (7713.0/7626.0);
    double gridX = 0.5 * (wS - gridWidth);
    double gridY = (0.17 * (L==8) + 0.2 * (L==7) ) * hS;
    
    // square sizes
    double gridMarginH = gridHeight * (262.0/7713.0) / 2.0;
    double gridMarginW = gridWidth * (262.0/7713.0) / 2.0;
    hC = ( gridHeight - 2 * gridMarginH ) / L;
    wC = ( gridWidth - 2 * gridMarginW ) / L;
    
    // For buttons:
    
    // x, y, width and height
    double wB = 0.27*wS;
    double hB = 0.048*hS;
    double buttonsY = 0.9 * hS;
    double button1X = gridX;
    double button2X = 0.5 * (wS - wB);
    double button3X = 0.5 * (wS + gridWidth) - wB;
    
    
    // For score labels:
    
    // x, y, width and height
    double wL1 = wS/6;
    double wL2 = wS/4;
    double hL = hB*2/3;
    double labelsY = 0.12 * hS;
    double scoreTextX = gridX;
    double scoreX = gridX + wL1;
    double highTextX = gridX + gridWidth - wL1 - wL2;
    double highX = gridX + gridWidth - wL1;
    
    // For state label we use same x, y, width as grid, only height differs
    double stateHeight = 1.01 * gridHeight;
    
    // Second: Set fonts and sizes
    double gridFontSize = wC * 0.555;
    double labelFontSize = MAX( 0.6 * gridFontSize, 10.0);
    double buttonFontSize = MAX( 0.025 * gridWidth, 10.0);
    double stateFontSize = 2 * gridFontSize;
    
    // Third: Set colours
    
    // For background:
    UIColor *backColour1 = [UIColor colorWithRed: 255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1]; // colour at sides
    UIColor *backColour2 = [UIColor colorWithRed: 229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1]; // colour in center
    
    // For buttons:
    UIColor *buttonColour = [UIColor colorWithRed: 219.0/255.0 green:119.0/255.0 blue:147.0/255.0 alpha:1.0];
    
    // For grid text
    gridColour = [UIColor colorWithRed: 70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0];
    gridColourPast = [UIColor colorWithRed: 140.0/255.0 green:140.0/255.0 blue:140.0/255.0 alpha:1.0];
    
    
    
    
    
    
    
    // Finally: Actually implement all this stuff
    // This code is a bit of a mess, but it's mainly just standard button stuff
    // The most complicated thing is the grid. This is just one big button. There's one action for touch down and another for touch up
    // labels are placed over the button to display the numbers, with one label per line
    // These are positioned so that the numbers go in the right places
    
    // background colour
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.frame;
    gradient.colors = [NSArray arrayWithObjects:(id)[backColour1 CGColor], (id)[backColour2 CGColor], (id)[backColour1 CGColor], nil];
    gradient.startPoint = CGPointMake(0.0, 0.5);
    gradient.endPoint = CGPointMake(1, 0.5);
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    
    // add buttons
    
    _gridButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_gridButton addTarget:self action:@selector(bigDown:forEvent:) forControlEvents:UIControlEventTouchDown];
    [_gridButton addTarget:self action:@selector(bigUp:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_gridButton addTarget:self action:@selector(bigUp:forEvent:) forControlEvents:UIControlEventTouchDragOutside];

    
    _buttonZ = [UIButton buttonWithType:UIButtonTypeSystem];
    [_buttonZ addTarget:self action:@selector(mediumZ:) forControlEvents:UIControlEventTouchDown];
    
    
    _buttonP = [UIButton buttonWithType:UIButtonTypeSystem];
    [_buttonP addTarget:self action:@selector(mediumP:) forControlEvents:UIControlEventTouchDown];

    
    _buttonM = [UIButton buttonWithType:UIButtonTypeSystem];
    [_buttonM addTarget:self action:@selector(menuButton:) forControlEvents:UIControlEventTouchDown];

    // set button frames
    _gridButton.frame = CGRectMake(gridX, gridY, gridWidth, gridHeight);
    _buttonZ.frame = CGRectMake(button1X, buttonsY, wB, hB);
    _buttonP.frame = CGRectMake(button2X, buttonsY, wB, hB);
    _buttonM.frame = CGRectMake(button3X, buttonsY, wB, hB);
    
    // set background for grid
    if (L==8){
        [_gridButton setBackgroundImage:[UIImage imageNamed:@"grid8.png"] forState:UIControlStateNormal];
    } else {
        [_gridButton setBackgroundImage:[UIImage imageNamed:@"grid7.png"] forState:UIControlStateNormal];
    }
    
    // and for other buttons
    _buttonZ.backgroundColor = buttonColour;
    _buttonP.backgroundColor = buttonColour;
    _buttonM.backgroundColor = buttonColour;
    
    
    // create labels (one per line) for the grid
    _grid0 = [[UILabel alloc] init];
    _grid1 = [[UILabel alloc] init];
    _grid2 = [[UILabel alloc] init];
    _grid3 = [[UILabel alloc] init];
    _grid4 = [[UILabel alloc] init];
    _grid5 = [[UILabel alloc] init];
    _grid6 = [[UILabel alloc] init];
    _grid7 = [[UILabel alloc] init];
    _grid0.frame = CGRectMake(gridX+gridMarginW, gridY + gridMarginH, gridWidth, hC);
    _grid1.frame = CGRectMake(gridX+gridMarginW, gridY + gridMarginH + 1*hC, gridWidth, hC);
    _grid2.frame = CGRectMake(gridX+gridMarginW, gridY + gridMarginH + 2*hC, gridWidth, hC);
    _grid3.frame = CGRectMake(gridX+gridMarginW, gridY + gridMarginH + 3*hC, gridWidth, hC);
    _grid4.frame = CGRectMake(gridX+gridMarginW, gridY + gridMarginH + 4*hC, gridWidth, hC);
    _grid5.frame = CGRectMake(gridX+gridMarginW, gridY + gridMarginH + 5*hC, gridWidth, hC);
    _grid6.frame = CGRectMake(gridX+gridMarginW, gridY + gridMarginH + 6*hC, gridWidth, hC);
    _grid7.frame = CGRectMake(gridX+gridMarginW, gridY + gridMarginH + 7*hC, gridWidth, hC);
    UIFont *gridFont = [UIFont fontWithName:@"SourceCodePro-Regular" size:gridFontSize];
    _grid0.font = gridFont;
    _grid1.font = gridFont;
    _grid2.font = gridFont;
    _grid3.font = gridFont;
    _grid4.font = gridFont;
    _grid5.font = gridFont;
    _grid6.font = gridFont;
    _grid7.font = gridFont;
    _grid0.textColor = gridColour;
    _grid1.textColor = gridColour;
    _grid2.textColor = gridColour;
    _grid3.textColor = gridColour;
    _grid4.textColor = gridColour;
    _grid5.textColor = gridColour;
    _grid6.textColor = gridColour;
    _grid7.textColor = gridColour;

    _gridButton.adjustsImageWhenHighlighted = NO;
    
    // set fonts and contents for other buttons

    [_buttonZ setTitle:[NSString stringWithFormat:@"%@%@%@%@", [NSString stringWithFormat:NSLocalizedString(@"NEW", nil), @(1000000)], @"\n", letterZ, @"10"] forState:UIControlStateNormal];
    [_buttonP setTitle:[NSString stringWithFormat:@"%@%@%@%@%@", [NSString stringWithFormat:NSLocalizedString(@"NEW", nil), @(1000000)], @"\n", letterPhi, @"-", letterLambda ] forState:UIControlStateNormal];
    [_buttonM setTitle:[NSString stringWithFormat:NSLocalizedString(@"MENU", nil), @(1000000)] forState:UIControlStateNormal];
    
    [_buttonZ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    [_buttonP setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    [_buttonM setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    
    _buttonZ.titleLabel.font = [UIFont fontWithName:@"QuicksandBold-Regular" size:buttonFontSize];
    _buttonP.titleLabel.font = [UIFont fontWithName:@"QuicksandBold-Regular" size:buttonFontSize];
    _buttonM.titleLabel.font = [UIFont fontWithName:@"QuicksandBold-Regular" size:buttonFontSize];
    _buttonZ.titleLabel.textAlignment = NSTextAlignmentCenter;
    _buttonP.titleLabel.textAlignment = NSTextAlignmentCenter;
    _buttonM.titleLabel.textAlignment = NSTextAlignmentCenter;
    _buttonZ.titleLabel.numberOfLines = 0;
    _buttonP.titleLabel.numberOfLines = 0;
    _buttonM.titleLabel.numberOfLines = 0;
    
    // add score labels
    _scoreText = [[UILabel alloc] init];
    _highText = [[UILabel alloc] init];
    _timeLabel = [[UILabel alloc] init];
    _highLabel = [[UILabel alloc] init];
    
    // and frames
    _scoreText.frame = CGRectMake(scoreTextX, labelsY, wL1, hL); // align leading to that of grid
    _timeLabel.frame = CGRectMake(scoreX, labelsY, wL1, hL); // one labels width right of the above
    _highLabel.frame = CGRectMake(highX, labelsY, wL1, hL); // align trailing to that of grid
    _highText.frame = CGRectMake(highTextX, labelsY, wL2, hL); // one labels width left of the above
    
    // and text
    // set background colour
    _scoreText.textColor = [UIColor blackColor];
    _highText.textColor = [UIColor blackColor];
    _timeLabel.textColor = [UIColor blackColor];
    _highLabel.textColor = [UIColor blackColor];
    
    _scoreText.font = [UIFont fontWithName:@"QuicksandBold-Regular" size:labelFontSize];
    _highText.font = [UIFont fontWithName:@"QuicksandBold-Regular" size:labelFontSize];
    _timeLabel.font = [UIFont fontWithName:@"QuicksandBook-Regular" size:labelFontSize];
    _highLabel.font = [UIFont fontWithName:@"QuicksandBook-Regular" size:labelFontSize];
    
    [_timeLabel setTextAlignment:NSTextAlignmentRight];
    [_highLabel setTextAlignment:NSTextAlignmentRight];
    
    _scoreText.text = [NSString stringWithFormat:NSLocalizedString(@"Score", nil), @(1000000)];
    _highText.text = [NSString stringWithFormat:NSLocalizedString(@"High", nil), @(1000000)];
    
    
    
    // add state label
    _stateLabel = [[UILabel alloc] init];
    _stateLabel.frame = CGRectMake(gridX, gridY, gridWidth, stateHeight);
    _stateLabel.textColor = buttonColour;
    _stateLabel.font = [UIFont fontWithName:@"QuicksandBold-Regular" size:stateFontSize];
    [_stateLabel setTextAlignment:NSTextAlignmentCenter];
    
    
    

    // add all to view, but only for the first time calling them
    [self.view addSubview:_gridButton];
    [self.view addSubview:_grid0];
    [self.view addSubview:_grid1];
    [self.view addSubview:_grid2];
    [self.view addSubview:_grid3];
    [self.view addSubview:_grid4];
    [self.view addSubview:_grid5];
    [self.view addSubview:_grid6];
    [self.view addSubview:_grid7];
    [self.view addSubview:_buttonZ];
    [self.view addSubview:_buttonP];
    [self.view addSubview:_buttonM];
    [self.view addSubview:_scoreText];
    [self.view addSubview:_highText];
    [self.view addSubview:_timeLabel];
    [self.view addSubview:_highLabel];
    [self.view addSubview:_stateLabel];
    
    

    
    // set up new game
    [self newGame];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadResults {
   
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
    NSString *tempString[7];
    int tempScore[7];
    for (int pp=0;pp<7;pp++){
        // if the file already exists
        if ([fileMan fileExistsAtPath: highFile[pp]]) {
            // load high score from file
            NSData *buffer = [fileMan contentsAtPath: highFile[pp]];
            tempString[pp] = [[NSString alloc] initWithData: buffer encoding:NSASCIIStringEncoding];
            tempScore[pp] = [tempString[pp] intValue];
            
        } else {
            // otherwise set it to zero
            tempScore[pp] = 0;
            tempString[pp] = @"0";
        }
    }
    
    // put it where it needs to be
    highScore[0] = tempScore[0];
    highScore[1] = tempScore[1];
    highString[0] = tempString[0];
    highString[1] = tempString[1];
    meanScore[0] = tempScore[2];
    meanScore[1] = tempScore[3];
    samples[0] = tempScore[4];
    samples[1] = tempScore[5];
    phi = tempScore[6];
    
    
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
    
    // collect all the data that needs saving
    NSString *tempString[7];
    tempString[0] = [ [NSString alloc] initWithFormat:@"%d", highScore[0] ];
    tempString[1] = [ [NSString alloc] initWithFormat:@"%d", highScore[1] ];
    tempString[2] = [ [NSString alloc] initWithFormat:@"%d", meanScore[0] ];
    tempString[3] = [ [NSString alloc] initWithFormat:@"%d", meanScore[1] ];
    tempString[4] = [ [NSString alloc] initWithFormat:@"%d", samples[0] ];
    tempString[5] = [ [NSString alloc] initWithFormat:@"%d", samples[1] ];
    tempString[6] = [ [NSString alloc] initWithFormat:@"%d", phi ];
    
    // save the highscores
    NSData *buffer;
    for (int pp=0;pp<7;pp++){
        buffer = [tempString[pp] dataUsingEncoding: NSASCIIStringEncoding];
        [fileMan createFileAtPath: highFile[pp] contents: buffer attributes:nil];
    }
    
}


- (void) loadMusic {
    
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
    
    // if the music should be on, play it
    if (musicState==1){
    
        NSString *musicPath =[[NSBundle mainBundle] pathForResource:@"BitQuest" ofType:@"mp3"];
        NSURL *musicURL = [NSURL fileURLWithPath:musicPath];
        
        NSError *error = nil;
        self.theMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:&error];
        
        self.theMusic.numberOfLoops = -1; //infinite
        
        [self.theMusic play];
        
    }
    
    
}



- (void) newGame {

    // iterate samples
    ++samples[phi];
    // save
    [self saveResults];
    
    // print current score
    _highLabel.text = highString[phi];
    
    // the game is not over, obviously
    gameOver = 0;
    // no cluster of numbers spans te grid
    spanClus = 0;
    
    stateString = @"";
    _stateLabel.text = stateString;
    
    // no moves have been made
    secs = 0;
    secsShown = secs;
    timeString = [NSString stringWithFormat:@"%03d",  secsShown ];
    _timeLabel.text = timeString;

    // the anyons (which are the numbers) are stored in an LxL array (one element for each square in the LxL grid)
    // also, rather than just storing the present set of numbers, those for the last 49 moves are also stored
    // the array 'clusters' identifies the cluster to which each anyon belongs (at the present move)
    // initially, there are no anyons anywhere, so everything is set to zero
    for (int X=0;X<L;X++){
        for (int Y=0;Y<L;Y++){
            anyons[secs%50][X][Y] = 0;
            clusters[X][Y] = 0;
        }
    }
    
    // there are no clusters of numbers
    clusterNum = 0;
    
    // let's make some noise!
    [self generateNoise];
    
    // we check if any clusters of numbers (called 'groups' in the tutorial) span from top to bottom or left to right
    int spanners = 0;
    for (int J=0;J<L;J++){
        for (int K=0;K<L;K++){
            spanners += (clusters[J][0]==clusters[K][L-1])*clusters[J][0];
            spanners += (clusters[0][J]==clusters[L-1][K])*clusters[0][J];
        }
    }
    
    // if some do, this noise was too bad. We try again
    if (spanners>0){
        [self newGame];
    }
    
}


- (void) updateButtons {
    
    
    // This function does what it says on the tin: it updates all buttons
    
    // the difference between secs and secsShown is due to the back-in-time Easter egg.
    // if displaying a past state, the grid text colour is changed
    if (secs==secsShown){
        _grid0.textColor = gridColour;
        _grid1.textColor = gridColour;
        _grid2.textColor = gridColour;
        _grid3.textColor = gridColour;
        _grid4.textColor = gridColour;
        _grid5.textColor = gridColour;
        _grid6.textColor = gridColour;
        _grid7.textColor = gridColour;
    } else {
        _grid0.textColor = gridColourPast;
        _grid1.textColor = gridColourPast;
        _grid2.textColor = gridColourPast;
        _grid3.textColor = gridColourPast;
        _grid4.textColor = gridColourPast;
        _grid5.textColor = gridColourPast;
        _grid6.textColor = gridColourPast;
        _grid7.textColor = gridColourPast;
    }
    
    // display the shown number of moves (which will be less than the real number when we are looking back in time)
    timeString = [NSString stringWithFormat:@"%3d", secsShown];
    _timeLabel.text = timeString;
    
    
//    // for screenshots
//    timeString = [NSString stringWithFormat:@"%3d", 12];
//    _timeLabel.text = timeString;
//    highString[0] = [NSString stringWithFormat:@"%3d", 232];
//    _highLabel.text = highString[0];
    
    NSString *anyonStrings[8][8];
    
    // fill anyonStrings with the right values
    for (int Y=0;Y<L;Y++){
        for (int X=0;X<L;X++){
            
            if (anyons[secsShown%50][X][Y]>0){
                if (phi){
                    if (anyons[secsShown%50][X][Y]==5){
                        anyonStrings[X][Y] = letterLambda;
                    } else {
                        anyonStrings[X][Y] = letterPhi;
                    }
                } else {
                    anyonStrings[X][Y] = [ [NSString alloc] initWithFormat:@"%d", anyons[secsShown%50][X][Y] ];
                }
            } else {
                anyonStrings[X][Y] = @" ";
            }
            
        }
    }
    
    
    
    NSString *lineString[L];
    for (int Y=0;Y<L;Y++){
        lineString[Y] = @"";
        for (int X=0;X<L;X++){
            lineString[Y] = [lineString[Y] stringByAppendingString:@" "];
            lineString[Y] = [lineString[Y] stringByAppendingString:anyonStrings[X][Y]];
            lineString[Y] = [lineString[Y] stringByAppendingString:@" "];
        }
    }
    
    _grid0.text = lineString[0];
    _grid1.text = lineString[1];
    _grid2.text = lineString[2];
    _grid3.text = lineString[3];
    _grid4.text = lineString[4];
    _grid5.text = lineString[5];
    _grid6.text = lineString[6];
    if (L==8){
       _grid7.text = lineString[7];
    }
    
    // when there's a spanning cluster, it's game over
    if ((spanClus>0)&&(secs==secsShown)){
        
        // if it's game over, just put members of the spanning cluster in lineString
        NSString *lineString[L];
        for (int Y=0;Y<L;Y++){
            lineString[Y] = @"";
            for (int X=0;X<L;X++){
                lineString[Y] = [lineString[Y] stringByAppendingString:@" "];
                if (spanClus==clusters[X][Y]){
                    lineString[Y] = [lineString[Y] stringByAppendingString:anyonStrings[X][Y]];
                } else {
                    lineString[Y] = [lineString[Y] stringByAppendingString:@" "];
                }
                lineString[Y] = [lineString[Y] stringByAppendingString:@" "];
            }
        }
        
        
        // then fade to this
        NSString *tempString;
        tempString = lineString[0];
        [UIView transitionWithView:self->_grid0 duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{self->_grid0.text = tempString;} completion:nil];
        tempString = lineString[1];
        [UIView transitionWithView:self->_grid1 duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{self->_grid1.text = tempString;} completion:nil];
        tempString = lineString[2];
        [UIView transitionWithView:self->_grid2 duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{self->_grid2.text = tempString;} completion:nil];
        tempString = lineString[3];
        [UIView transitionWithView:self->_grid3 duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{self->_grid3.text = tempString;} completion:nil];
        tempString = lineString[4];
        [UIView transitionWithView:self->_grid4 duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{self->_grid4.text = tempString;} completion:nil];
        tempString = lineString[5];
        [UIView transitionWithView:self->_grid5 duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{self->_grid5.text = tempString;} completion:nil];
        tempString = lineString[6];
        [UIView transitionWithView:self->_grid6 duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{self->_grid6.text = tempString;} completion:nil];
        if (L==8){
            tempString = lineString[7];
            [UIView transitionWithView:self->_grid7 duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{self->_grid7.text = tempString;} completion:nil];
        }
        
        // and fade in the Game Over message
        stateString = @"GAME OVER";
        [UIView transitionWithView:self->_stateLabel duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{self->_stateLabel.text = stateString;} completion:nil];
        
    }
    
}


- (void) generateNoise {
    

    int x1, x2, y1, y2, r, a, aa;
    double num = 0;
    
    
    // we keep adding in errors until the correct number has been added
    // each error means changing numbers on two neighbouring squares, the changes must add to a multiple of 10
    // an error counts as 1 towards the total when it creates at least one new number, and counts as 0.1 otherwise
    while (num<errorNum[phi]){
        
        
        // pick a random square
        x1 = arc4random()%L;
        y1 = arc4random()%L;
        // pick a random neighbour...
        //..along x direction
        if (prandA()<0.5){
            if ( ( (x1==0) || (x1==(L-1)) ) ) {
                x2 = x1 + (x1==0) - (x1==(L-1));
            } else {
                r = 2*( arc4random() %2 )-1;
                x2 = x1 + r;
            }
            y2 = y1;
            //...along y direction
        } else {
            x2 = x1;
            if ( ( (y1==0) || (y1==(L-1)) ) ) {
                y2 = y1 + (y1==0) - (y1==(L-1));
            } else {
                r = 2*( arc4random() %2 )-1;
                y2 = y1 + r;
            }
        }
        
        // create a random pair and add them in
        if (prandA()<pLambda*phi){
            a = 5;
            aa = 5;
        } else {
            a = 1+(arc4random() %(d-1));
            aa = (d - a)%d;
        }
        
        // the numbers are put in the corresponding elements of the matrix 'anyons', which stores all the numbers
        // if both numbers are new, they are a new cluster
        // they become the cluster numbered clusterNum=clusterNum+1
        // the cluster num is put in the corresponding entries of 'clusters'
        if ((anyons[secs%50][x1][y1]==0)&&(anyons[secs%50][x2][y2]==0)){
            anyons[secs%50][x1][y1] = a;
            anyons[secs%50][x2][y2] = aa;
            ++ clusterNum;
            clusters[x1][y1] = clusterNum;
            clusters[x2][y2] = clusterNum;
            ++num;
        // if one of the squares already had a number in, the error just adds to this cluster
        } else if ((anyons[secs%50][x1][y1]==0)&&(anyons[secs%50][x2][y2]>0)){
            anyons[secs%50][x1][y1] = (a + anyons[secs%50][x1][y1])%d;
            anyons[secs%50][x2][y2] = (aa + anyons[secs%50][x2][y2])%d;
            clusters[x1][y1] = clusters[x2][y2];
            clusters[x2][y2] = clusters[x2][y2]*(anyons[secs%50][x2][y2]>0);
            ++num;
        } else if ((anyons[secs%50][x1][y1]>0)&&(anyons[secs%50][x2][y2]==0)){
            anyons[secs%50][x1][y1] = (a + anyons[secs%50][x1][y1])%d;
            anyons[secs%50][x2][y2] = (aa + anyons[secs%50][x2][y2])%d;
            clusters[x2][y2] = clusters[x1][y1];
            clusters[x1][y1] = clusters[x1][y1]*(anyons[secs%50][x1][y1]>0);
            ++num;
        // if both already had numbers in, and belong to the same cluster, the results also belong to that cluster
        // if they belonged to different clusters, the clusters are merged
        } else if ((anyons[secs%50][x1][y1]>0)&&(anyons[secs%50][x2][y2]>0)){
            // then do the adding
            int clusterOld = clusters[x2][y2];
            for (int Y=0;Y<L;Y++){
                for (int X=0;X<L;X++){
                    if (clusters[X][Y]==clusterOld){
                        clusters[X][Y] = clusters[x1][y1];
                    }
                }
            }
            anyons[secs%50][x1][y1] = (a + anyons[secs%50][x1][y1])%d;
            anyons[secs%50][x2][y2] = (aa + anyons[secs%50][x2][y2])%d;
            clusters[x1][y1] = clusters[x1][y1]*(anyons[secs%50][x1][y1]>0);
            clusters[x2][y2] = clusters[x2][y2]*(anyons[secs%50][x2][y2]>0);
            // these are counted less towards num
            num += 0.1;
            
        }

        
    }
    
    // now print to buttons
    [self updateButtons];
    
}

// this function works out what move to make once a swipe is made (and so after the touch up)
- (void) gridPress {
   
    // Initially Xu and Yu are the x and y coordinates for the square where the touch up occurred
    // Xd and Yd are those for the touch down
    
    // At the end, they will tranformed into the coordinates that a number is being moved to (for Xu and Yu) and from (Xd and Yd)
    
    // Ideally, this function wouldn't need to do anything, but it accounts for the user being a bit rubbish
    
    
    
    // determine the direction of movement
    
    // preliminaries
    double dx = fabs(xu-xd);
    double dy = fabs(yu-yd);
    int dX = 0;
    int dY = 0;
    
    // if movement in one direction is dominant, and it goes far enough to cross between squares, that's the direction
    if (dx>1.5*dy){
        dX = ( (xu>xd) - (xd>xu) ) * (Xu!=Xd);
    } else if (dy>1.5*dx) {
        dY = ( (yu>yd) - (yd>yu) ) * (Yu!=Yd);
    }
    
    // to ensure that only one move is done, move the up to one along in the direction from the down
    Xu = Xd + dX;
    Yu = Yd + dY;
    
    // if nothing is in the touch down square, maybe they touched down early. If the neighbouring square in the direction is filled, move the touch down and touch up along
    // note: the numbers after secs moves are stored at secs%50
    if ( (anyons[secs%50][Xd][Yd]==0) && (anyons[secs%50][Xd+dX][Yd+dY]>0) ) {
        Xd += dX;
        Yd += dY;
        Xu += dX;
        Yu += dY;
    }
    
    // check that coords are within bounds and proceed only if so
    int valid  = (Yd>=0)*(Yd<L)*(Xd>=0)*(Xd<L)*(Yu>=0)*(Yu<L)*(Xu>=0)*(Xu<L);
    
    if (valid) {
        
        if ((Xu==Xd)&&(Yu==Yd)){
            
          if((secsShown<secs)||(tu-td>2)){
                if ((Xu<=3)&&(secsShown>0)&&(secs-secsShown<50)){
                    
                    --secsShown;
                    [self updateButtons];
                    
                }
                else if ((Xu>3)&&(secsShown<secs)){
                    
                    ++secsShown;
                    [self updateButtons];
                    
                }
          }
            
        } else {
            if (secsShown!=secs){
                
                secsShown = secs;
                [self updateButtons];
                
            } else {
                
                if ((anyons[secs%50][Xd][Yd]>0)&&(gameOver==0)){
                    [self mover];
                }
                
            }
        }
  
    }

    
    
    
}


- (void) countMoves {
    
    // this is where time (the number of moves) gets incremented
    secs += 1;
    
    // copy anyon values over from last step
    for (int X=0;X<L;X++){
        for (int Y=0;Y<L;Y++){
            anyons[secs%50][X][Y] = anyons[(secs-1)%50][X][Y];
        }
    }
    secsShown = secs;
    
    
}



- (void) mover {
    
    // basically, this does the move, updates the numbers and clusters, and checks to see if the game is over

    
    [self countMoves];
    
    
    
    // if the destination has an anyon of a different cluster, merge its cluster with the one being moved
    if ((anyons[secs%50][Xu][Yu]>0)&&(clusters[Xu][Yu]!=clusters[Xd][Yd])){
        int clusterOld = clusters[Xd][Yd];
        for (int Y=0;Y<L;Y++){
            for (int X=0;X<L;X++){
                if (clusters[X][Y]==clusterOld){
                    clusters[X][Y] = clusters[Xu][Yu];
                }
            }
        }
        
    }
    // add it to the destination
    anyons[secs%50][Xu][Yu] = (anyons[secs%50][Xu][Yu] + anyons[secs%50][Xd][Yd])%d;
    // carry the cluster with it, except for the case ofannihilation
    clusters[Xu][Yu] = clusters[Xd][Yd]*(anyons[secs%50][Xu][Yu]>0);
    // remove it from the initial position
    anyons[secs%50][Xd][Yd] = 0;
    clusters[Xd][Yd] = 0;
    
    

    
    // see how many clusters span the grid
    int spanners = 0;
    for (int J=0;J<L;J++){
        for (int K=0;K<L;K++){
            if ((clusters[J][0]==clusters[K][L-1])&&(clusters[J][0]>0)){
                ++spanners;
                spanClus = clusters[J][0];
            }
            if ((clusters[0][J]==clusters[L-1][K])&&(clusters[0][J]>0)){
                ++spanners;
                spanClus = clusters[0][J];
            }
        }
    }

    
    // if a cluster spans the grid, stop
    if (spanners>0){
        gameOver = 1;
        
        // update high score
        highScore[phi] = MAX(highScore[phi],secs);
        highString[phi] = [ [NSString alloc] initWithFormat:@"%d", highScore[phi] ];
        _highLabel.text = highString[phi];
        
        // update the sum of scores
        meanScore[phi] += secs;
        
        // save to file
        [self saveResults];
        
    } else {
        
        // count number of bulk anyons
        int anyonNum = 0;
        for (int Y=0;Y<L;Y++){
            for (int X=0;X<L;X++){
                anyonNum += (anyons[secs%50][X][Y]>0);
            }
        }
        
        // if no anyons remain
        if (anyonNum==0){
            // skip to the end of the minute
            while ((secs%errorRate[phi])>0){
                [self countMoves];
            }
        }
        
        // if a minute has passed, generate more noise
        if (secs%errorRate[phi]==0){
            [self generateNoise];
        }
        
        
    }

    [self updateButtons];
    
    
}


- (IBAction)bigDown:(id)sender forEvent:(UIEvent *)event {
    
    // get the X and Y of the touch down
    UIView *button = (UIView *)sender;
    UITouch *touch = [[event touchesForView:button] anyObject];
    CGPoint location = [touch locationInView:button];
    
    xd = (double)location.x;
    yd = (double)location.y;
    
    td = [[NSDate date] timeIntervalSince1970];
    
    Yd = ( yd )/hC;
    Xd = ( xd )/wC;
    
}

- (IBAction)bigUp:(id)sender forEvent:(UIEvent *)event {
    
    
    // get the X and Y of the touch up
    UIView *button = (UIView *)sender;
    UITouch *touch = [[event touchesForView:button] anyObject];
    CGPoint location = [touch locationInView:button];
    
    xu = (double)location.x;
    yu = (double)location.y;
    
    tu = [[NSDate date] timeIntervalSince1970];
    
    Yu = ( yu )/hC;
    Xu = ( xu )/wC;

    //if (gameOver==0){
        [self gridPress];
    //}
    
}

- (IBAction)bigOut:(id)sender forEvent:(UIEvent *)event {
    
    
    // get the X and Y of the touch up
    UIView *button = (UIView *)sender;
    UITouch *touch = [[event touchesForView:button] anyObject];
    CGPoint location = [touch locationInView:button];
    
    xu = (double)location.x;
    yu = (double)location.y;
    
    tu = [[NSDate date] timeIntervalSince1970];
    
    Yu = ( yu )/hC;
    Xu = ( xu )/wC;
    
    // if outside the box, push back in
    if (Xu<0){
        Xu = 0;
    }
    if (Xu>(L-1)){
        Xu = L-1;
    }
    if (Yu<0){
        Yu = 0;
    }
    if (Yu>(L-1)){
        Yu = L-1;
    }
    
    //if (gameOver==0){
        [self gridPress];
    //}
}



- (IBAction)mediumZ:(id)sender {
    phi = 0;
    [self newGame];
}


- (IBAction)mediumP:(id)sender {
    phi = 1;
    [self newGame];
}

- (IBAction)menuButton:(id)sender {

    [self performSegueWithIdentifier:@"fromGame" sender:self];
    
}





@end
