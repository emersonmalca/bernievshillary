//
//  ShareViewController.m
//  bernievshillary
//
//  Created by Haider Khan on 5/24/16.
//
//

#import "ShareViewController.h"
#import "BHKit.h"
#import "Amplitude.h"

@interface ShareViewController ()

@property (strong, nonatomic) IBOutlet UIVisualEffectView *backgroundView;
@property (strong, nonatomic) IBOutlet UIView *mainContainer;
@property (strong, nonatomic) IBOutlet UIButton *btnShareResults;
@property (strong, nonatomic) IBOutlet UIButton *btnShareApp;

@property (strong, nonatomic) CustomAnimatedTransitionDelegate *transitioner;

@end

@implementation ShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // This will handle the transitions when presented modally
        self.transitioner = [CustomAnimatedTransitionDelegate transitionDelegateForViewController:self];
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.transitioningDelegate = self.transitioner;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Start off with the views not visible
    self.backgroundView.alpha = 0.0;
    self.mainContainer.alpha = 0.0;
    
    // Allow for multiple lines on the button
    self.btnShareApp.titleLabel.numberOfLines = 0;
    self.btnShareApp.titleLabel.textAlignment =  NSTextAlignmentCenter;
    self.btnShareResults.titleLabel.numberOfLines = 0;
    self.btnShareResults.titleLabel.textAlignment =  NSTextAlignmentCenter;
    
    // Track tap on the background to exit
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnBackground:)];
    [self.backgroundView addGestureRecognizer:tap];
}

#pragma mark - Action methods

- (void)tapOnBackground:(UITapGestureRecognizer *)tap {
    if ([tap state] == UIGestureRecognizerStateRecognized) {
        [self.delegate shareViewController:self didFinishWithDecision:ShareControllerDecisionCancel];
    }
}

- (IBAction)btnShareResultsPressed:(UIButton *)sender {
    
    UIImage *image = [self.delegate shareViewControllerImageToShare:self];
    NSString *message = [self.delegate shareViewControllerTextForLatestResults:self];
    NSString *link = @"https://itunes.apple.com/app/apple-store/id1116530749?pt=118248079&ct=results-share&mt=8";
    message = [message stringByAppendingFormat:@" %@", link];
    NSArray *itemsToShare = @[message, image];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypeAirDrop];
    [[UIApplication topMostViewController] presentViewController:activityVC animated:YES completion:nil];
    
    //Track
    [[Amplitude instance] logEvent:@"Share" withEventProperties:@{@"type":@"results"}];
}

- (IBAction)btnShareAppPressed:(UIButton *)sender {
    NSString *link = @"https://itunes.apple.com/app/apple-store/id1116530749?pt=118248079&ct=app-share&mt=8";
    NSString *message = @"Find which Democratic candidate matches YOUR values! #BernieOrHillary ";
    NSURL *url = [NSURL URLWithString:link];
    NSArray *itemsToShare = @[message, url];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypeAirDrop];
    [[UIApplication topMostViewController] presentViewController:activityVC animated:YES completion:nil];
    
    //Track
    [[Amplitude instance] logEvent:@"Share" withEventProperties:@{@"type":@"app"}];
}

- (IBAction)btnStartOverPressed:(UIButton *)sender {
    [self.delegate shareViewController:self didFinishWithDecision:ShareControllerDecisionStartOver];
}

#pragma mark - Controller animated transitions

- (void)animateInFromViewController:(UIViewController *)fromViewController completion:(void (^)(BOOL finished))completion {
    
    // Fade in background
    [self.backgroundView fadeIn];
    
    // Bring up the main view
    [self.mainContainer fadeInFromSide:UIViewSideBottom completion:completion];
    
}

- (void)animateOutToViewController:(UIViewController *)toViewController completion:(void (^)(BOOL finished))completion {
    
    // Fade out background
    [self.backgroundView fadeOut];
    
    // Slide out the main view
    [self.mainContainer fadeOutToSide:UIViewSideBottom completion:completion];
}

@end
