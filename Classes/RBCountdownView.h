//
//  RBCountdownView.h
//  countdown
//
//  Created by Booth, Robert on 11/6/15.
//  Copyright © 2015 Booth, Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface RBCountdownView : UIView

@property (assign) NSInteger IBInspectable startingValue;

- (void)animateFrom:(NSInteger)from to:(NSInteger)to completion:(void (^)(void))completion;
- (void)animateTo:(NSInteger)to completion:(void (^)(void))completion;

@end
