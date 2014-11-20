//
//  PauseGameViewController.m
//  SpeedTap
//
//  Created by student on 11/12/14.
//  Copyright (c) 2014 Aaron Robinson. All rights reserved.
//

#import "PauseGameViewController.h"
#import "GameBrain.h"

@interface PauseGameViewController ()

@property(nonatomic) UILabel *pauseLabel;
@property(nonatomic) GameBrain *gameBrain;

@end

@implementation PauseGameViewController

- (void)viewDidLoad
{
    //[super viewDidLoad];
    
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    self.gameBrain = [[GameBrain alloc] init];

    [self.view setBackgroundColor:[UIColor clearColor]];

    // Create title label for Pause screen
    self.pauseLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, 80)];
    [self.pauseLabel setCenter:CGPointMake(frame.size.width / 2, frame.size.height / 2)];
    [self.pauseLabel setTextAlignment:NSTextAlignmentCenter];
    [self.pauseLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:40.0f]];
    [self.pauseLabel setTextColor:[UIColor whiteColor]];
    //[self.view setBackgroundColor:[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:0.8]];
    //[self setBackgroundColor:[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:0.25]];
    //[self.pauseLabel setBackgroundColor:[UIColor clearColor]];
    [self.pauseLabel setText:@"Game Paused"];
    [self.view addSubview:self.pauseLabel];
}

@end
