//
//  GameViewController.h
//  SpeedTap
//
//  Created by Aaron Robinson on 11/6/14.
//  Copyright (c) 2014 Aaron Robinson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController

@property(strong, nonatomic) UIButton *tapButton;
@property(nonatomic) CGPoint buttonCenter;
@property(strong, nonatomic) UILabel *tapCounterLabel;
@property(nonatomic) UILabel *timerLabel;
@property(nonatomic) UILabel *goalTapLabel;

-(void) resetGameView;

@end
