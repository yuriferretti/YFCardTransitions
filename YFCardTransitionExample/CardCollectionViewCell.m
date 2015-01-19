//
//  AppointmentCollectionViewCell.m
//  iClinic
//
//  Created by Yuri Ferretti on 1/10/15.
//  Copyright (c) 2015 iClinic Software. All rights reserved.
//

#import "CardCollectionViewCell.h"

@implementation CardCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //this image gibes the rounded corner aspect to card
    UIImage *image = [[UIImage imageNamed:@"background"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
    self.layer.masksToBounds = NO;
    self.imageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.layer.shadowOffset = CGSizeMake(0, -1);
    self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowRadius = 2.0;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:10.0].CGPath;
    self.imageView.tintColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    
}

+ (NSString *)reusableIdentifier {
    return @"CardCollectionViewCell";
}

@end
