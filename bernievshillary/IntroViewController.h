//
//  IntroViewController.h
//  bernievshillary
//
//  Created by emersonmalca on 5/17/16.
//
//

#import <UIKit/UIKit.h>
@protocol IntroViewControllerDelegate;

@interface IntroViewController : UIViewController

@property (weak, nonatomic) id<IntroViewControllerDelegate> delegate;

@end

@protocol IntroViewControllerDelegate <NSObject>

- (void)introViewControllerDidSelectToGetStarted:(IntroViewController *)controller;

@end
