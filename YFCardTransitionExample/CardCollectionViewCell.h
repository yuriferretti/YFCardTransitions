//
//  AppointmentCollectionViewCell.h
//  iClinic
//
//  Created by Yuri Ferretti on 1/10/15.
//  Copyright (c) 2015 iClinic Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

+ (NSString *)reusableIdentifier;

@end
