//
//  TransitionalScreenViewController.m
//  SpeedTap
//
//  Created by student on 11/10/14.
//  Copyright (c) 2014 Aaron Robinson. All rights reserved.
//

#import "TransitionalScreenViewController.h"
#import "GameViewController.h"

@interface TransitionalScreenViewController ()

@property(nonatomic) UILabel *winLoseLabel;
@property(nonatomic) UILabel *levelLabel;
@property(nonatomic) UILabel *levelScoreLabel;
@property(nonatomic) UILabel *totalScoreLabel;
@property(nonatomic) GameBrain *gameBrain;

@property(atomic) int levelNum;
@property(atomic) int score;

@end

@implementation TransitionalScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    
    self.gameBrain = [GameBrain sharedInstance];

    [self.view setBackgroundColor:[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:0.8]];
    
    // Create Label for Current Level
    self.levelLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, 80)];
    [self.levelLabel setCenter:CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) / 2 - 20)];
    [self.levelLabel setTextAlignment:NSTextAlignmentCenter];
    [self.levelLabel setFont:[UIFont fontWithName:@"Futura-CondensedExtraBold" size:40.0f]];
    [self.levelLabel setTextColor:[UIColor whiteColor]];
    //[self.levelLabel setAlpha:0.5];
    [self.levelLabel setBackgroundColor:[UIColor clearColor]];
    [self.levelLabel setText:[NSString stringWithFormat:@"Level %i", self.gameBrain.level]];
    [self.view addSubview:self.levelLabel];
    
    // Create Label saying if player won or lost current level
    self.winLoseLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, 80)];
    [self.winLoseLabel setCenter:CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(self.levelLabel.frame) + 50)];
    [self.winLoseLabel setTextAlignment:NSTextAlignmentCenter];
    [self.winLoseLabel setFont:[UIFont fontWithName:@"Futura-CondensedExtraBold" size:60.0f]];
    [self.winLoseLabel setTextColor:[UIColor whiteColor]];
    //[self.winLoseLabel setAlpha:0.5];
    [self.winLoseLabel setBackgroundColor:[UIColor clearColor]];
    if (self.gameBrain.gameState == win) {
        [self.winLoseLabel setText:@"Passed!"];
    }
    else
        [self.winLoseLabel setText:@"Failed!"];
    [self.view addSubview:self.winLoseLabel];
    
    // Create Label for Current Level's score
    self.levelScoreLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, 80)];
    [self.levelScoreLabel setCenter:CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(self.winLoseLabel.frame) + 60)];
    [self.levelScoreLabel setTextAlignment:NSTextAlignmentCenter];
    [self.levelScoreLabel setFont:[UIFont fontWithName:@"Futura-CondensedExtraBold" size:40.0f]];
    [self.levelScoreLabel setTextColor:[UIColor whiteColor]];
    //[self.levelScoreLabel setAlpha:0.5];
    [self.levelScoreLabel setBackgroundColor:[UIColor clearColor]];
    [self.levelScoreLabel setText:[NSString stringWithFormat:@"%i/%i Taps", self.gameBrain.levelScore, self.gameBrain.goalTapNum]];
    [self.view addSubview:self.levelScoreLabel];
    
    // Create Label for Total Score
    self.totalScoreLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, 80)];
    [self.totalScoreLabel setCenter:CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(self.levelScoreLabel.frame) + 80)];
    [self.totalScoreLabel setTextAlignment:NSTextAlignmentCenter];
    [self.totalScoreLabel setFont:[UIFont fontWithName:@"Futura-CondensedExtraBold" size:20.0f]];
    [self.totalScoreLabel setTextColor:[UIColor whiteColor]];
    //[self.levelScoreLabel setAlpha:0.5];
    [self.totalScoreLabel setBackgroundColor:[UIColor clearColor]];
    NSString *totalScoreString;
    if (self.gameBrain.gameState == win) {
        totalScoreString = [NSString stringWithFormat:@"Total Score: %i", self.gameBrain.totalScore + self.gameBrain.levelScore];
    }
    else
        totalScoreString = @"C'mon, you can go faster!";
    [self.totalScoreLabel setText:totalScoreString];
    [self.view addSubview:self.totalScoreLabel];
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
