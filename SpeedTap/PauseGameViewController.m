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
    [super viewDidLoad];
    
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    self.gameBrain = [[GameBrain alloc] init];

    // Create Label for Current Level
    self.pauseLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, 80)];
    [self.pauseLabel setCenter:CGPointMake(CGRectGetMidX(frame), 50)];
    [self.pauseLabel setTextAlignment:NSTextAlignmentCenter];
    [self.pauseLabel setFont:[UIFont fontWithName:@"Futura-CondensedExtraBold" size:40.0f]];
    [self.pauseLabel setTextColor:[UIColor whiteColor]];
    //[self.levelLabel setAlpha:0.5];
    [self.pauseLabel setBackgroundColor:[UIColor clearColor]];
    [self.pauseLabel setText:[NSString stringWithFormat:@"Level %i", self.gameBrain.level]];
    [self.view addSubview:self.pauseLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
