//
//  ResultsViewController.m
//  bernievshillary
//
//  Created by emersonmalca on 5/22/16.
//
//

#import "ResultsViewController.h"
#import "BHKit.h"

@interface ResultsViewController ()

@property (strong, nonatomic) IBOutlet UIView *mainContainer;
@property (strong, nonatomic) IBOutlet UIView *topContainer;
@property (strong, nonatomic) IBOutlet UIView *bottomContainer;
@property (strong, nonatomic) CAShapeLayer *bottomMask;

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainContainer.alpha = 0.0;
    
    // Create the masks
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = [self pathForBottomContainerMask];
    self.bottomContainer.layer.mask = mask;
    self.bottomContainer.layer.masksToBounds = YES;
    self.bottomMask = mask;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    // Adjust the mask
    [self.mainContainer layoutIfNeeded];
    self.bottomMask.path = [self pathForBottomContainerMask];
}

- (void)runPostPresentationAnimationWithCompletion:(void(^)(BOOL finished))completion {
    
    [UIView animateWithDuration:0.6 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.mainContainer.alpha = 1.0;
    } completion:completion];
}

#pragma mark - Custom methods

- (CGPathRef)pathForBottomContainerMask {
    CGRect bounds = self.bottomContainer.bounds;
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat overlapRatio = (self.topContainer.bounds.size.height + self.bottomContainer.bounds.size.height - self.mainContainer.bounds.size.height)/self.mainContainer.bounds.size.height;
    [path moveToPoint:CGPointMake(CGRectGetMinX(bounds), CGRectGetHeight(bounds)*overlapRatio*2.0)];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(bounds), CGRectGetMinY(bounds))];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds))];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds))];
    [path closePath];
    return [path CGPath];
}

@end
