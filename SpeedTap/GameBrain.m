//
//  GameBrain.m
//  SpeedTap
//
//  Created by Aaron Robinson on 11/6/14.
//  Copyright (c) 2014 Aaron Robinson. All rights reserved.
//

#import "GameBrain.h"

@implementation GameBrain


+ (GameBrain *) sharedInstance
{
    static GameBrain *sharedObject = nil;
    
    if( sharedObject == nil )
        sharedObject = [[GameBrain alloc] init];
    
    return sharedObject;
}

-(instancetype) init
{
    if( (self = [super init]) == nil)
        return nil;
    
    [self generatePointsInRect];
    self.currentTapCount = 0;
    self.levelScore = 0;
    self.totalScore = 0;
    self.level = 1;
    self.goalTapNum = 5;
    self.levelTimeLimit = 5;
    self.secondsLeft = self.levelTimeLimit;
    self.centisecondsLeft = 0;
    self.gameState = waiting;

    return self;
}

-(void) startGame
{
    self.gameState = running;
}

-(void) restartGame
{
    self.currentTapCount = 0;
    self.levelScore = 0;
    self.totalScore = 0;
    self.level = 1;
    self.goalTapNum = 5;
    self.levelTimeLimit = 5;
    self.secondsLeft = self.levelTimeLimit;
    self.centisecondsLeft = 0;
    self.gameState = waiting;
}

-(void) pauseGame
{
    self.gameState = waiting;
}

-(void) retryCurrentLevel
{
    NSLog(@"Retrying level %i", self.level);
    self.levelScore = 0;
    self.secondsLeft = self.levelTimeLimit;
    self.centisecondsLeft = 0;
    self.currentTapCount = 0;
    self.gameState = waiting;
}

-(void) startNextLevel
{
    self.level++;
    self.totalScore += self.levelScore;
    self.goalTapNum += 2;
    self.levelTimeLimit += 1;
    
    self.levelScore = 0;
    self.currentTapCount = 0;
    self.secondsLeft = self.levelTimeLimit;
    self.centisecondsLeft = 0;
    NSLog(@"Starting level %i with total score of %i", self.level, self.totalScore);
    self.gameState = waiting;
}

-(void) decrementTime
{
    // Decremend centiseconds first, and then seconds
    if (self.gameState == running)
    {
        if (self.centisecondsLeft == 0)
        {
            if (self.secondsLeft == 0) {
                self.gameState = lose;
            }
            else {
                self.secondsLeft--;
                self.centisecondsLeft = 99;
            }
        }
        else {
            self.centisecondsLeft--;
        }
    }
}

-(void) incrementTapCount
{
    self.currentTapCount++;
    self.levelScore++;
    NSLog(@"Tap count incremented.");
    if (self.currentTapCount >= self.goalTapNum) {
        self.gameState = win;
        self.levelScore = self.currentTapCount;
    }
}

-(void) generatePointsInRect
{
    CGRect mainRect = [[UIScreen mainScreen] applicationFrame];
    
    CGFloat row1 = mainRect.size.height / 5;
    CGFloat row2 = row1 * 2;
    CGFloat row3 = row1 * 3;
    CGFloat row4 = row2 * 2;
    CGFloat col1 = mainRect.size.width / 4;
    CGFloat col2 = col1 * 2;
    CGFloat col3 = col1 * 3;
    
    CGPoint pt1 = CGPointMake(col1, row1);
    CGPoint pt2 = CGPointMake(col1, row2);
    CGPoint pt3 = CGPointMake(col1, row3);
    CGPoint pt4 = CGPointMake(col1, row4);
    CGPoint pt5 = CGPointMake(col2, row1);
    CGPoint pt6 = CGPointMake(col2, row2);
    CGPoint pt7 = CGPointMake(col2, row3);
    CGPoint pt8 = CGPointMake(col2, row4);
    CGPoint pt9 = CGPointMake(col3, row1);
    CGPoint pt10 = CGPointMake(col3, row2);
    CGPoint pt11 = CGPointMake(col3, row3);
    CGPoint pt12 = CGPointMake(col1, row4);
    
    NSArray *points = [NSArray arrayWithObjects:
                       [NSValue valueWithCGPoint:pt1],
                       [NSValue valueWithCGPoint:pt2],
                       [NSValue valueWithCGPoint:pt3],
                       [NSValue valueWithCGPoint:pt4],
                       [NSValue valueWithCGPoint:pt5],
                       [NSValue valueWithCGPoint:pt6],
                       [NSValue valueWithCGPoint:pt7],
                       [NSValue valueWithCGPoint:pt8],
                       [NSValue valueWithCGPoint:pt9],
                       [NSValue valueWithCGPoint:pt10],
                       [NSValue valueWithCGPoint:pt11],
                       [NSValue valueWithCGPoint:pt12],
                       nil];
    
    self.pointsArray = points;
}

@end
