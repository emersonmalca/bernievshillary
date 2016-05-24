//
//  CustomAnimatedTransitionDelegate.m
//  bernievshillary
//
//  Created by emersonmalca on 5/24/16.
//
//

#import "CustomAnimatedTransitionDelegate.h"
#import "BHKit.h"

@interface CustomAnimatedTransitionDelegate ()

@property (weak, nonatomic) UIViewController *targetViewController;

@end

@implementation CustomAnimatedTransitionDelegate

+ (CustomAnimatedTransitionDelegate *)transitionDelegateForViewController:(UIViewController *)controller {
    CustomAnimatedTransitionDelegate *transitioner = [[CustomAnimatedTransitionDelegate alloc] initForViewController:controller];
    return transitioner;
}

- (id)init {
    [NSException raise:NSGenericException format:@"Must be initialized with the %@ initializer", NSStringFromSelector(@selector(initForViewController:))];
    return nil;
}

- (id)initForViewController:(UIViewController *)controller {
    self = [super init];
    if (self) {
        self.targetViewController = controller;
    }
    return self;
}

#pragma mark - Presentation and dismissal animation (UIViewControllerTransitioningDelegate)

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return (presented == self.targetViewController)?self:nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return (dismissed == self.targetViewController)?self:nil;
}

#pragma mark - Presentation and dismissal animation (UIViewControllerAnimatedTransitioning)

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    //Grab the players
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    BOOL isPresenting = (toViewController.presentingViewController == fromViewController);
    UIView *containerView = [transitionContext containerView];
    
    //Presentation or dismissal of this view controller
    if (isPresenting) {
        //Setup initial view states
        CGRect finalToViewFrame = [transitionContext finalFrameForViewController:toViewController];
        
        // It is extremely likely to get CGRectZero since the view is not on the screen and we're doing a custom animation. If we're presenting this view it is obvious
        // the frame shouldn't be zero, so as a fallback we use the initialFrame for the from view controller
        // https://www.bignerdranch.com/blog/golden-opportunity-custom-transitions/
        if (CGRectEqualToRect(CGRectZero, finalToViewFrame)) {
            finalToViewFrame = [transitionContext initialFrameForViewController:fromViewController];
        }
        
        toViewController.view.frame = finalToViewFrame;
        [containerView addSubview:toViewController.view];
        
        //Animate everything in
        [toViewController animateInFromViewController:fromViewController completion:^(BOOL finished){
            
            //Tell the transition context that we're done
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    } else {
        //Animate out
        [fromViewController animateOutToViewController:toViewController completion:^(BOOL finished){
            [fromView removeFromSuperview];
            
            //Tell the transition context that we're done
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    }
}

@end
