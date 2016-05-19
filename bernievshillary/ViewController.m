//
//  ViewController.m
//  bernievshillary
//
//  Created by emersonmalca on 5/15/16.
//
//

#import "ViewController.h"
#import "IntroViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IntroViewController *introController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Show the intro
    self.introController = [[IntroViewController alloc] initWithNibName:@"IntroViewController" bundle:nil];
    [self addChildViewController:self.introController];
    self.introController.view.frame = self.view.frame;
    [self.view addSubview:self.introController.view];
    [self.introController didMoveToParentViewController:self];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
