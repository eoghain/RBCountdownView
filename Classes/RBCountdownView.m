//
//  RBCountdownView.m
//  countdown
//
//  Created by Booth, Robert on 11/6/15.
//  Copyright © 2015 Booth, Robert. All rights reserved.
//

#import "RBCountdownView.h"
#import <QuartzCore/QuartzCore.h>

@interface RBCountdownView ()
{
    NSInteger _startingValue;
}

@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) UILabel *label1;
@property (strong, nonatomic) UILabel *label2;
@property (strong, nonatomic) UIColor *textColor;
@property (assign) CGFloat fontSize;
@property (assign) NSInteger counter;
@property (assign) NSInteger counterEnd;
@property (assign) CGRect topFrame;
@property (assign) CGRect inFrame;
@property (assign) CGRect bottomFrame;
@property (nonatomic, copy) void (^completion)(void);

@end

@implementation RBCountdownView

#pragma mark - Object Lifecycle

- (void)setup
{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    self.startingValue = 99;
    self.counter = self.startingValue;
    self.backgroundColor = [UIColor whiteColor];
    self.topFrame = CGRectMake(0, -height, width, height);
    self.inFrame = CGRectMake(0, 0, width, height);
    self.bottomFrame = CGRectMake(0, height, width, height);
    
    self.textColor = [UIColor darkGrayColor];
    self.fontSize = MIN(width, height) / 1.5;
    
    // Add Container
    self.container = [[UIView alloc] initWithFrame:self.inFrame];
    [self addSubview:self.container];
    
    // Add labelViews
    self.label1 = [[UILabel alloc] initWithFrame:self.inFrame];
    self.label1.font = [UIFont systemFontOfSize:self.fontSize];
    self.label1.textColor = self.textColor;
    self.label1.textAlignment = NSTextAlignmentCenter;
    self.label1.text = [self formattedNumber:self.startingValue];
    [self.container addSubview:self.label1];
    
    self.label2 = [[UILabel alloc] initWithFrame:self.topFrame];
    self.label2.font = [UIFont systemFontOfSize:self.fontSize];
    self.label2.textColor = self.textColor;
    self.label2.textAlignment = NSTextAlignmentCenter;
    [self.container addSubview:self.label2];
    
    // Add gradient
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = self.bounds;
    gradient.colors = @[
        (id)[UIColor clearColor].CGColor,
        (id)[UIColor blackColor].CGColor,
        (id)[UIColor blackColor].CGColor,
        (id)[UIColor clearColor].CGColor
    ];
    gradient.locations = @[ @0.0, @0.2, @0.8, @1.0 ];
    
    self.container.layer.mask = gradient;
}

- (id)init
{
    return [self initWithFrame:CGRectMake(0, 0, 240.0f, 240.0f)];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    
    return self;
}


#pragma mark - IBInspectables

- (void)setStartingValue:(NSInteger)startingValue
{
    _startingValue = startingValue;
    self.label1.text = [self formattedNumber:self.startingValue];
}

- (NSInteger)startingValue
{
    return _startingValue;
}


#pragma mark - Helpers

- (NSString *)formattedNumber:(NSInteger)number
{
    return [NSString stringWithFormat:@"%02ld", number];
}


#pragma mark - Animation

- (void)animateFrom:(NSInteger)from to:(NSInteger)to completion:(void (^)(void))completion
{
    self.counter = from;
    self.counterEnd = to;
    self.completion = completion;
    [self setupAnimation];
}

// Method to animate from current value to any value (i.e. loop back to start)
- (void)animateTo:(NSInteger)to completion:(void (^)(void))completion
{
    self.label2.text = [self formattedNumber:to];
    [UIView animateWithDuration:0.8 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.label1.frame = self.bottomFrame;
        self.label2.frame = self.inFrame;
    } completion:^(BOOL finished) {
        self.label1.text = [self formattedNumber:to];
        self.label1.frame = self.inFrame;
        self.label2.frame = self.topFrame;
        completion();
    }];
}

- (void)setupAnimation;
{
    self.label1.text = [self formattedNumber:self.counter];
    self.label1.frame = self.inFrame;
    self.label2.text = [self formattedNumber:self.counter - 1];
    self.label2.frame = self.topFrame;

    if (self.counter == self.counterEnd)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.completion();
        });
        return;
    }
    
    [self runAnimation];
}

- (void)runAnimation
{
    [UIView animateWithDuration:0.8 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.label1.frame = self.bottomFrame;
        self.label2.frame = self.inFrame;
    } completion:^(BOOL finished) {
        self.counter--;
        [self setupAnimation];
    }];
}

@end
