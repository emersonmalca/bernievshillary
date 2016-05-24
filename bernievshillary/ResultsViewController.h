//
//  ResultsViewController.h
//  bernievshillary
//
//  Created by emersonmalca on 5/22/16.
//
//

#import <UIKit/UIKit.h>
@class UserResponse;
@protocol ResultsViewControllerDelegate;

@interface ResultsViewController : UIViewController

@property (weak, nonatomic) __nullable id<ResultsViewControllerDelegate> delegate;

- (void)showResultsForUserResponses:(nonnull NSArray<UserResponse*> *)responses;

@end

@protocol ResultsViewControllerDelegate <NSObject>

- (void)resultsViewControllerDidSelectToStartOver:(nonnull ResultsViewController *)controller;

@end
