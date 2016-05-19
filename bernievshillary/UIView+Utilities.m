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

+ (void)scaleViewToIdentityScale:(UIView *)view finalAlpha:(CGFloat)finalAlpha completion:(void(^)(BOOL))completion {
    [self scaleViewToIdentityScale:view finalAlpha:finalAlpha delay:0.0 completion:completion];
}

+ (void)scaleViewToIdentityScale:(UIView *)view finalAlpha:(CGFloat)finalAlpha delay:(CGFloat)delay completion:(void(^)(BOOL))completion {
    [UIView animateWithDuration:kDefaultAnimationDuration delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
        [view setScale:1.0];
        [view setAlpha:1.0];
    } completion:completion];
}

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

@end
