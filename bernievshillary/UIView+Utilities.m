//
//  UIView+Utilities.m
//  bernievshillary
//
//  Created by emersonmalca on 5/18/16.
//
//

#import "UIView+Utilities.h"

#define kDefaultAnimationDuration  0.3

@implementation UIView (Utilities)

#pragma mark - Animation

+ (void)scaleViewToIdentityScale:(UIView *)view finalAlpha:(CGFloat)finalAlpha completion:(void(^)(BOOL))completion {
    [self scaleViewToIdentityScale:view finalAlpha:finalAlpha delay:0.0 completion:completion];
}

+ (void)scaleViewToIdentityScale:(UIView *)view finalAlpha:(CGFloat)finalAlpha delay:(CGFloat)delay completion:(void(^)(BOOL))completion {
    [UIView animateWithDuration:kDefaultAnimationDuration delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
        [view setScale:1.0];
        [view setAlpha:1.0];
    } completion:completion];
}

+ (void)animateWithSoftPhysicsDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^ __nullable)(BOOL finished))completion {
    [UIView animateWithDuration:duration delay:delay usingSpringWithDamping:0.75 initialSpringVelocity:0.25 options:options animations:animations completion:completion];
}

- (void)fadeIn {
    [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
        self.alpha = 1.0;
    }];
}

- (void)fadeOut {
    [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
        self.alpha = 0.0;
    }];
}

#pragma mark - others

- (void)setScale:(CGFloat)scale {
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
}

-(void)setAnchorPointAdjustingPosition:(CGPoint)anchorPoint {
    
    CGPoint newPoint = CGPointMake(self.bounds.size.width * anchorPoint.x, self.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(self.bounds.size.width * self.layer.anchorPoint.x, self.bounds.size.height * self.layer.anchorPoint.y);
    
    if (!CGPointEqualToPoint(newPoint, oldPoint)) {
        newPoint = CGPointApplyAffineTransform(newPoint, self.transform);
        oldPoint = CGPointApplyAffineTransform(oldPoint, self.transform);
        
        CGPoint position = self.layer.position;
        position.x -= oldPoint.x;
        position.x += newPoint.x;
        position.y -= oldPoint.y;
        position.y += newPoint.y;
        
        self.layer.position = position;
        self.layer.anchorPoint = anchorPoint;
    }
}

- (void)spinClockwise:(BOOL)clockwise duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat timingFunction:(CAMediaTimingFunction *)timingFunction
{
    CGFloat direction = (clockwise)?1.0:-1.0;
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * direction];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    if (timingFunction) {
        rotationAnimation.timingFunction = timingFunction;
    }
    
    [self.layer addAnimation:rotationAnimation forKey:@"spinAnimation"];
}

- (void)stopSpinning {
    [self.layer removeAnimationForKey:@"spinAnimation"];
}

@end
