//
//  IntroViewController.m
//  bernievshillary
//
//  Created by emersonmalca on 5/17/16.
//
//

#import "IntroViewController.h"

@interface IntroViewController ()

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topContainerBottomConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomContainerTopConstraint;
@property (strong, nonatomic) IBOutlet UIView *topContainer;
@property (strong, nonatomic) IBOutlet UIView *bottomContainer;
@property (strong, nonatomic) CAShapeLayer *topMask;
@property (strong, nonatomic) CAShapeLayer *bottomMask;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mainContainerBottomConstraint;

@end

@implementation IntroViewController

#define OverlapRatio    0.35

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateMargins];
    
    // Create the masks
    CAShapeLayer *mask = [CAShapeLayer layer];
    //mask.frame = self.topContainer.bounds;
    mask.path = [self pathForTopContainerMask];
    self.topContainer.layer.mask = mask;
    self.topContainer.layer.masksToBounds = YES;
    self.topMask = mask;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self updateMargins];
    
    // Adjust the mask
    self.topMask.path = [self pathForTopContainerMask];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
}

#pragma mark - Custom methods

- (void)updateMargins {
    // We want the 2 containers to overlap by 30% (half on one side, half on the other)
    CGFloat marginHeight = self.view.bounds.size.height*(0.5 - OverlapRatio/2.0);
    self.topContainerBottomConstraint.constant = marginHeight;
    self.bottomContainerTopConstraint.constant = marginHeight;
    [self.view setNeedsLayout];
}

- (CGPathRef)pathForTopContainerMask {
    CGRect bounds = self.topContainer.bounds;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(CGRectGetMinX(bounds), CGRectGetMinY(bounds))];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(bounds), CGRectGetMinY(bounds))];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds)*(1.0-OverlapRatio))];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds))];
    [path closePath];
    return [path CGPath];
}

- (CGPathRef)pathForBottomContainerMask {
    CGRect bounds = self.bottomContainer.bounds;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(CGRectGetMinX(bounds), CGRectGetMinY(bounds)*(1.0-OverlapRatio))];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(bounds), CGRectGetMinY(bounds))];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds))];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds))];
    [path closePath];
    return [path CGPath];
}

@end
