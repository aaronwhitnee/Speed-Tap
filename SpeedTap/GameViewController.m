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
#import "FXBlurView.h"

@interface GameViewController () {
}

@property(strong, nonatomic) NSArray *pointsArray;
@property(nonatomic) GameBrain *gameBrain;
@property(nonatomic) NSTimer *timer;
@property(nonatomic) UIButton *continueButton;
@property(nonatomic) UIButton *pauseButton;
@property(nonatomic) UIButton *homeButton;
@property(nonatomic) NSMutableArray *lifeHearts;
@property(nonatomic) UIView *lifeHeartsContainerView;
@property(nonatomic) FXBlurView *blurredView;
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
    
    [self.view setBackgroundColor:[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0]];
    
    // Initialize the game
    self.gameBrain = [GameBrain sharedInstance];
    
    // Create Tap button
    self.tapButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 60.0, 60.0)];
    [self.tapButton setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.25]];
    [self.tapButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.buttonCenter = CGPointMake(CGRectGetMidX(mainRect), CGRectGetMidY(mainRect)-25);
    [self.tapButton setCenter:self.buttonCenter];
    [self.tapButton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:20.0f]];
    [self.tapButton setTitle:@"Tap" forState:UIControlStateNormal];
    // Transform button into a circle
    self.tapButton.clipsToBounds = YES;
    self.tapButton.layer.cornerRadius = self.tapButton.frame.size.height / 2.0f;
    /*
    self.tapButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.tapButton.layer.borderWidth = 2.0f;
     */
    [self.view addSubview:self.tapButton];
    
    // Tap counter
    self.tapCounterLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, mainRect.size.width, 150)];
    [self.tapCounterLabel setCenter:CGPointMake(CGRectGetMidX(mainRect), CGRectGetMidY(mainRect)-25)];
    [self.tapCounterLabel setTextAlignment:NSTextAlignmentCenter];
    [self.tapCounterLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:100.0f]];
    [self.tapCounterLabel setTextColor:[UIColor whiteColor]];
    [self.tapCounterLabel setAlpha:0.5];
    [self.tapCounterLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.tapCounterLabel];
    
    // Goal tap number
    self.goalTapLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, mainRect.size.width, 150)];
    [self.goalTapLabel setCenter:CGPointMake(CGRectGetMidX(mainRect), CGRectGetMidY(mainRect) + 250)];
    [self.goalTapLabel setTextAlignment:NSTextAlignmentCenter];
    [self.goalTapLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:30.0f]];
    [self.goalTapLabel setTextColor:[UIColor whiteColor]];
    [self.goalTapLabel setAlpha:0.5];
    [self.goalTapLabel setBackgroundColor:[UIColor clearColor]];
    [self.goalTapLabel setText:[NSString stringWithFormat:@"GOAL: %i", self.gameBrain.goalTapNum]];
    [self.view addSubview:self.goalTapLabel];
    
    // Timer label
    self.timerLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, mainRect.size.width, 150)];
    [self.timerLabel setCenter:CGPointMake(CGRectGetMidX(mainRect), 80)];
    [self.timerLabel setTextAlignment:NSTextAlignmentCenter];
    [self.timerLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:30.0f]];
    [self.timerLabel setTextColor:[UIColor whiteColor]];
    [self.timerLabel setAlpha:0.5];
    [self.timerLabel setBackgroundColor:[UIColor clearColor]];
    [self.timerLabel setText:[NSString stringWithFormat:@"%i.00\"", self.gameBrain.secondsLeft]];
    [self.view addSubview:self.timerLabel];
    
    // Create Continue button
    self.continueButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 100, 40)];
    [self.continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[self.continueButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.continueButton.center = CGPointMake(mainRect.size.width / 2.0, mainRect.size.height - 50);
    // Transform button appearance
    [self.continueButton setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.25]];
    [self.continueButton setClipsToBounds:YES];
    self.continueButton.layer.cornerRadius = self.continueButton.frame.size.height / 4.0f;
    [self.continueButton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:20.0f]];
//    self.continueButton.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.continueButton.layer.borderWidth = 2.0f;
    [self.continueButton addTarget:self action:@selector(didPressContinueButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // Create Pause button (displayed on pause screen)
    self.pauseButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 40, 40)];
    [self.pauseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[self.continueButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.pauseButton.center = CGPointMake(mainRect.size.width - 50, 50);
    // Transform button appearance
    [self.pauseButton setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.25]];
    self.pauseButton.clipsToBounds = YES;
    self.pauseButton.layer.cornerRadius = self.pauseButton.frame.size.height / 2.0f;
//    self.pauseButton.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.pauseButton.layer.borderWidth = 2.0f;
    [self.pauseButton setAlpha:0.75];
    [self.pauseButton setImage:[UIImage imageNamed:@"Pause.png"] forState:UIControlStateNormal];
    [self.pauseButton addTarget:self action:@selector(didPressPauseButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // Create Home button (displayed on pause screen)
    self.homeButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 40, 40)];
    [self.homeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[self.continueButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.homeButton.center = CGPointMake(50, 50);
    // Transform button appearance
    [self.homeButton setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.25]];
    self.homeButton.clipsToBounds = YES;
    self.homeButton.layer.cornerRadius = self.homeButton.frame.size.height / 2.0f;
//    self.homeButton.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.homeButton.layer.borderWidth = 2.0f;
    [self.homeButton setAlpha:0.75];
    [self.homeButton setImage:[UIImage imageNamed:@"Home.png"] forState:UIControlStateNormal];
    [self.homeButton addTarget:self action:@selector(didPressHomeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // Prepare FXBlurView for blurred effect behind PauseGameViewController and TransitionalScreenViewController
    self.blurredView = [[FXBlurView alloc] initWithFrame:mainRect];
    [self.blurredView setTintColor:[UIColor clearColor]];
    [self.blurredView setBlurRadius:15.0];
    
    // Prepare PauseGameViewController
    self.pgvc = [[PauseGameViewController alloc] init];
    
    // Create array of 3 lifeHearts, used to display 3 hearts on game screen as "lives"
    self.lifeHeartsContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 108.0, 30.0)];
    CGRect containerFrame = self.lifeHeartsContainerView.frame;
    for (int i = 0; i < 3; i++)
    {
        UIImageView *heart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart.png"]];
        [heart setAlpha:0.5];
        [heart setFrame:CGRectMake(0, 0, 18.0, 18.0)];
        heart.center = CGPointMake(18 + i * (containerFrame.size.width / 3), containerFrame.size.height / 2);
        self.lifeHearts[i] = heart;
        [self.lifeHeartsContainerView addSubview:heart];
    }
    [self.lifeHeartsContainerView setCenter:CGPointMake(CGRectGetMidX(mainRect), CGRectGetMidY(self.goalTapLabel.frame) + 40)];
    [self.view addSubview:self.lifeHeartsContainerView];
    
    // Call myButtonPressed on button tap
    [self.tapButton addTarget:self action:@selector(myButtonPressed:)
            forControlEvents:UIControlEventTouchUpInside];
}

-(void) resetGameView
{
    CGRect mainRect = [[UIScreen mainScreen] applicationFrame];
    
    // Reset game view with quick animation
    [UIView animateWithDuration:0.5 animations:^{
        // Reset background color; recenter Tap Button; reset labels
        [self.view setBackgroundColor:[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0]];
        [self.tapButton setCenter:CGPointMake(CGRectGetMidX(mainRect), CGRectGetMidY(mainRect)-25)];
        [self.tapCounterLabel setText:@""];
        [self.goalTapLabel setText:[NSString stringWithFormat:@"GOAL: %i", self.gameBrain.goalTapNum]];
        [self.timerLabel setText:[NSString stringWithFormat:@"%i.00\"", self.gameBrain.secondsLeft]];
        // Need to set number of opaque Hearts to self.gameBrain.livesLeft
    }];
    NSLog(@"Reset the game view for level %i", self.gameBrain.level);
}

- (void) myButtonPressed:(UIButton *) sender
{
    // Start game if the button is pressed for the first time
    if (self.gameBrain.gameState == waiting) {
        [self.gameBrain startGame];
        [self.view addSubview:self.pauseButton];
        // Start the Timer with 1/100th (centisecond) accuracy... because it's more exciting than just seconds
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    }
    
    // Update game brain's tap counter and the tap counter label
    [self updateTapCounter];
    
    // Animations disabled on final (winning) tap for performance
    if (self.gameBrain.gameState != win) {
        [UIView animateWithDuration:0.5 animations:^{
            [self generateRandomBackgroundColor];
        }];
        // Move button to new random position
        [UIView animateWithDuration:0.1 animations:^{
            [self moveButtonRandomly];
        }];
    }
    
    // Checking if game has been won by reaching goal tap count
    if (self.gameBrain.gameState == win) {
        [self presentTransitionalViewController];
    }
}

-(void) updateTimer
{
    [self.gameBrain decrementTime];
    [self.timerLabel setText:[NSString stringWithFormat:(self.gameBrain.centisecondsLeft < 10 ? @"%i.0%i\"" : @"%i.%i\""),
                              self.gameBrain.secondsLeft, self.gameBrain.centisecondsLeft]];
    
    if (self.gameBrain.gameState == win || self.gameBrain.gameState == lose)
        [self presentTransitionalViewController];
}

-(void) presentTransitionalViewController
{
    NSLog(@"Lives remaining: %i", self.gameBrain.livesLeft);

    [self.timer invalidate];
    self.timer = nil;
    [self.pauseButton removeFromSuperview];
    [self.continueButton setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 + 100)];
    
    NSString *buttonText = [[NSString alloc] init];
    if (self.gameBrain.gameState == win) {
        buttonText = [NSString stringWithFormat:@"Level %i", self.gameBrain.level + 1];
    }
    else {
        buttonText = @"Try Again";
    }
    [self.continueButton setTitle: buttonText forState:UIControlStateNormal];
    
    self.tvc = [[TransitionalScreenViewController alloc] init];
    [self.tvc.view addSubview:self.homeButton];
    [self.tvc.view addSubview:self.continueButton];
    [self.view addSubview:self.blurredView];
    [self.view addSubview:self.tvc.view];
}

-(void) didPressContinueButton: (UIButton *) selector
{
    NSLog(@"Pressed continue button!");
    if (self.gameBrain.gameState == win) {
        [self.gameBrain startNextLevel];
        [self resetGameView];
        [self.tvc.view removeFromSuperview];
        [self.blurredView removeFromSuperview];
    }
    else if(self.gameBrain.gameState == lose) {
        [self.gameBrain retryCurrentLevel];
        [self resetGameView];
        [self.tvc.view removeFromSuperview];
        [self.blurredView removeFromSuperview];
        if (self.gameBrain.livesLeft == 0) {
            // present transitional view controller with Game Over
        }
    }
    else if(self.gameBrain.gameState == waiting) {
        [self.gameBrain startGame];
        [self.view addSubview:self.pauseButton];
        [self.pgvc.view removeFromSuperview];
        [self.blurredView removeFromSuperview];
    }
}

-(void) didPressPauseButton: (UIButton *) selector
{
    NSLog(@"Pressed pause button.");
    [self.pauseButton removeFromSuperview];
    [self.gameBrain pauseGame];
    [self.continueButton setTitle:@"Resume" forState:UIControlStateNormal];
    [self.continueButton setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 + 40)];
    
    [self.view addSubview:self.blurredView];
    [self.view addSubview:self.pgvc.view];
    
    [self.pgvc.view addSubview:self.continueButton];
    [self.pgvc.view addSubview:self.homeButton];
    [self.view addSubview:self.pgvc.view];
}

-(void) didPressHomeButton: (UIButton *) selector
{
    NSLog(@"Pressed home button.");
    [self.pauseButton removeFromSuperview];
    [self.timer invalidate];
    self.timer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.gameBrain restartGame];
}

-(void) generateRandomBackgroundColor
{
    srand((int)time(NULL));
    
    CGFloat red = (rand() / (float) RAND_MAX) * 0.5 + 0.3;
    CGFloat green = (rand() / (float) RAND_MAX) * 0.5 + 0.3;
    CGFloat blue = (rand() / (float) RAND_MAX) * 0.5 + 0.3;
    
    NSLog(@"R:%f, G:%f, B:%f", red, green, blue);
    
    // Ensures that no two consecutive colors are the same
    UIColor *randomColor = [UIColor colorWithRed:(red) green:(green) blue:(blue) alpha:(1.0)];
    while ([randomColor isEqual:self.view.backgroundColor]) {
        red = (rand() / (float) RAND_MAX) * 0.5 + 0.3;
        green = (rand() / (float) RAND_MAX) * 0.5 + 0.3;
        blue = (rand() / (float) RAND_MAX) * 0.5 + 0.3;
        randomColor = [UIColor colorWithRed:(red) green:(green) blue:(blue) alpha:(1.0)];
    }
    
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
     int xPadding = (self.tapButton.frame.size.width / 2) + 10;
     int yPadding = (self.tapButton.frame.size.height / 2) + 10;
     
     randPoint.x = xPadding + arc4random_uniform(highestX - (2 * xPadding));
     randPoint.y = yPadding + arc4random_uniform(highestY - (2 * yPadding));
     
     self.buttonCenter = randPoint;
     [self.tapButton setCenter:self.buttonCenter];
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
    [self.tapButton setCenter:self.buttonCenter];
}

-(void) updateTapCounter
{
    [self.gameBrain incrementTapCount];
    
    // Add "Pulse" animation to Tap Counter when button is tapped
    CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [pulse setDuration: 0.03];
    [pulse setAutoreverses: YES];
    [pulse setFromValue:[NSNumber numberWithFloat: 1.0]];
    [pulse setToValue:[NSNumber numberWithFloat: 1.3]];
    [self.tapCounterLabel.layer addAnimation:pulse forKey:@"animateLayer"];
    
    [self.tapCounterLabel setText:[NSString stringWithFormat:@"%i", self.gameBrain.currentTapCount]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
