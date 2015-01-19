//
//  ViewController.m
//  YFCardTransitionExample
//
//  Created by Yuri Ferretti on 1/19/15.
//  Copyright (c) 2015 Yuri Ferretti. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *mainView;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createRoundedLayerMask];
}

- (void)createRoundedLayerMask {
    
    CGRect bounds = [[UIScreen mainScreen]bounds];
    CAShapeLayer *layerMask = [CAShapeLayer layer];
    layerMask.path = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10.0, 10.0)].CGPath;
    
    self.mainView.layer.mask = layerMask;
    
}

- (void)setColor:(UIColor *)color {
    
    self.mainView.backgroundColor = color;
}

@end
