//
//  UIView+Utilities.h
//  bernievshillary
//
//  Created by emersonmalca on 5/18/16.
//
//

#import <UIKit/UIKit.h>

@interface UIView (Utilities)

+ (void)scaleViewToIdentityScale:(UIView *)view finalAlpha:(CGFloat)finalAlpha completion:(void(^)(BOOL))completion;
+ (void)scaleViewToIdentityScale:(UIView *)view finalAlpha:(CGFloat)finalAlpha delay:(CGFloat)delay completion:(void(^)(BOOL))completion;
- (void)setScale:(CGFloat)scale;
- (void)setAnchorPointAdjustingPosition:(CGPoint)anchorPoint;

@end
