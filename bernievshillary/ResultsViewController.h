//
//  ResultsViewController.h
//  bernievshillary
//
//  Created by emersonmalca on 5/22/16.
//
//

#import <UIKit/UIKit.h>
@class UserResponse;

@interface ResultsViewController : UIViewController

- (void)showResultsForUserResponses:(nonnull NSArray<UserResponse*> *)responses;

@end
