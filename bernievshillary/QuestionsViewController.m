//
//  QuestionsViewController.m
//  bernievshillary
//
//  Created by emersonmalca on 5/19/16.
//
//

#import "QuestionsViewController.h"

@interface QuestionsViewController ()

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *questionContainerTopConstraint;
@property (strong, nonatomic) IBOutlet UIView *questionContainer;
@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) IBOutlet UIView *buttonsContainer;

@end

@implementation QuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.buttonsContainer.alpha = 0.0;
}

#pragma mark - Custom methods

@end
