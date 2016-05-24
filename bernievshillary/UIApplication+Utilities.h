//
//  UIApplication+Utilities.h
//  bernievshillary
//
//  Created by emersonmalca on 5/24/16.
//
//

#import <UIKit/UIKit.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface UIApplication (Utilities)

+ (UIViewController *)topMostViewController;

@end
