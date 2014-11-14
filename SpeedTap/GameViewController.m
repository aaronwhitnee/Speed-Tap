//
//  GameViewController.m
//  SpeedTap
//
//  Created by Aaron Robinson on 11/6/14.
//  Copyright (c) 2014 Aaron Robinson. All rights reserved.
//

#import "GameViewController.h"
#import "GameBrain.h"
#import "TransitionalScreenViewController.h"
#import "PauseGameViewController.h"

@interface GameViewController () {
    //enum {win = 0, lose, running, waiting};
}

@property(strong, nonatomic) NSArray *pointsArray;
@property(nonatomic) GameBrain *gameBrain;
@property(nonatomic) NSTimer *timer;
@property(nonatomic) UIButton *continueButton;
@property(nonatomic) UIButton *pauseButton;
@property(nonatomic) TransitionalScreenViewController *tvc;
@property(nonatomic) PauseGameViewController *pgvc;

-(void) generateRandomBackgroundColor;
-(void) moveButtonRandomly;
-(void) updateTapCounter;
-(void) updateTimer;
-(void) presentTransitionalViewController;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect mainRect = [[UIScreen mainScreen] applicationFrame];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    // Initialize the game
    self.gameBrain = [GameBrain sharedInstance];
    
    // Create Tap button
    self.myButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 60.0, 60.0)];
    [self.myButton setBackgroundColor:[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:0.25]];
    [self.myButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.buttonCenter = CGPointMake(CGRectGetMidX(mainRect), CGRectGetMidY(mainRect)-25);
    [self.myButton setCenter:self.buttonCenter];
    [self.myButton setTitle:@"Tap" forState:UIControlStateNormal];
    // Transform button into a circle
    self.myButton.clipsToBounds = YES;
    self.myButton.layer.cornerRadius = self.myButton.frame.size.height / 2.0f;
    self.myButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.myButton.layer.borderWidth = 2.0f;
    
    [self.view addSubview:self.myButton];
    
    // Tap counter
    self.tapCounterLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, mainRect.size.width, 150)];
    [self.tapCounterLabel setCenter:CGPointMake(CGRectGetMidX(mainRect), CGRectGetMidY(mainRect)-25)];
    [self.tapCounterLabel setTextAlignment:NSTextAlignmentCenter];
    [self.tapCounterLabel setFont:[UIFont fontWithName:@"Futura-CondensedExtraBold" size:100.0f]];
    [self.tapCounterLabel setTextColor:[UIColor whiteColor]];
    [self.tapCounterLabel setAlpha:0.5];
    [self.tapCounterLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.tapCounterLabel];
    
    // Goal tap number
    self.goalTapLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, mainRect.size.width, 150)];
    [self.goalTapLabel setCenter:CGPointMake(CGRectGetMidX(mainRect), CGRectGetMidY(mainRect)+200)];
    [self.goalTapLabel setTextAlignment:NSTextAlignmentCenter];
    [self.goalTapLabel setFont:[UIFont fontWithName:@"Futura-CondensedExtraBold" size:20.0f]];
    [self.goalTapLabel setTextColor:[UIColor whiteColor]];
    [self.goalTapLabel setAlpha:0.5];
    [self.goalTapLabel setBackgroundColor:[UIColor clearColor]];
    [self.goalTapLabel setText:[NSString stringWithFormat:@"GOAL: %i", self.gameBrain.goalTapNum]];
    [self.view addSubview:self.goalTapLabel];
    
    // Timer label
    self.timerLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, mainRect.size.width, 150)];
    [self.timerLabel setCenter:CGPointMake(CGRectGetMidX(mainRect), 50)];
    [self.timerLabel setTextAlignment:NSTextAlignmentCenter];
    [self.timerLabel setFont:[UIFont fontWithName:@"Futura-CondensedExtraBold" size:20.0f]];
    [self.timerLabel setTextColor:[UIColor whiteColor]];
    [self.timerLabel setAlpha:0.5];
    [self.timerLabel setBackgroundColor:[UIColor clearColor]];
    [self.timerLabel setText:[NSString stringWithFormat:@"%i.00", self.gameBrain.secondsLeft]];
    [self.view addSubview:self.timerLabel];
    
    // Create Continue button
    self.continueButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 100, 40)];
    [self.continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[self.continueButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.continueButton.center = CGPointMake(mainRect.size.width / 2.0, mainRect.size.height - 50);
    // Transform button appearance
    self.continueButton.clipsToBounds = YES;
    self.continueButton.layer.cornerRadius = self.continueButton.frame.size.height / 4.0f;
    self.continueButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.continueButton.layer.borderWidth = 2.0f;
    [self.continueButton addTarget:self action:@selector(didPressContinueButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // Create Pause button
    self.pauseButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 60, 25)];
    [self.pauseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[self.continueButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.pauseButton.center = CGPointMake(mainRect.size.width - 50, 50);
    // Transform button appearance
    self.pauseButton.clipsToBounds = YES;
    self.pauseButton.layer.cornerRadius = self.pauseButton.frame.size.height / 4.0f;
    self.pauseButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.pauseButton.layer.borderWidth = 2.0f;
    [self.pauseButton setAlpha:0.75];
    [self.pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    [self.pauseButton.titleLabel setFont:[UIFont fontWithName:@"Futura-CondensedExtraBold" size:15.0f]];
    [self.pauseButton addTarget:self action:@selector(didPressPauseButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // Call myButtonPressed on button tap
    [self.myButton addTarget:self action:@selector(myButtonPressed:)
            forControlEvents:UIControlEventTouchUpInside];
}

-(void) resetGameView
{
    CGRect mainRect = [[UIScreen mainScreen] applicationFrame];

    // Reset game view with quick animation
    [UIView animateWithDuration:0.5 animations:^{
        // Reset background to black
        [self.view setBackgroundColor:[UIColor blackColor]];
        // Move Tap button back to center of screen
        [self.myButton setCenter:CGPointMake(CGRectGetMidX(mainRect), CGRectGetMidY(mainRect)-25)];
        // Reset tap counter label
        [self.tapCounterLabel setText:@""];
        // Reset goal tap number label
        [self.goalTapLabel setText:[NSString stringWithFormat:@"GOAL: %i", self.gameBrain.goalTapNum]];
        // Reset timer label
        [self.timerLabel setText:[NSString stringWithFormat:@"%i.00", self.gameBrain.secondsLeft]];
    }];
    NSLog(@"Reset the game view for level %i", self.gameBrain.level);
}

- (void) myButtonPressed:(UIButton *) sender
{
    // Start game if button is pressed for the first time
    if (self.gameBrain.gameState == waiting) {
        [self.gameBrain startGame];
        [self.view addSubview:self.pauseButton];
        // Start the Timer with 1/100th (centisecond) accuracy... because it's more exciting
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    }
    
    // Update game brain's tap counter and the tap counter label
    [self updateTapCounter];
    
    // Call random color generator to change background color
    [UIView animateWithDuration:0.5 animations:^{
        [self generateRandomBackgroundColor];
    }];
    
    // Call random CGPoint generator to move button to new random position
    [UIView animateWithDuration:0.1 animations:^{
        [self moveButtonRandomly];
    }];
    
    // Checking if game has been won by reaching goal tap count
    if (self.gameBrain.gameState == win) {
        [self presentTransitionalViewController];
    }
}

-(void) updateTimer
{
    [self.gameBrain decrementTime];
    [self.timerLabel setText:[NSString stringWithFormat:(self.gameBrain.centisecondsLeft < 10 ? @"%i.%i0" : @"%i.%i"),
                              self.gameBrain.secondsLeft, self.gameBrain.centisecondsLeft]];
    
    if (self.gameBrain.gameState == win || self.gameBrain.gameState == lose)
        [self presentTransitionalViewController];
}

-(void) presentTransitionalViewController
{
    [self.timer invalidate];
    self.timer = nil;
    [self.pauseButton removeFromSuperview];
    
    NSString *buttonText = [[NSString alloc] init];
    if (self.gameBrain.gameState == win) {
        buttonText = [NSString stringWithFormat:@"Level %i", self.gameBrain.level + 1];
    }
    else
        buttonText = @"Retry";
    [self.continueButton setTitle: buttonText forState:UIControlStateNormal];
    
    self.tvc = [[TransitionalScreenViewController alloc] init];
    [self.tvc.view addSubview:self.continueButton];
    [self.view addSubview:self.tvc.view];
}

-(void) didPressContinueButton: (UIButton *) selector
{
    NSLog(@"Pressed continue button!");
    if (self.gameBrain.gameState == win) {
        [self.gameBrain startNextLevel];
        [self resetGameView];
        [self.tvc.view removeFromSuperview];
    }
    else if(self.gameBrain.gameState == lose) {
        [self.gameBrain retryCurrentLevel];
        [self resetGameView];
        [self.tvc.view removeFromSuperview];
    }
    else if(self.gameBrain.gameState == waiting){
        [self.gameBrain startGame];
        [self.view addSubview:self.pauseButton];
        [self.pgvc.view removeFromSuperview];
    }
}

-(void) didPressPauseButton: (UIButton *) selector
{
    NSLog(@"Pressed pause button.");
    [self.pauseButton removeFromSuperview];
    [self.gameBrain pauseGame];
    [self.continueButton setTitle:@"Unpause" forState:UIControlStateNormal];
    self.pgvc = [[PauseGameViewController alloc] init];
    [self.pgvc.view addSubview:self.continueButton];
    [self.view addSubview:self.pgvc.view];
}

-(void) generateRandomBackgroundColor
{
    srand((int)time(NULL));

    CGFloat red = (rand() / (float) RAND_MAX) * 0.5 + 0.3;
    CGFloat green = (rand() / (float) RAND_MAX) * 0.5 + 0.3;
    CGFloat blue = (rand() / (float) RAND_MAX) * 0.5 + 0.3;
    /*
    while (red > 0.8 || red < 0.3) {
        red = rand() / (float) RAND_MAX;
    }
    while (green > 0.8 || green < 0.3) {
        green = rand() / (float) RAND_MAX;
    }
    while (blue > 0.8 || blue < 0.3) {
        blue = rand() / (float) RAND_MAX;
    }
     */
    
    NSLog(@"R:%f, G:%f, B:%f", red, green, blue);
    
    UIColor *randomColor = [UIColor colorWithRed:(red) green:(green) blue:(blue) alpha:(1.0)];
    [self.view setBackgroundColor:randomColor];
    //NSLog(@"Generated color: %@", randomColor);
}

-(void) moveButtonRandomly
{
    /*
     // Using random points (no fixed point grid)
     CGRect mainRect = [[UIScreen mainScreen] applicationFrame];
     CGPoint randPoint = mainRect.origin;
     
     int highestX = mainRect.size.width;
     int highestY = mainRect.size.height;
     int xPadding = (self.myButton.frame.size.width / 2) + 10;
     int yPadding = (self.myButton.frame.size.height / 2) + 10;
     
     randPoint.x = xPadding + arc4random_uniform(highestX - (2 * xPadding));
     randPoint.y = yPadding + arc4random_uniform(highestY - (2 * yPadding));
     
     self.buttonCenter = randPoint;
     [self.myButton setCenter:self.buttonCenter];
     */
    
    // Using fixed points on grid (points in pointsArray)
    int randIndex = arc4random_uniform(12);
    NSValue *value = [self.gameBrain.pointsArray objectAtIndex:randIndex];
    CGPoint gridPoint = [value CGPointValue];
    while (CGPointEqualToPoint(self.buttonCenter, gridPoint)) {
        randIndex = arc4random_uniform(12);
        value = [self.gameBrain.pointsArray objectAtIndex:randIndex];
        gridPoint = [value CGPointValue];
    }
    self.buttonCenter = gridPoint;
    [self.myButton setCenter:self.buttonCenter];
}

-(void) updateTapCounter
{
    [self.gameBrain incrementTapCount];
    [self.tapCounterLabel setText:[NSString stringWithFormat:@"%i", self.gameBrain.currentTapCount]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
