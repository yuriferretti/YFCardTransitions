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

#import "ViewController.h"
#import "YFDragDownToDismissTransition.h"

@interface ViewController () <UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) YFDragDownToDismissTransition *dragDownToDismissTransition;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.transitioningDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createRoundedLayerMask];
    [self.dragDownToDismissTransition wireToViewController:self];
    self.mainView.backgroundColor = self.color;
}

- (void)createRoundedLayerMask {
    
    CGRect bounds = [[UIScreen mainScreen]bounds];
    CAShapeLayer *layerMask = [CAShapeLayer layer];
    layerMask.path = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10.0, 10.0)].CGPath;
    self.mainView.layer.mask = layerMask;
    
}


- (YFDragDownToDismissTransition *)dragDownToDismissTransition {
    if (!_dragDownToDismissTransition) {
        _dragDownToDismissTransition = [YFDragDownToDismissTransition new];
    }
    return _dragDownToDismissTransition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return  self.dragDownToDismissTransition;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    
    return self.dragDownToDismissTransition;
}


@end
