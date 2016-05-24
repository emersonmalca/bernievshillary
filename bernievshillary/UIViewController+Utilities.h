//
//  UIViewController+Utilities.h
//  bernievshillary
//
//  Created by emersonmalca on 5/19/16.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (Utilities)

+ (id)initWithNib;
- (void)runPostPresentationAnimationWithCompletion:(void(^)(BOOL finished))completion;
- (void)runPreDismissalAnimationWithCompletion:(void(^)(BOOL finished))completion;
- (void)animateInFromViewController:(UIViewController *)fromViewController completion:(void (^)(BOOL finished))completion;
- (void)animateOutToViewController:(UIViewController *)toViewController completion:(void (^)(BOOL finished))completion;
- (void)transitionSequentuallyFromChildViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController completion:(void (^)(BOOL))completion;

@end
