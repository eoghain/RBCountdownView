//
//  ViewController.m
//  countdown
//
//  Created by Booth, Robert on 11/5/15.
//  Copyright © 2015 Booth, Robert. All rights reserved.
//

#import "ViewController.h"
#import "RBCountdownView.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet RBCountdownView *countdown1;
@property (strong, nonatomic) IBOutlet RBCountdownView *countdown2;
@property (strong, nonatomic) IBOutlet RBCountdownView *countdown3;

@property (assign) NSInteger count1;
@property (assign) NSInteger count2;
@property (assign) NSInteger count3;

@end

const NSInteger COUNT = 3;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.count1 = COUNT;
    self.count2 = COUNT;
    self.count3 = COUNT;
    
    self.countdown1.startingValue = self.count1;
    self.countdown2.startingValue = self.count2;
    self.countdown3.startingValue = self.count3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self animate3];
}

- (void)animate1
{
    if (self.count1 == 0)  // Finish countdown
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Countdown Complete!" message:@"Countdown has finished" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alert animated:YES completion:^{}];
    }
    else
    {
        // Restart Count 3
        [self.countdown3 animateTo:COUNT completion:^{
            self.count3 = COUNT;
            [self animate3];
        }];
        
        // Restart Count 2
        [self.countdown2 animateTo:COUNT completion:^{
            self.count2 = COUNT;
        }];

        [self.countdown1 animateFrom:self.count1 to:self.count1 - 1 completion:^{
            self.count1--;
        }];
    }
}

- (void)animate2
{
    if (self.count2 == 0)
    {
        [self animate1];
    }
    else
    {
        // Restart Count 3
        [self.countdown3 animateTo:COUNT completion:^{
            self.count3 = COUNT;
            [self animate3];
        }];
        
        // Decrement Count 2
        [self.countdown2 animateFrom:self.count2 to:self.count2 - 1 completion:^{
            self.count2--;
        }];
    }
}

- (void)animate3
{
    [self.countdown3 animateFrom:self.count3 to:0 completion:^{
        self.count3 = COUNT;
        [self animate2];
    }];
}

@end
