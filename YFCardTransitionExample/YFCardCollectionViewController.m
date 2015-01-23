//
//  YFCardCollectionViewController.m
//  YFCardTransitionExample
//
//  Created by Yuri Ferretti on 1/19/15.
//  Copyright (c) 2015 Yuri Ferretti. All rights reserved.
//

#import "YFCardCollectionViewController.h"
#import "CardCollectionViewCell.h"
#import "YFCardPickTranstion.h"

#import "ViewController.h"

@interface YFCardCollectionViewController () <UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) YFCardPickTranstion           *cardPickTransition;
@property (strong, nonatomic) UIColor *selectedCardColor;

@end

@implementation YFCardCollectionViewController


#pragma mark -  VC lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupCollectionView];
    self.transitioningDelegate = self;
}

#pragma mark - acessors

- (YFCardPickTranstion *)cardPickTransition {
    if (!_cardPickTransition) {
        _cardPickTransition = [YFCardPickTranstion new];
        _cardPickTransition.duration = 0.5;
        _cardPickTransition.cardTopReveal = self.stackedLayout.topReveal;
    }
    return _cardPickTransition;
}

#pragma mark -  collection view setup

- (void)setupCollectionView {
    
    self.stackedLayout.alwaysBounce = YES;
    self.stackedLayout.fillHeight = NO;
    self.stackedLayout.layoutMargin = UIEdgeInsetsZero;
    
    UINib *cardNib = [UINib nibWithNibName:@"CardCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cardNib forCellWithReuseIdentifier:[CardCollectionViewCell reusableIdentifier]];
}

#pragma mark - UICollectionViewDatasource Protocol

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 50.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CardCollectionViewCell reusableIdentifier] forIndexPath:indexPath];
    
    cell.imageView.tintColor = [self randomColor];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate Protocol

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
    CGRect referenceFrame = [collectionView convertRect:attributes.frame toView:collectionView.superview];
    
    self.cardPickTransition.referenceFrame = referenceFrame;
    self.cardPickTransition.singleCardOnStack = [self.collectionView numberOfItemsInSection:0] == 1;
    
    CardCollectionViewCell *cell = (CardCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UIView *snapshotView = [cell snapshotViewAfterScreenUpdates:YES];

    self.cardPickTransition.movingCardSnapshot = snapshotView;
    self.selectedCardColor = cell.imageView.tintColor;
    
    [self performSegueWithIdentifier:@"showDetail" sender:nil];
    
}

- (BOOL)canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - UIViewControllerTransitioningDelegate Protocol

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {

    return  self.cardPickTransition;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ViewController *vc = segue.destinationViewController;
    vc.color = self.selectedCardColor;
    vc.transitioningDelegate = self;
}


#pragma mark - helpers

- (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    return color;
}

@end
