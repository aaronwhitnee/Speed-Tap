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
@property(nonatomic) UILabel *remainingTimeLabel;
@property(nonatomic) UILabel *totalScoreLabel;
@property(nonatomic) NSString *timeString;
@property(nonatomic) NSString *totalScoreString;
@property(nonatomic) GameBrain *gameBrain;
@property(nonatomic) NSTimer *timer;

@property(atomic) int levelNum;
@property(atomic) int seconds;
@property(atomic) int centiseconds;
@property(atomic) int totalScore;


@end

@implementation TransitionalScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    
    self.gameBrain = [GameBrain sharedInstance];

    //[self.view setBackgroundColor:[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:0.8]];
    
    // Create Label for Current Level
    self.levelLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, 80)];
    [self.levelLabel setCenter:CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) / 2 - 20)];
    [self.levelLabel setTextAlignment:NSTextAlignmentCenter];
    [self.levelLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:40.0f]];
    [self.levelLabel setTextColor:[UIColor whiteColor]];
    //[self.levelLabel setAlpha:0.5];
    [self.levelLabel setBackgroundColor:[UIColor clearColor]];
    [self.levelLabel setText:[NSString stringWithFormat:@"Level %i", self.gameBrain.level]];
    [self.view addSubview:self.levelLabel];
    
    // Create Label saying if player won or lost current level
    self.winLoseLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, 80)];
    [self.winLoseLabel setCenter:CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(self.levelLabel.frame) + 50)];
    [self.winLoseLabel setTextAlignment:NSTextAlignmentCenter];
    [self.winLoseLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:60.0f]];
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
    [self.levelScoreLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:40.0f]];
    [self.levelScoreLabel setTextColor:[UIColor whiteColor]];
    //[self.levelScoreLabel setAlpha:0.5];
    [self.levelScoreLabel setBackgroundColor:[UIColor clearColor]];
    [self.levelScoreLabel setText:[NSString stringWithFormat:@"%i/%i Taps", self.gameBrain.levelScore, self.gameBrain.goalTapNum]];
    [self.view addSubview:self.levelScoreLabel];
    
    // Create Label for Ramaining Time
    self.remainingTimeLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, 80)];
    [self.remainingTimeLabel setCenter:CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(self.levelScoreLabel.frame) + 60)];
    [self.remainingTimeLabel setTextAlignment:NSTextAlignmentCenter];
    [self.remainingTimeLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:20.0f]];
    [self.remainingTimeLabel setTextColor:[UIColor whiteColor]];
    [self.remainingTimeLabel setBackgroundColor:[UIColor clearColor]];
    self.timeString = [NSString stringWithFormat:(self.gameBrain.centisecondsLeft < 10 ? @"%i.0%i\"" : @"%i.%i\""),
                            self.gameBrain.secondsLeft, self.gameBrain.centisecondsLeft];
    [self.remainingTimeLabel setText:[NSString stringWithFormat:@"Time Remaining: %@", self.timeString]];
    [self.view addSubview:self.remainingTimeLabel];
    
    // Create Label for Total Score
    self.totalScoreLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, 80)];
    [self.totalScoreLabel setCenter:CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(self.remainingTimeLabel.frame) + 40)];
    [self.totalScoreLabel setTextAlignment:NSTextAlignmentCenter];
    [self.totalScoreLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:20.0f]];
    [self.totalScoreLabel setTextColor:[UIColor whiteColor]];
    //[self.levelScoreLabel setAlpha:0.5];
    [self.totalScoreLabel setBackgroundColor:[UIColor clearColor]];
    if (self.gameBrain.gameState == win) {
        self.totalScoreString = [NSString stringWithFormat:@"Score: %i", self.gameBrain.totalScore];
    }
    else
        self.totalScoreString = @"You gotta move a little faster!";
    [self.totalScoreLabel setText:self.totalScoreString];
    [self.view addSubview:self.totalScoreLabel];
    
    self.seconds = self.gameBrain.secondsLeft;
    self.centiseconds = self.gameBrain.centisecondsLeft;
    self.totalScore = self.gameBrain.totalScore + 1;
    
    NSLog(@"Total calculated in view controller: %i", self.centiseconds + (100 * self.seconds));
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(incrementTotalScoreAnimated) userInfo:nil repeats:YES];
    [self.timer setTolerance:0.05];
}

-(void) incrementTotalScoreAnimated
{
    // For every 1 centisecond left, add 1 to total score
    if (self.centiseconds == 0)
    {
        if (self.seconds == 0) {
            [self.timer invalidate];
            self.timer = nil;
        }
        else
        {
            self.seconds--;
            self.centiseconds = 99;
            self.timeString = [NSString stringWithFormat:(self.centiseconds < 10 ? @"%i.0%i\"" : @"%i.%i\""),
                                self.seconds, self.centiseconds];
            [self.remainingTimeLabel setText:[NSString stringWithFormat:@"Time Remaining: %@", self.timeString]];
            self.totalScoreString = [NSString stringWithFormat:@"Score: %i", self.totalScore++];
            [self.totalScoreLabel setText:self.totalScoreString];
        }
    }
    else {
        self.centiseconds--;
        self.timeString = [NSString stringWithFormat:(self.centiseconds < 10 ? @"%i.0%i\"" : @"%i.%i\""),
                            self.seconds, self.centiseconds];
        [self.remainingTimeLabel setText:[NSString stringWithFormat:@"Time Remaining: %@", self.timeString]];
        self.totalScoreString = [NSString stringWithFormat:@"Score: %i", self.totalScore++];
        [self.totalScoreLabel setText:self.totalScoreString];
    }
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
