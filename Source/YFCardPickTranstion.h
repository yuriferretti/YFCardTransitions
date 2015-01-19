//
//  ScaleAnimator.h
//  iClinic
//
//  Created by Yuri Ferretti on 1/12/15.
//  Copyright (c) 2015 iClinic Software. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface YFCardPickTranstion : NSObject <UIViewControllerAnimatedTransitioning>

//selected card reference frame used to perform the transition
@property (assign, nonatomic) CGRect         referenceFrame;

//animation duration
@property (assign, nonatomic) NSTimeInterval duration;

//cards top reveal
@property (assign, nonatomic) CGFloat        cardTopReveal;

//snapshot of selected card
@property (strong, nonatomic) UIView         *movingCardSnapshot;

@end
