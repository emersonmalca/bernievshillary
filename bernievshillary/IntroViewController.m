//
//  IntroViewController.m
//  bernievshillary
//
//  Created by emersonmalca on 5/17/16.
//
//

#import "IntroViewController.h"
#import "BHKit.h"

@interface IntroViewController ()

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topContainerBottomConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomContainerTopConstraint;
@property (strong, nonatomic) IBOutlet UIView *topContainer;
@property (strong, nonatomic) IBOutlet UIView *bottomContainer;
@property (strong, nonatomic) IBOutlet UIView *titleContainer;
@property (strong, nonatomic) IBOutlet UIImageView *bernie;
@property (strong, nonatomic) IBOutlet UIImageView *hillary;
@property (strong, nonatomic) CAShapeLayer *topMask;
@property (strong, nonatomic) CAShapeLayer *bottomMask;

@property (strong, nonatomic) IBOutlet UIView *getStartedView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *getStartedViewBottomConstraint;

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
    
    // Hide stuff for presentation
    self.bernie.alpha = 0.0;
    self.hillary.alpha = 0.0;
    [self.bernie setScale:0.75];
    [self.hillary setScale:0.75];
    for (UIView *sv in self.titleContainer.subviews) {
        sv.alpha = 0.0;
        [sv setScale:0.75];
    }
    
    // Hide get started view
    self.getStartedViewBottomConstraint.constant = -self.getStartedView.bounds.size.height;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Show everything
    [UIView scaleViewToIdentityScale:self.bernie finalAlpha:1.0 completion:NULL];
    [UIView scaleViewToIdentityScale:self.hillary finalAlpha:1.0 delay:0.1 completion:NULL];
    CGFloat delay = 0.4;
    for (UIView *sv in self.titleContainer.subviews) {
        [UIView scaleViewToIdentityScale:sv finalAlpha:1.0 delay:delay completion:NULL];
        delay += 0.3;
    }
    
    // Animate in the get started view after a bit
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithSoftPhysicsDuration:0.6 delay:0.0 options:0 animations:^{
            self.getStartedViewBottomConstraint.constant = 0.0;
            [self.view layoutIfNeeded];
        } completion:NULL];
    });
     
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
