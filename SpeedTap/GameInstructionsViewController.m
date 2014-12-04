//
//  GameInstructionsViewController.m
//  SpeedTap
//
//  Created by Aaron Robinson on 11/6/14.
//  Copyright (c) 2014 Aaron Robinson. All rights reserved.
//

#import "GameInstructionsViewController.h"

@interface GameInstructionsViewController ()

@property(nonatomic) UITextView *instructionsText;
@property(nonatomic) UIButton *backButton;

@end

@implementation GameInstructionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0]];
    
    // Create text area
    CGRect textFrame = CGRectMake(0, 0, frame.size.width - 60, frame.size.height - 120);
    self.instructionsText = [[UITextView alloc] initWithFrame: textFrame];
    [self.instructionsText setTextColor:[UIColor whiteColor]];
    [self.instructionsText setBackgroundColor:[UIColor clearColor]];
    [self.instructionsText setCenter:CGPointMake(frame.size.width / 2.0, frame.size.height / 2.0)];
    [self.instructionsText setFont:[UIFont systemFontOfSize:20]];
    [self.instructionsText setFont:[UIFont fontWithName:@"Avenir-Book" size:20.0f]];
    [self.instructionsText setText:@"Tap on the button as fast as you can before time runs out. You must reach the required number of taps before proceeding to the next level. The faster you tap, the higher your score.\n\nBut be careful - you only have 3 lives! Lose a level, lose a life."];
    [self.view addSubview: self.instructionsText];
    
    // Create Back button
    self.backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 80, 40)];
    [self.backButton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:20.0f]];
    [self.backButton setTitle: @"Back" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backButton setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.25]];
    //[self.backButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.backButton.center = CGPointMake(70, self.instructionsText.frame.size.height + 20);
    // Transform button appearance
    self.backButton.clipsToBounds = YES;
    self.backButton.layer.cornerRadius = self.backButton.frame.size.height / 4.0f;
//    self.backButton.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.backButton.layer.borderWidth = 2.0f;
    [self.view addSubview:self.backButton];
    
    [self.backButton addTarget:self action:@selector(didPressBackButton:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) didPressBackButton: (UIButton *) selector
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Pressed back button!");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
