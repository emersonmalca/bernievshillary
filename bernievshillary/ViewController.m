//
//  ViewController.m
//  bernievshillary
//
//  Created by emersonmalca on 5/15/16.
//
//

#import "ViewController.h"
#import "IntroViewController.h"
#import "QuestionsViewController.h"
#import "BHKit.h"

@interface ViewController () <IntroViewControllerDelegate>

@property (strong, nonatomic) IntroViewController *introController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Show the intro
    IntroViewController *introController = [IntroViewController initWithNib];
    introController.delegate = self;
    [self addChildViewController:introController];
    introController.view.frame = self.view.frame;
    [self.view addSubview:introController.view];
    [introController didMoveToParentViewController:self];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - IntroViewController delegate

- (void)introViewControllerDidSelectToGetStarted:(IntroViewController *)controller {
    
    // Remove this controller and show the next one
    QuestionsViewController *questionsController = [QuestionsViewController initWithNib];
    [self transitionSequentuallyFromChildViewController:controller toViewController:questionsController completion:NULL];
}

@end
