//
//  QuestionsViewController.m
//  bernievshillary
//
//  Created by emersonmalca on 5/19/16.
//
//

#import "QuestionsViewController.h"
#import "QuestionReusableView.h"
#import <CSStickyHeaderFlowLayout/CSStickyHeaderFlowLayout.h>
#import "Question.h"
#import "BHKit.h"
#import "IssuePosition.h"
#import "CandidateCell.h"
#import "IssuePositionCell.h"
#import "NextQuestionCell.h"
#import "CandidateStand.h"
#import "UserResponse.h"

@interface QuestionsViewController ()

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet CSStickyHeaderFlowLayout *layout;
@property (strong, nonatomic) IBOutlet UIView *buttonsContainer;
@property (strong, nonatomic) IBOutlet UIButton *btnOptionA;
@property (strong, nonatomic) IBOutlet UIButton *btnOptionB;
@property (strong, nonatomic) QuestionReusableView *header;
@property (strong, nonatomic) NextQuestionCell *nextQuestionCell;

@property (strong, nonatomic) NSMutableArray<Question*> *questions;
@property (strong, nonatomic) NSMutableArray<Question*> *extraQuestions;
@property (nonatomic) NSUInteger currentQuestionIndex;
@property (strong, nonatomic) NSMutableDictionary<NSString*, UserResponse*> *userResponses;
@property (strong, nonatomic) NSMutableArray<CandidateStand*> *currentQuestionCandidateStands;

@end

@implementation QuestionsViewController {
    BOOL _isShowingCandidatePositions;
}

static NSString *HeaderIdentifier = @"QuestionReusableView";
static NSString *CandidateCellIdentifier = @"CandidateCell";
static NSString *IssuePositionCellIdentifier = @"IssuePositionCell";
static NSString *FakeHeaderIdentifier = @"FakeHeader";
static NSString *NextQuestionCellIdentifier = @"NextQuestionCell";
static CGFloat sectionVerticalSpacing = 30.0;
static NSUInteger maxQuestionCount = 10;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Prepare data
    self.questions = [NSMutableArray array];
    self.extraQuestions = [NSMutableArray array];
    self.userResponses = [NSMutableDictionary dictionary];
    self.currentQuestionCandidateStands = [NSMutableArray array];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"questions" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSArray<NSDictionary*> *rawQuestions = json[@"questions"];
    
    // TODO: Make random 10
    for (NSDictionary *dict in rawQuestions) {
        Question *question = [Question questionWithDictionary:dict];
        if (self.questions.count < maxQuestionCount) {
            [self.questions addObject:question];
        } else {
            [self.extraQuestions addObject:question];
        }
    }
    
    // Prepare UI
    self.buttonsContainer.alpha = 0.0;
    
    // Prepare collection view
    UINib *headerNib = [UINib nibWithNibName:@"QuestionReusableView" bundle:nil];
    [self.collectionView registerNib:headerNib forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader withReuseIdentifier:HeaderIdentifier];
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout.estimatedItemSize = CGSizeMake(300.0, 200.0);
    self.layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(320.0, 200.0);
    self.layout.parallaxHeaderReferenceSize = [self optimalSizeForHeader];
    self.collectionView.contentOffset = CGPointMake(0.0, self.view.bounds.size.height);
    self.layout.headerReferenceSize = CGSizeZero;
    self.layout.sectionHeadersPinToVisibleBounds = NO;
    self.layout.sectionInset = UIEdgeInsetsMake(sectionVerticalSpacing, 0.0, sectionVerticalSpacing/2.0, 0.0);
    
    // Prepare Section header and Cells
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:FakeHeaderIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CandidateCell" bundle:nil] forCellWithReuseIdentifier:CandidateCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"IssuePositionCell" bundle:nil] forCellWithReuseIdentifier:IssuePositionCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"NextQuestionCell" bundle:nil] forCellWithReuseIdentifier:NextQuestionCellIdentifier];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Update header dimensions
    [self.header layoutIfNeeded];
    self.layout.parallaxHeaderReferenceSize = [self optimalSizeForHeader];
    self.layout.parallaxHeaderMinimumReferenceSize = self.layout.parallaxHeaderReferenceSize;
    
    // Update section margins
    CGFloat sideMargin = (self.view.bounds.size.width - 320.0)/2.0;
    self.layout.sectionInset = UIEdgeInsetsMake(sectionVerticalSpacing, sideMargin, sectionVerticalSpacing/2.0, sideMargin);
}

- (void)runPostPresentationAnimationWithCompletion:(void(^)(BOOL finished))completion {
    
    [UIView animateWithSoftPhysicsDuration:0.6 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.collectionView.contentOffset = CGPointZero;
        
    } completion:^(BOOL finished){
       
        [UIView animateWithDuration:0.6 delay:1.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.buttonsContainer.alpha = 1.0;
        } completion:completion];
        
    }];
}

- (void)runPreDismissalAnimationWithCompletion:(void(^)(BOOL finished))completion {
    CGRect frame = self.collectionView.frame;
    frame.origin.y -= frame.size.height/4.0;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.collectionView.frame = frame;
        self.collectionView.alpha = 0.0;
    } completion:completion];
}

#pragma mark - Action methods

- (IBAction)btnNotSurePressed:(UIButton *)sender {
    [self showCandidatePositionsAndStoreUserResponseForPositionType:IssuePositionTypeNeutral];
}

- (IBAction)btnChangeAnswerPressed:(UIButton *)sender {
    
    // Hide answer stuff and show question again
    _isShowingCandidatePositions = NO;
    [self updateUIForCurrentQuestion];
    [self.collectionView deleteSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.collectionView.numberOfSections)]];
    [self.collectionView setContentOffset:CGPointZero animated:YES];
    [self.buttonsContainer fadeIn];
}

- (IBAction)btnOptionAPressed:(UIButton *)sender {
    [self showCandidatePositionsAndStoreUserResponseForPositionType:IssuePositionTypeFor];
}

- (IBAction)btnOptionBPressed:(UIButton *)sender {
    [self showCandidatePositionsAndStoreUserResponseForPositionType:IssuePositionTypeAgainst];
}

- (IBAction)btnNextQuestionPressed:(UIButton *)sender {
    // Show the next question or tell our delegate we're done
    NSUInteger nextIndex = self.currentQuestionIndex+1;
    if (nextIndex < self.questions.count) {
        self.currentQuestionIndex = nextIndex;
        [self transitionFromResultsToNewCurrentQuestion];
    } else {
        [self.delegate questionsViewController:self didFinishWithQuestions:self.questions userResponses:self.userResponses];
    }
}

#pragma mark - Custom methods

- (void)transitionFromResultsToNewCurrentQuestion {
    
    // Update flag
    _isShowingCandidatePositions = NO;
    
    // Update the UI
    [self updateUIForCurrentQuestion];
    
    // Show voting UI
    [self.buttonsContainer fadeIn];
    
    // Update header dimensions and reload collection view
    [self.header layoutIfNeeded];
    self.layout.parallaxHeaderReferenceSize = [self optimalSizeForHeader];
    self.layout.parallaxHeaderMinimumReferenceSize = self.layout.parallaxHeaderReferenceSize;
    [self.collectionView reloadData];
    
    // Bounce up
    [UIView animateWithSoftPhysicsDuration:0.6 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.collectionView setContentOffset:CGPointZero animated:YES];
    } completion:NULL];
}

- (void)updateUIForCurrentQuestion {
    
    // Get current question
    Question *question = self.questions[self.currentQuestionIndex];
    
    // Update header
    [self.header updateForQuestion:question totalQuestionCount:self.questions.count currentIndex:self.currentQuestionIndex];
    
    // Update option buttons
    [self.btnOptionA setTitle:[question.responseAText uppercaseString] forState:UIControlStateNormal];
    [self.btnOptionB setTitle:[question.responseBText uppercaseString] forState:UIControlStateNormal];
}

- (CGSize)optimalSizeForHeader {
    if (self.header) {
        CGSize size = [self.header sizeThatFits:CGSizeMake(self.view.bounds.size.width, CGFLOAT_MAX)];
        return size;
    }
    return CGSizeMake(self.view.bounds.size.width, 240.0);
}

- (void)showCandidatePositionsAndStoreUserResponseForPositionType:(IssuePositionType)type {
    
    // Get current question
    Question *question = self.questions[self.currentQuestionIndex];
    
    // Show candidates positions
    // We want to show first the candidate who the person matches the most in this issue
    NSArray<CandidateStand*> *stands = [self sortedCandidateStandsForQuestion:question userPositionType:type];
    [self.currentQuestionCandidateStands setArray:stands];
    
    // Store response
    self.userResponses[question.uid] = [UserResponse userResponseWithPositionType:type questionID:question.uid candidateStands:stands];
    
    // Set the flag and show positions
    _isShowingCandidatePositions = YES;
    [self.collectionView performBatchUpdates:^{
        [self.collectionView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];
    } completion:NULL];
    
    // Hide voting UI
    [self.buttonsContainer fadeOut];
    
    // Show the matching legend
    [self.header showLegend];
    
    // Scroll down
    [self.collectionView setContentOffset:CGPointMake(0.0, self.header.bounds.size.height - 88.0) animated:YES];
}

- (nonnull NSArray<CandidateStand*> *)sortedCandidateStandsForQuestion:(Question *)question userPositionType:(IssuePositionType)userPositionType {
    
    // Get the stands
    CandidateStand *bernieStand = [CandidateStand candidateStandForCandidate:CandidateBernie currentPosition:question.bernieCurrentPosition recordPosition:question.bernieRecordPosition];
    CandidateStand *hillaryStand = [CandidateStand candidateStandForCandidate:CandidateHillary currentPosition:question.hillaryCurrentPosition recordPosition:question.hillaryRecordPosition];
    
    // If the user voted neutral (aka NOT SURE), we don't need to sort anything
    if (userPositionType == IssuePositionTypeNeutral) {
        return @[bernieStand, hillaryStand];
    }
    
    // If the user voted for or against, we sort based on better match
    // A neutral position of the candidate will also give them positive score iff they were not against the user's position
    CGFloat bernieScore = 0.0;
    if (bernieStand.recordPosition.type == IssuePositionTypeNeutral || bernieStand.currentPosition.type == IssuePositionTypeNeutral) {
        if (bernieStand.recordPosition.type == userPositionType || bernieStand.currentPosition.type == userPositionType) {
            // This means one of them was neutral and they agreed in the other one, so they get full score
            bernieScore += 1.0;
        }
    } else {
        // Normal match calculation
        if (bernieStand.currentPosition.type == userPositionType) {
            bernieScore += 0.5;
        }
        if (bernieStand.recordPosition.type == userPositionType) {
            bernieScore += 0.5;
        }
    }
    bernieStand.matchScore = bernieScore;
    
    CGFloat hillaryScore = 0.0;
    if (hillaryStand.recordPosition.type == IssuePositionTypeNeutral || hillaryStand.currentPosition.type == IssuePositionTypeNeutral) {
        if (hillaryStand.recordPosition.type == userPositionType || hillaryStand.currentPosition.type == userPositionType) {
            // This means one of them was neutral and they agreed in the other one, so they get half score
            hillaryScore += 1.0;
        }
    } else {
        // Normal match calculation
        if (hillaryStand.currentPosition.type == userPositionType) {
            hillaryScore += 0.5;
        }
        if (hillaryStand.recordPosition.type == userPositionType) {
            hillaryScore += 0.5;
        }
    }
    hillaryStand.matchScore = hillaryScore;
    
    if (bernieScore >= hillaryScore) {
        return @[bernieStand, hillaryStand];
    } else {
        return @[hillaryStand, bernieStand];
    }
}

#pragma mark - Collection view methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    // Candidates + 1 for the Next Question button
    NSUInteger count = self.currentQuestionCandidateStands.count + 1;
    return _isShowingCandidatePositions ? count : 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (!_isShowingCandidatePositions) {
        return 0;
    }
    
    // Show candidate positions, 2 rows per section (record and current)
    if (section < self.currentQuestionCandidateStands.count) {
        return 3;
    } else {
        // Return 1 for the Next Question section
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Last section is for the Next Question button, other sections are for the candidates, sorted by best match
    if (indexPath.section < self.currentQuestionCandidateStands.count) {
        
        CandidateStand *stand = self.currentQuestionCandidateStands[indexPath.section];
        if (indexPath.item == 0) {
            CandidateCell *sectionHeader = [collectionView dequeueReusableCellWithReuseIdentifier:CandidateCellIdentifier forIndexPath:indexPath];
            if (stand.candidate == CandidateBernie) {
                [sectionHeader updateWithImage:[UIImage imageNamed:@"bernie-circle"] name:@"Bernie"];
            } else {
                [sectionHeader updateWithImage:[UIImage imageNamed:@"hillary-circle"] name:@"Hillary"];
            }
            return sectionHeader;
            
        } else {
            IssuePositionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IssuePositionCellIdentifier forIndexPath:indexPath];
            BOOL isCurrent = indexPath.item == 2;
            Question *question = self.questions[self.currentQuestionIndex];
            UserResponse *userResponse = self.userResponses[question.uid];
            [cell updateForCandidateIssuePosition:isCurrent?stand.currentPosition:stand.recordPosition isCurrent:isCurrent userPositionType:userResponse.userPositionType];
            return cell;
        }
    
    } else {
        if (self.nextQuestionCell == nil) {
            self.nextQuestionCell = [collectionView dequeueReusableCellWithReuseIdentifier:NextQuestionCellIdentifier forIndexPath:indexPath];
            [self.nextQuestionCell.btnNextQuestion addTarget:self action:@selector(btnNextQuestionPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        // Update button title
        if (self.currentQuestionIndex == self.questions.count - 1) {
            NSString *showResultsTitleString = NSLocalizedString(@"questionsController.button.showResults", @"Title for the Show Results button");
            [self.nextQuestionCell.btnNextQuestion setTitle:showResultsTitleString forState:UIControlStateNormal];
        } else {
            NSString *nextQuestionTitleString = NSLocalizedString(@"questionsController.button.nextQuestion", @"Title for Next Question button");
            [self.nextQuestionCell.btnNextQuestion setTitle:nextQuestionTitleString forState:UIControlStateNormal];
        }
        return self.nextQuestionCell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
        if (self.header == nil) {
            self.header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
            [self.header.btnNotSure addTarget:self action:@selector(btnNotSurePressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.header.btnChangeAnswer addTarget:self action:@selector(btnChangeAnswerPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self updateUIForCurrentQuestion];
        }
        return self.header;
        
    } else {
        UICollectionReusableView *fakeHader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:FakeHeaderIdentifier forIndexPath:indexPath];
        fakeHader.backgroundColor = [UIColor clearColor];
        return fakeHader;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

@end
