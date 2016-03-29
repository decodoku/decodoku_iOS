//
//  ResultsViewController.h
//  decode:active_v2
//
//  Copyright © 2016 James R. Wootton.

#import <UIKit/UIKit.h>

@interface ResultsViewController : UIViewController


@property (strong, nonatomic) IBOutlet UILabel *sampleZ;

@property (strong, nonatomic) IBOutlet UILabel *highZ;

@property (strong, nonatomic) IBOutlet UILabel *meanZ;


@property (strong, nonatomic) IBOutlet UILabel *sampleP;

@property (strong, nonatomic) IBOutlet UILabel *highP;

@property (strong, nonatomic) IBOutlet UILabel *meanP;


- (IBAction)deleteZ:(id)sender;

- (IBAction)deleteP:(id)sender;


@end

