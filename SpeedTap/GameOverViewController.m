//
//  GameOverViewController.m
//  SpeedTap
//
//  Created by student on 12/1/14.
//  Copyright (c) 2014 Aaron Robinson. All rights reserved.
//

#import "GameOverViewController.h"
#import "GameBrain.h"
#import "FXBlurView.h"

@interface GameOverViewController ()

@property (nonatomic) UILabel *levelLabel;
@property(nonatomic) UILabel *gameOverLabel;
@property(nonatomic) UILabel *levelScoreLabel;
@property(nonatomic) UILabel *remainingTimeLabel;
@property(nonatomic) UILabel *totalScoreLabel;
@property(nonatomic) NSString *timeString;
@property(nonatomic) NSString *totalScoreString;
@property(nonatomic) FXBlurView *blurredView;
@property(nonatomic) GameBrain *gameBrain;

@end

@implementation GameOverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.gameBrain = [GameBrain sharedInstance];
    
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    
    // Create Game Over label
    self.gameOverLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, 80)];
    [self.gameOverLabel setCenter:CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) - 50)];
    [self.gameOverLabel setTextAlignment:NSTextAlignmentCenter];
    [self.gameOverLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:60.0f]];
    [self.gameOverLabel setTextColor:[UIColor whiteColor]];
    //[self.gameOverLabel setAlpha:0.5];
    [self.gameOverLabel setBackgroundColor:[UIColor clearColor]];
    [self.gameOverLabel setText:@"Game Over"];
    [self.view addSubview:self.gameOverLabel];
    
    // Create Label for Total Score
    self.totalScoreLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, 80)];
    [self.totalScoreLabel setCenter:CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(self.gameOverLabel.frame) + 40)];
    [self.totalScoreLabel setTextAlignment:NSTextAlignmentCenter];
    [self.totalScoreLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:20.0f]];
    [self.totalScoreLabel setTextColor:[UIColor whiteColor]];
    //[self.levelScoreLabel setAlpha:0.5];
    [self.totalScoreLabel setBackgroundColor:[UIColor clearColor]];
    self.totalScoreString = [NSString stringWithFormat:@"Score: %i", self.gameBrain.totalScore];
    [self.totalScoreLabel setText:self.totalScoreString];
    [self.view addSubview:self.totalScoreLabel];
    
    // Prepare FXBlurView for blurred effect behind PauseGameViewController and TransitionalScreenViewController
    self.blurredView = [[FXBlurView alloc] initWithFrame:frame];
    [self.blurredView setTintColor:[UIColor clearColor]];
    [self.blurredView setBlurRadius:15.0];
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
