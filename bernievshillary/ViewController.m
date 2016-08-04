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
#import "ResultsViewController.h"
#import "BHKit.h"
@class Question;
@class UserResponse;

@interface ViewController () <IntroViewControllerDelegate, QuestionsViewControllerDelegate, ResultsViewControllerDelegate>

//@property (strong, nonatomic) IntroViewController *introController;

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
    questionsController.delegate = self;
    [self transitionSequentuallyFromChildViewController:controller toViewController:questionsController completion:NULL];
}

#pragma mark - QuestionsViewController delegate

- (void)questionsViewController:(QuestionsViewController *)controller didFinishWithQuestions:(NSArray<Question*> *)questions userResponses:(NSMutableDictionary<NSString*, UserResponse*> *)userResponses {
    
    // Show the results controller to calculate and display the results
    ResultsViewController *resultsController = [ResultsViewController initWithNib];
    resultsController.delegate = self;
    [resultsController showResultsForUserResponses:[userResponses allValues]];
    [self transitionSequentuallyFromChildViewController:controller toViewController:resultsController completion:NULL];
}

#pragma mark - ResultsViewControllerDelegate

- (void)resultsViewControllerDidSelectToStartOver:(nonnull ResultsViewController *)controller {
    
    // Show questions again
    QuestionsViewController *questionsController = [QuestionsViewController initWithNib];
    questionsController.delegate = self;
    [self transitionSequentuallyFromChildViewController:controller toViewController:questionsController completion:NULL];
}

@end
