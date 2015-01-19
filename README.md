# YFCardTransitions
YFCardTransitions is a set of custom UIViewController transitions designed to be used with Tim Gleue's awesome [TGLStackedViewController](https://github.com/gleue/TGLStackedViewController).

## Installation

With [CocoaPods](http://cocoapods.org/), add this line to your Podfile.

```
pod 'YFCardTransitions'
```

Or drag the files inside the Source folder to your project

##Screenshots

![Example](./Screens/example.gif "Example View")

##Usage

First you have to subclass ```TGStackedViewController``` that conforms to ```UIViewControllerTransitioningDelegate``` and add two properties that will be responsible for the transitions:

```objective-c
@interface YFCardCollectionViewController () <UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) YFCardPickTranstion           *cardPickTransition;
@property (strong, nonatomic) YFDragDownToDismissTransition *dragDownToDismissTransition;

@end

```

You have to set YFCardPickTransition ```duaration``` property to a desired value and ```cardTopReveal``` to the same value as ```TGLStackedLayout``` ```topReveal``` property

```objective-c

- (YFCardPickTranstion *)cardPickTransition {
    if (!_cardPickTransition) {
        _cardPickTransition = [YFCardPickTranstion new];
        _cardPickTransition.duration = 0.5;
        _cardPickTransition.cardTopReveal = self.stackedLayout.topReveal;
    }
    return _cardPickTransition;
}
```

Also create an ```UICollectionViewCell``` subclass to be used by you ```TGLStackedViewController``` subclass

In ```UICollectionViewDelegate``` protocol method ```collectionView:didSelectItemAtIndexPath:``` you should grab the selected cell reference frame and snapshot:

```objective-c
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
    CGRect referenceFrame = [collectionView convertRect:attributes.frame toView:collectionView.superview];
    
    self.cardPickTransition.referenceFrame = referenceFrame;
    
    CardCollectionViewCell *cell = (CardCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UIView *snapshotView = [cell snapshotViewAfterScreenUpdates:YES];

    self.cardPickTransition.movingCardSnapshot = snapshotView;
    
    self.selectedCardColor = cell.imageView.tintColor;
    
    [self performSegueWithIdentifier:@"showDetail" sender:nil];
    
}
```

Implement the ```UIViewControllerTransitioningDelegate``` methods :

```objective-c

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    return self.cardPickTransition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return  self.dragDownToDismissTransition;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    
    return self.dragDownToDismissTransition;
}
```

Wire the presented view controller to the ```YFDragDownToDismissTransition``` instance :

```objective-c

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ViewController *vc = segue.destinationViewController;
    [self.dragDownToDismissTransition wireToViewController:vc];
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
}

```

A complete working example is provided in this repository.

##Requirements
- iOS 7 or higher
- ARC

##Credits

- Tim Gleue for his awsome [TGLStackedViewController](https://github.com/gleue/TGLStackedViewController)

##Author

- [Yuri Ferretti](https://github.com/yuriferretti)

##License

The MIT License

Copyright (c) 2015 Yuri Ferretti

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

