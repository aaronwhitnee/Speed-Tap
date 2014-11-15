//
//  HomeViewController.m
//  SpeedTap
//
//  Created by Aaron Robinson on 11/6/14.
//  Copyright (c) 2014 Aaron Robinson. All rights reserved.
//

#import "ViewController.h"
#import "HomeViewController.h"
#import "GameViewController.h"
#import "GameInstructionsViewController.h"

@interface HomeViewController ()

@property(nonatomic) UIButton *startGameButton;
@property(nonatomic) UIButton *howToPlayButton;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = [[UIScreen mainScreen] applicationFrame];

    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // Create Start button
    self.startGameButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 200, 40)];
    [self.startGameButton setTitle: @"Start" forState:UIControlStateNormal];
    [self.startGameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[self.startGameButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.startGameButton.center = CGPointMake(frame.size.width / 2.0, frame.size.height / 2.0 + 30);
    // Transform button appearance
    self.startGameButton.clipsToBounds = YES;
    self.startGameButton.layer.cornerRadius = self.startGameButton.frame.size.height / 4.0f;
    self.startGameButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.startGameButton.layer.borderWidth = 2.0f;
    [self.view addSubview:self.startGameButton];
    
    // Create How to Play button
    self.howToPlayButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 200, 40)];
    [self.howToPlayButton setTitle: @"How To Play" forState:UIControlStateNormal];
    [self.howToPlayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[self.howToPlayButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.howToPlayButton.center = CGPointMake(frame.size.width / 2.0, self.startGameButton.frame.origin.y + 80);
    // Transform button appearance
    self.howToPlayButton.clipsToBounds = YES;
    self.howToPlayButton.layer.cornerRadius = self.howToPlayButton.frame.size.height / 4.0f;
    self.howToPlayButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.howToPlayButton.layer.borderWidth = 2.0f;
    [self.view addSubview:self.howToPlayButton];
    
    // Add actions to home screen buttons
    [self.startGameButton addTarget:self action:@selector(didPressStartButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.howToPlayButton addTarget:self action:@selector(didPressHowToPlayButton:) forControlEvents:UIControlEventTouchUpInside];

}

-(void) didPressStartButton: (UIButton *) selector
{
    GameViewController *gvc = [[GameViewController alloc] init];
    gvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    [self presentViewController: gvc
                       animated: YES
                     completion: ^{
                         NSLog(@"Presented GameViewController");
                     }
     ];
}

-(void) didPressHowToPlayButton: (UIButton *) selector
{
    GameInstructionsViewController *ivc = [[GameInstructionsViewController alloc] init];
    ivc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController: ivc
                       animated: YES
                     completion: ^{
                         NSLog(@"Presented GameInstructionsViewController");
                     }
     ];
    
    //[self flipFromViewController:self toViewController:ivc withDirection:UIViewAnimationOptionCurveLinear];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
