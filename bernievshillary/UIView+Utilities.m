//
//  UIView+Utilities.m
//  bernievshillary
//
//  Created by emersonmalca on 5/18/16.
//
//

#import "UIView+Utilities.h"

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

- (void)fadeInFromSide:(UIViewSide)side completion:(void (^)(BOOL finished))completion {
    [self fadeInFromSide:side withDuration:kDefaultAnimationDuration delay:0.0 offset:0.0 completion:completion];
}

- (void)fadeInFromSide:(UIViewSide)side withDuration:(CGFloat)duration delay:(CGFloat)delay offset:(CGFloat)offset completion:(void (^)(BOOL finished))completion {
    CGRect finalFrame = self.frame;
    CGRect initialFrame = finalFrame;
    
    if (side == UIViewSideTop) {
        initialFrame.origin.y -= (offset != 0.0)?offset:CGRectGetHeight(initialFrame)/2;
    } else if (side == UIViewSideBottom) {
        initialFrame.origin.y += (offset != 0.0)?offset:CGRectGetHeight(initialFrame)/2;
    } else if (side == UIViewSideLeft ) {
        initialFrame.origin.x -= (offset != 0.0)?offset:CGRectGetWidth(initialFrame)/2;
    } else if (side == UIViewSideRight) {
        initialFrame.origin.x += (offset != 0.0)?offset:CGRectGetWidth(initialFrame)/2;
    }
    
    self.frame = initialFrame;
    self.alpha = 0.0;
    
    [UIView animateWithDuration:duration
                          delay:delay
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.frame = finalFrame;
                         self.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         if (completion != NULL) {
                             completion(finished);
                         }
                     }];
}

- (void)fadeOutToSide:(UIViewSide)side completion:(void (^)(BOOL finished))completion {
    [self fadeOutToSide:side withDuration:kDefaultAnimationDuration delay:0.0 offset:0.0 completion:completion];
}

- (void)fadeOutToSide:(UIViewSide)side withDuration:(CGFloat)duration delay:(CGFloat)delay offset:(CGFloat)offset completion:(void (^)(BOOL finished))completion {
    
    CGRect initialFrame = self.frame;
    CGRect finalFrame = self.frame;
    
    if (side == UIViewSideTop) {
        finalFrame.origin.y -= (offset != 0.0)?offset:CGRectGetHeight(initialFrame)/2;
    } else if (side == UIViewSideBottom) {
        finalFrame.origin.y += (offset != 0.0)?offset:CGRectGetHeight(initialFrame)/2;
    } else if (side == UIViewSideLeft ) {
        finalFrame.origin.x -= (offset != 0.0)?offset:CGRectGetWidth(initialFrame)/2;
    } else if (side == UIViewSideRight) {
        finalFrame.origin.x += (offset != 0.0)?offset:CGRectGetWidth(initialFrame)/2;
    }
    
    [UIView animateWithDuration:duration
                          delay:delay
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.frame = finalFrame;
                         self.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         self.frame = initialFrame;
                         if (completion != NULL) {
                             completion(finished);
                         }
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

- (UIImage *)screenshotOpaque:(BOOL)opaque highQuality:(BOOL)highQuality {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, opaque, 0.0);
    
    if (highQuality) {
        CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationHigh);
    } else {
        //Lower the quality so that the screen shot is faster
        CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationNone);
    }
    
    //[self.layer renderInContext:UIGraphicsGetCurrentContext()]; //Old method
    
    // New, faster method
    // We have to use screenUpdates NO, otherwise iPhone6/6S running iOS8 will have a scale glitch
    // http://stackoverflow.com/questions/26070420/ios8-scale-glitch-when-calling-drawviewhierarchyinrect-afterscreenupdatesyes
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)screenshot {
    return [self screenshotOpaque:YES highQuality:NO];
}

@end
