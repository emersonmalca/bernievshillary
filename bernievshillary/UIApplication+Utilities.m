//
//  UIApplication+Utilities.m
//  bernievshillary
//
//  Created by emersonmalca on 5/24/16.
//
//

#import "UIApplication+Utilities.h"

@implementation UIApplication (Utilities)

+ (UIViewController *)topMostViewController {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}

@end
