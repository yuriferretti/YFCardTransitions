//The MIT License
//
//Copyright (c) 2015 Yuri Ferretti
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

#import "YFCardPickTranstion.h"

@implementation YFCardPickTranstion

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    //grab to ViewController
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //grab from ViewController
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    //grab from view
    UIView *fromView = fromVC.view;
    
    //grab to View
    UIView *toView = toVC.view;
    
    //the final frame is the toView bounds
    CGRect toViewFinalFrame = toVC.view.bounds;
    
    UIView *containerView = [transitionContext containerView];
    
    //Frame for the cards that appear overlapping the selected card
    CGRect overlappingFrame = CGRectMake(0, self.referenceFrame.origin.y + self.cardTopReveal - 2.0, CGRectGetWidth(fromView.bounds), CGRectGetHeight(fromView.bounds));
    
    //The overlapping cards snapshot
    UIView *overlappingCards = [fromView resizableSnapshotViewFromRect:overlappingFrame afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
    
    //set the overlapping cards frame
    overlappingCards.frame = CGRectMake(0, self.referenceFrame.origin.y + self.cardTopReveal, CGRectGetWidth(fromView.bounds), CGRectGetHeight(fromView.bounds));
    
    //set the moving card snapshot frame
    self.movingCardSnapshot.frame = CGRectMake(0, self.referenceFrame.origin.y, CGRectGetWidth(fromView.bounds), CGRectGetHeight(fromView.bounds));

    //We create mask to give give to snapshots a card appearence
    CAShapeLayer *overlapMask = [CAShapeLayer layer];
    CAShapeLayer *movingMask = [CAShapeLayer layer];
    
    
    overlapMask.path = [UIBezierPath bezierPathWithRoundedRect:overlappingCards.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10.0, 10.0)].CGPath;
    movingMask.path = [UIBezierPath bezierPathWithRoundedRect:self.movingCardSnapshot.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10.0, 10.0)].CGPath;
    
    overlappingCards.layer.mask = overlapMask;
    self.movingCardSnapshot.layer.mask = movingMask;
    
    CGFloat const statusBarViewHeight = [[UIApplication sharedApplication]statusBarFrame].size.height;
    
    //setting the to view frame
    toView.frame = CGRectOffset(self.movingCardSnapshot.frame, 0, statusBarViewHeight);

    //hiding the toView
    toView.alpha = 0.0;
    
    // add the views to sandbox container
    [containerView addSubview:toView];
    [containerView addSubview:self.movingCardSnapshot];
    [containerView addSubview:overlappingCards];
    
    
    //the height hidden under the overlapping cards
    CGFloat offsetHeight = CGRectGetHeight(fromView.bounds) - self.cardTopReveal;
    
    //height of the selected card that is being shown on screen
    CGFloat movingCardReveal = CGRectGetHeight(fromView.bounds) - self.referenceFrame.origin.y;

    //is the last card
    //just slide it up
    
    if (movingCardReveal <= self.cardTopReveal) {
        
        [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.movingCardSnapshot.frame = toViewFinalFrame;
            toView.frame = toViewFinalFrame;
            fromView.alpha = 0.0;
            toView.alpha = 1.0;
            self.movingCardSnapshot.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            //[containerView addSubview:toVC.view];
            [self.movingCardSnapshot removeFromSuperview];
            [overlappingCards removeFromSuperview];
            [transitionContext completeTransition:YES];
            
        }];
        
    } else {
        
        [UIView animateWithDuration:self.duration / 2.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.movingCardSnapshot.frame = CGRectOffset(self.movingCardSnapshot.frame, 0, -offsetHeight );
            toView.frame = CGRectOffset(toView.frame, 0, -offsetHeight);
            fromView.alpha = 0.2;
            toView.alpha = 1.0;
            self.movingCardSnapshot.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            [containerView bringSubviewToFront:toView];
            [UIView animateWithDuration:self.duration / 2.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                fromView.alpha = 0.0;
                toView.frame = toViewFinalFrame;
                self.movingCardSnapshot.frame = toView.frame;
                
            } completion:^(BOOL finished) {
                
                [containerView addSubview:toVC.view];
                [self.movingCardSnapshot removeFromSuperview];
                [overlappingCards removeFromSuperview];
                [transitionContext completeTransition:YES];
                
            }];
            
        }];
    }
}

@end
