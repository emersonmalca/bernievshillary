//
//  ShareViewController.h
//  bernievshillary
//
//  Created by Haider Khan on 5/24/16.
//
//

#import <UIKit/UIKit.h>
@protocol ShareViewControllerDelegate;

typedef NS_ENUM(NSUInteger, ShareControllerDecision) {
    ShareControllerDecisionCancel,
    ShareControllerDecisionStartOver
};

@interface ShareViewController : UIViewController

@property (weak, nonatomic) id<ShareViewControllerDelegate> delegate;

@end

@protocol ShareViewControllerDelegate <NSObject>

- (NSString *)shareViewControllerTextForLatestResults:(ShareViewController *)shareController;
- (UIImage *)shareViewControllerImageToShare:(ShareViewController *)shareController;
- (void)shareViewController:(ShareViewController *)shareController didFinishWithDecision:(ShareControllerDecision)decision;

@end