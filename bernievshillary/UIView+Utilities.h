//
//  UIView+Utilities.h
//  bernievshillary
//
//  Created by emersonmalca on 5/18/16.
//
//

#import <UIKit/UIKit.h>

#define kDefaultAnimationDuration  0.3

typedef enum {
    UIViewSideTop = 0,
    UIViewSideLeft,
    UIViewSideBottom,
    UIViewSideRight
} UIViewSide;

@interface UIView (Utilities)

+ (void)scaleViewToIdentityScale:(nonnull UIView *)view finalAlpha:(CGFloat)finalAlpha completion:(void(^ __nullable)(BOOL))completion;
+ (void)scaleViewToIdentityScale:(nonnull UIView *)view finalAlpha:(CGFloat)finalAlpha delay:(CGFloat)delay completion:(void(^ __nullable)(BOOL))completion;
+ (void)animateWithSoftPhysicsDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(void (^ __nonnull)(void))animations completion:(void (^ __nullable)(BOOL finished))completion;
- (void)fadeIn;
- (void)fadeOut;
- (void)fadeInFromSide:(UIViewSide)side completion:(void (^ __nullable)(BOOL finished))completion;
- (void)fadeInFromSide:(UIViewSide)side withDuration:(CGFloat)duration delay:(CGFloat)delay offset:(CGFloat)offset completion:( void (^ __nullable)(BOOL finished))completion;
- (void)fadeOutToSide:(UIViewSide)side completion:(void (^ __nullable)(BOOL finished))completion;
- (void)fadeOutToSide:(UIViewSide)side withDuration:(CGFloat)duration delay:(CGFloat)delay offset:(CGFloat)offset completion:(void (^ __nullable)(BOOL finished))completion;

- (void)setScale:(CGFloat)scale;
- (void)setAnchorPointAdjustingPosition:(CGPoint)anchorPoint;
- (void)spinClockwise:(BOOL)clockwise duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat timingFunction:(nullable CAMediaTimingFunction *)timingFunction;
- (void)stopSpinning;

- (nonnull UIImage *)screenshot;
- (nonnull UIImage *)screenshotOpaque:(BOOL)opaque highQuality:(BOOL)highQuality;

@end
