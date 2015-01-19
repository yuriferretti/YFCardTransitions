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


#import "YFDragDownToDismissTransition.h"

@interface YFDragDownToDismissTransition ()

//bool telling if the transition should be completed
@property (assign, nonatomic) BOOL shouldCompleteTransition;

//transition context
@property (strong, nonatomic) id<UIViewControllerContextTransitioning>context;

//transition context container view
@property (strong, nonatomic) UIView *transitionContainer;

//view that is being dismissed (from ViewController's view)
@property (strong, nonatomic) UIView *viewBeingDismissed;

//view that is being presented (to ViewController's view)
@property (strong, nonatomic) UIView *viewBeingPresented;

//gesture initial touch location offset from center
@property (assign, nonatomic) UIOffset touchOffsetFromCenter;

//gesture recognizer
@property (strong, nonatomic) UIPanGestureRecognizer *recognizer;

//variable indacating wheter an observer was added using KVO
@property (assign, nonatomic) BOOL addedObserver;

//variable indicating wheter the interaction is progresses
@property (assign, nonatomic) BOOL interactionInProgress;

//view controller being dismissed
@property (strong, nonatomic) UIViewController *viewController;

@end

@implementation YFDragDownToDismissTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 2.0;
}

- (CGFloat)completionSpeed {
    return 1 - self.percentComplete;
}

- (void)wireToViewController:(UIViewController *)viewController{
    
    self.viewController = viewController;
    [self prepareGestureRecognizerInView:viewController.view];
}


- (void)prepareGestureRecognizerInView:(UIView *)view {
    self.recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    [view addGestureRecognizer:self.recognizer];
}

- (void)handleGesture:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint translation = [recognizer translationInView:[self.context containerView]];

    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{

            BOOL topToBottom = translation.y > 0;
            if (topToBottom) {
                self.interactionInProgress = YES;
                [self.viewController dismissViewControllerAnimated:YES completion:nil];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged:{

            if (self.interactionInProgress) {
                CGPoint touchLocation = [recognizer locationInView:self.transitionContainer];
                CGPoint center = self.viewBeingDismissed.center;
                center.y = touchLocation.y - self.touchOffsetFromCenter.vertical;
                self.viewBeingDismissed.center = center;
                [self.context updateInteractiveTransition:[self percentageBasedOnLocationOfView]];
            }
            break;
        }
            
        case UIGestureRecognizerStateEnded:{
            
            if (self.interactionInProgress) {
                BOOL fastSwipe = [self.recognizer velocityInView:self.transitionContainer].y > CGRectGetHeight(self.transitionContainer.bounds);
                
                if (([self percentageBasedOnLocationOfView] >= 0.33) || fastSwipe) {
                    
                    [self finishInteraction];
                    
                } else {
                    [self cancelInteraction];
                }
            }
            break;
        }
            
        default:
            if (self.interactionInProgress) {
                [self cancelInteraction];
            }
            break;
    }
}

- (CGFloat)percentageBasedOnLocationOfView {

    return CGRectGetMinY(self.viewBeingDismissed.frame) / CGRectGetHeight(self.transitionContainer.bounds);
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

    self.context = transitionContext;
    self.transitionContainer = [transitionContext containerView];
    self.viewBeingPresented = [self.context viewControllerForKey:UITransitionContextToViewControllerKey].view;
    self.viewBeingDismissed = [self.context viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    if (!self.addedObserver) {
        [self.viewBeingDismissed addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        self.addedObserver = YES;
    }
    
    CGPoint fingerPoint = [self.recognizer locationInView:self.viewBeingDismissed];
    CGPoint viewCenter = self.viewBeingDismissed.center;
    self.touchOffsetFromCenter = UIOffsetMake(fingerPoint.x - viewCenter.x, fingerPoint.y - viewCenter.y);
}

- (void)finishInteraction {

    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.transitionContainer];
    if (self.viewBeingDismissed) {
        UIGravityBehavior *gravity = [[UIGravityBehavior alloc]initWithItems:@[self.viewBeingDismissed]];
        gravity.gravityDirection = CGVectorMake(0, 10.0);
        
        __weak typeof(self) weakSelf = self;
        
        gravity.action = ^{
            typeof(self) strongSelf = weakSelf;
            if ([strongSelf percentageBasedOnLocationOfView] > 1.0) {
                [animator removeAllBehaviors];
                [strongSelf completeTransition];
                
            }
        };
        
        [animator addBehavior:gravity];
    }
    [self.context finishInteractiveTransition];
}

- (void)cancelInteraction {

    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.transitionContainer];
    UIViewController *fromVC = [self.context viewControllerForKey:UITransitionContextFromViewControllerKey];
    CGRect initialFrame = [self.context initialFrameForViewController:fromVC];
    
    CGPoint snapPoint = CGPointMake(CGRectGetMidX(initialFrame), CGRectGetMidY(initialFrame));
    
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[self.viewBeingDismissed]];
    itemBehavior.allowsRotation = NO;
    [animator addBehavior:itemBehavior];
    
    UISnapBehavior *snapBehavior = [[UISnapBehavior alloc]initWithItem:self.viewController.view snapToPoint:snapPoint];
    
    snapBehavior.damping = 0.3;
    
    __weak typeof(self) weakSelf = self;
    
    snapBehavior.action = ^{
        typeof(self) strongSelf = weakSelf;
        UIView *fromView = strongSelf.viewBeingDismissed;
        
        if ((ABS(fromView.frame.origin.y) < 1) && ([itemBehavior linearVelocityForItem:fromView].y < 0.01)) {
            fromView.frame = initialFrame;
            [animator removeAllBehaviors];
            [strongSelf completeTransition];
        }
    };
    
    [animator addBehavior:snapBehavior];
    [self.context cancelInteractiveTransition];
    
    
}

- (void)completeTransition {

    BOOL finished = ![self.context transitionWasCancelled];
    [self.context completeTransition:finished];
    if (self.addedObserver) {
        [self.viewBeingDismissed removeObserver:self forKeyPath:@"center"];
        self.addedObserver = NO;
    }
    self.touchOffsetFromCenter = UIOffsetZero;
    if (finished) {
        self.viewBeingDismissed = nil;
        self.viewBeingPresented = nil;
        self.transitionContainer = nil;
    }
    self.interactionInProgress = NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"center"]) {
        self.viewBeingPresented.alpha = [self percentageBasedOnLocationOfView];
    }
}



@end
