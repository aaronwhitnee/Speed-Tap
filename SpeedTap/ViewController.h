//
//  ViewController.h
//  SpeedTap
//
//  Created by Aaron Robinson on 11/6/14.
//  Copyright (c) 2014 Aaron Robinson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "GameInstructionsViewController.h"
#import "GameViewController.h"

@interface ViewController : UIViewController

@property(nonatomic) HomeViewController *homeViewController;
@property(nonatomic) GameInstructionsViewController *instViewController;
@property(nonatomic) GameViewController *gameViewController;

- (void) flipFromViewController:(UIViewController*) fromController
               toViewController:(UIViewController*) toController
                  withDirection:(UIViewAnimationOptions) direction;

@end

