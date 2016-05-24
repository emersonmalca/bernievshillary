//
//  CustomAnimatedTransitionDelegate.h
//  bernievshillary
//
//  Created by emersonmalca on 5/24/16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomAnimatedTransitionDelegate : NSObject <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

+ (CustomAnimatedTransitionDelegate *)transitionDelegateForViewController:(UIViewController *)controller;

@end
