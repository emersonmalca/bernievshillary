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
    [UIView animateWithDuration:kDefaultAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [view setScale:1.0];
        [view setAlpha:1.0];
    } completion:completion];
}

- (void)setScale:(CGFloat)scale {
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
}

@end
