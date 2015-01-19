//
//  SwipeInteractionController.h
//  iClinic
//
//  Created by Yuri Ferretti on 1/16/15.
//  Copyright (c) 2015 iClinic Software. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface YFDragDownToDismissTransition : UIPercentDrivenInteractiveTransition <UIViewControllerInteractiveTransitioning, UIViewControllerAnimatedTransitioning>

//method used to wire the transition to the view controller
- (void)wireToViewController:(UIViewController *)viewController;

@end
