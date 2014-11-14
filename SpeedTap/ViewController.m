//
//  ViewController.m
//  SpeedTap
//
//  Created by Aaron Robinson on 11/6/14.
//  Copyright (c) 2014 Aaron Robinson. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.homeViewController = [[HomeViewController alloc] init];
    NSLog(@"init homeViewCont");
    self.homeViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:self.homeViewController animated:NO completion:^{NSLog(@"Loaded home view controller");}];
    
}

- (void) flipFromViewController:(UIViewController*) fromController
               toViewController:(UIViewController*) toController
                  withDirection:(UIViewAnimationOptions) direction
{
    toController.view.frame = fromController.view.bounds;
    [self addChildViewController:toController];
    //[self.view addSubview:toController.view];
    [fromController willMoveToParentViewController:nil];
    
    [self transitionFromViewController:fromController
                      toViewController:toController
                              duration:0.2
                               options:direction | UIViewAnimationOptionCurveEaseIn
                            animations:nil
                            completion:^(BOOL finished) {
                                [toController didMoveToParentViewController:self];
                                [fromController removeFromParentViewController];
                            }];
}

-(HomeViewController *) homeViewController
{
    return self.homeViewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
