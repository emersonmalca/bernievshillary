//
//  UIViewController+Utilities.m
//  bernievshillary
//
//  Created by emersonmalca on 5/19/16.
//
//

#import "UIViewController+Utilities.h"

@implementation UIViewController (Utilities)

+ (id)initWithNib {
    NSString *nibName = NSStringFromClass(self);
    return [[self alloc] initWithNibName:nibName bundle:nil];
}

- (void)runPostPresentationAnimationWithCompletion:(void(^)(BOOL finished))completion {
    if (completion) {
        completion(YES);
    }
}

- (void)runPreDismissalAnimationWithCompletion:(void(^)(BOOL finished))completion {
    if (completion) {
        completion(YES);
    }
}

- (void)animateInFromViewController:(UIViewController *)fromViewController completion:(void (^)(BOOL finished))completion { //To be used by subclasses
    if (completion) {
        completion(YES);
    }
}

- (void)animateOutToViewController:(UIViewController *)toViewController completion:(void (^)(BOOL finished))completion { //To be used by subclasses
    if (completion) {
        completion(YES);
    }
}

- (void)transitionSequentuallyFromChildViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController completion:(void (^)(BOOL))completion {
    
    // Remove FROM controller from hierarchy and add TO controller
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    toViewController.view.frame = self.view.frame;
    
    // Animate out FROM controller view
    __weak UIViewController *weakSelf = self;
    __weak UIViewController *weakFromController = fromViewController;
    __weak UIViewController *weakToController = toViewController;
    [fromViewController runPreDismissalAnimationWithCompletion:^(BOOL finished){
       
        // Remove FROM controller and view
        UIViewController *strongFromController = weakFromController;
        if (strongFromController) {
            [[strongFromController view] removeFromSuperview];
            [strongFromController removeFromParentViewController];
            
            // Add TO controller view to hierarchy
            UIViewController *strongSelf = weakSelf;
            if (strongSelf) {
                [[strongSelf view] addSubview:toViewController.view];
            }
            
            // Animate TO controller in
            [toViewController runPostPresentationAnimationWithCompletion:^(BOOL finished){
                UIViewController *strongSelf = weakSelf;
                UIViewController *strongToController = weakToController;
                if (strongSelf && strongToController) {
                    [strongToController didMoveToParentViewController:strongSelf];
                }
                
                // Call completion block
                if (completion) {
                    completion(finished);
                }
            }];
        }
        
    }];
    
}

@end
