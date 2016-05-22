//
//  UIView+Utilities.h
//  bernievshillary
//
//  Created by emersonmalca on 5/18/16.
//
//

#import <UIKit/UIKit.h>

@interface UIView (Utilities)

+ (void)scaleViewToIdentityScale:(nonnull UIView *)view finalAlpha:(CGFloat)finalAlpha completion:(void(^ __nullable)(BOOL))completion;
+ (void)scaleViewToIdentityScale:(nonnull UIView *)view finalAlpha:(CGFloat)finalAlpha delay:(CGFloat)delay completion:(void(^ __nullable)(BOOL))completion;
+ (void)animateWithSoftPhysicsDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(void (^ __nonnull)(void))animations completion:(void (^ __nullable)(BOOL finished))completion;
- (void)fadeIn;
- (void)fadeOut;

- (void)setScale:(CGFloat)scale;
- (void)setAnchorPointAdjustingPosition:(CGPoint)anchorPoint;

@end
