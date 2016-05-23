//
//  ResultsViewController.m
//  bernievshillary
//
//  Created by emersonmalca on 5/22/16.
//
//

#import "ResultsViewController.h"
#import "BHKit.h"
#import "UserResponse.h"
#import "CandidateStand.h"

@interface ResultsViewController ()

@property (strong, nonatomic) IBOutlet UIView *mainContainer;
@property (strong, nonatomic) IBOutlet UIView *topContainer;
@property (strong, nonatomic) IBOutlet UILabel *topScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *topNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *topImageView;

@property (strong, nonatomic) IBOutlet UIView *bottomContainer;
@property (strong, nonatomic) IBOutlet UILabel *bottomScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *bottomNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *bottomImageView;

@property (strong, nonatomic) IBOutlet UIView *rays;
@property (strong, nonatomic) CAShapeLayer *bottomMask;

@property (strong, nonatomic) NSMutableArray<UserResponse*> *userResponses;
@property (strong, nonatomic) CandidateStand *topStand;
@property (strong, nonatomic) CandidateStand *otherStand;

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initial UI values
    self.mainContainer.alpha = 0.0;
    self.rays.alpha = 0.0;
    
    // Create the masks
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = [self pathForBottomContainerMask];
    self.bottomContainer.layer.mask = mask;
    self.bottomContainer.layer.masksToBounds = YES;
    self.bottomMask = mask;
    
    // Update UI
    [self updateUIForCurrentUserReponses];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    // Adjust the mask
    [self.mainContainer layoutIfNeeded];
    self.bottomMask.path = [self pathForBottomContainerMask];
}

- (void)runPostPresentationAnimationWithCompletion:(void(^)(BOOL finished))completion {
    
    // Animate in main elements
    [UIView animateWithDuration:0.6 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.mainContainer.alpha = 1.0;
    } completion:^(BOOL finished){
        
        // Asynchronously start showing the rays
        [UIView animateWithDuration:0.6 animations:^{
            self.rays.alpha = 1.0;
        }];
        [self.rays spinClockwise:YES duration:5.0 rotations:1.0 repeat:CGFLOAT_MAX timingFunction:nil];
        
        if (completion) {
            completion(finished);
        }
    }];
}

#pragma mark - Custom methods

- (void)showResultsForUserResponses:(nonnull NSArray<UserResponse*> *)responses {
    [self.userResponses setArray:responses];
    
    if ([self isViewLoaded]) {
        [self updateUIForCurrentUserReponses];
    }
}

- (void)updateUIForCurrentUserReponses {
    
    /*
     NOTE: This could be done in a more flexible way to allow for any number of candidates, but for now it's not needed
     */
    CandidateStand *bernieTotalStand = [[CandidateStand alloc] init];
    bernieTotalStand.candidate = CandidateBernie;
    CandidateStand *hillaryTotalStand = [[CandidateStand alloc] init];
    hillaryTotalStand.candidate = CandidateHillary;
    
    // We want to ignore the questions where the user was neutral (aka Not Sure)
    int totalNumberOfQuestionsToTakeIntoAccount = 0;
    for (UserResponse *userResponse in self.userResponses) {
        if (userResponse.userPositionType != IssuePositionTypeNeutral) {
            totalNumberOfQuestionsToTakeIntoAccount += 1;
            
            // Get the candidate scores and add them to the total
            for (CandidateStand *stand in userResponse.candidateStands) {
                switch (stand.candidate) {
                    case CandidateBernie: {
                        bernieTotalStand.matchScore += stand.matchScore;
                        break;
                    }
                    case CandidateHillary: {
                        hillaryTotalStand.matchScore += stand.matchScore;
                        break;
                    }
                }
            }
        }
    }
    
    // Normalize total match scores
    bernieTotalStand.matchScore = bernieTotalStand.matchScore/(float)totalNumberOfQuestionsToTakeIntoAccount;
    hillaryTotalStand.matchScore = hillaryTotalStand.matchScore/(float)totalNumberOfQuestionsToTakeIntoAccount;
    
    // Determine which one is the top match
    if (hillaryTotalStand.matchScore > bernieTotalStand.matchScore) {
        self.topStand = hillaryTotalStand;
        self.otherStand = bernieTotalStand;
    } else {
        self.topStand = bernieTotalStand;
        self.otherStand = hillaryTotalStand;
    }
    
    
    // Update UI
    self.topNameLabel.text = [CandidateStand fullNameForCandidate:self.topStand.candidate];
    self.bottomNameLabel.text = [CandidateStand fullNameForCandidate:self.otherStand.candidate];
    self.topScoreLabel.text = [NSString stringWithFormat:@"%.0f%%", self.topStand.matchScore * 100.0];
    self.bottomScoreLabel.text = [NSString stringWithFormat:@"%.0f%%", self.otherStand.matchScore * 100.0];
    self.topImageView.image = [CandidateStand fullSizeImageForCandidate:self.topStand.candidate];
    self.bottomImageView.image = [CandidateStand fullSizeImageForCandidate:self.otherStand.candidate];
    self.topContainer.backgroundColor = [CandidateStand colorForCandidate:self.topStand.candidate];
    self.bottomContainer.backgroundColor = [CandidateStand colorForCandidate:self.otherStand.candidate];
    
    // Quick fix: If hillary is on top, their images have to be flipped to face the score
    if (self.topStand.candidate == CandidateHillary) {
        self.topImageView.transform = CGAffineTransformMakeScale(-1, 1); //Flipped
        self.bottomImageView.transform = CGAffineTransformMakeScale(-1, 1); //Flipped
    }
}

- (nonnull NSMutableArray<UserResponse*> *)userResponses {
    if (_userResponses == nil) {
        _userResponses = [NSMutableArray array];
    }
    return _userResponses;
}

- (CGPathRef)pathForBottomContainerMask {
    CGRect bounds = self.bottomContainer.bounds;
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat overlapRatio = (self.topContainer.bounds.size.height + self.bottomContainer.bounds.size.height - self.mainContainer.bounds.size.height)/self.mainContainer.bounds.size.height;
    [path moveToPoint:CGPointMake(CGRectGetMinX(bounds), CGRectGetHeight(bounds)*overlapRatio*2.0)];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(bounds), CGRectGetMinY(bounds))];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds))];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds))];
    [path closePath];
    return [path CGPath];
}

@end
