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

typedef NS_ENUM(NSUInteger, Candidate) {
    CandidateBernie,
    CandidateHillary,
};

@interface CandidateStand : NSObject

@property (nonatomic) Candidate candidate;
@property (nonatomic) CGFloat matchScore; //0.0 to 1.0
@property (strong, nonatomic) IssuePosition *currentPosition;
@property (strong, nonatomic) IssuePosition *recordPosition;

+ (CandidateStand *)candidateStandForCandidate:(Candidate)candidate currentPosition:(IssuePosition *)currentPosition recordPosition:(IssuePosition *)recordPosition;

@end

@implementation CandidateStand

+ (CandidateStand *)candidateStandForCandidate:(Candidate)candidate currentPosition:(IssuePosition *)currentPosition recordPosition:(IssuePosition *)recordPosition {
    CandidateStand *stand = [[CandidateStand alloc] init];
    stand.candidate = candidate;
    stand.currentPosition = currentPosition;
    stand.recordPosition = recordPosition;
    return stand;
}

@end


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
@property (strong, nonatomic) NSMutableDictionary<NSString*, IssuePosition*> *userResponses;
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
        if (self.questions.count < 10) {
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
    self.layout.estimatedItemSize = CGSizeMake(300.0, 80.0);
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

#pragma mark - Action methods

- (IBAction)btnNotSurePressed:(UIButton *)sender {
    [self showCandidatePositionsAndStoreUserResponseForPositionType:IssuePositionTypeNeutral];
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
    
    // Move up
    [self.collectionView setContentOffset:CGPointZero animated:YES];
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
    
    // Store response
    self.userResponses[question.uid] = [IssuePosition issuePositionWithType:type];
    
    // Show candidates positions
    // We want to show first the candidate who the person matches the most in this issue
    NSArray<CandidateStand*> *stands = [self sortedCandidateStandsForQuestion:question userPositionType:type];
    [self.currentQuestionCandidateStands setArray:stands];
    
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

- (nonnull NSArray<CandidateStand*> *)sortedCandidateStandsForQuestion:(Question *)question userPositionType:(IssuePositionType)type {
    
    // Get the stands
    CandidateStand *bernieStand = [CandidateStand candidateStandForCandidate:CandidateBernie currentPosition:question.bernieCurrentPosition recordPosition:question.bernieRecordPosition];
    CandidateStand *hillaryStand = [CandidateStand candidateStandForCandidate:CandidateHillary currentPosition:question.hillaryCurrentPosition recordPosition:question.hillaryRecordPosition];
    
    // If the user voted neutral (aka NOT SURE), we don't need to sort anything
    if (type == IssuePositionTypeNeutral) {
        return @[bernieStand, hillaryStand];
    }
    
    // If the user voted for or against, we sort based on better match
    // A neutral position of the candidate will also give them positive score since they were not against the user's position
    CGFloat bernieScore = 0.0;
    if (bernieStand.currentPosition.type == type || bernieStand.currentPosition.type == IssuePositionTypeNeutral) {
        bernieScore += 0.5;
    }
    if (bernieStand.recordPosition.type == type || bernieStand.recordPosition.type == IssuePositionTypeNeutral) {
        bernieScore += 0.5;
    }
    bernieStand.matchScore = bernieScore;
    
    CGFloat hillaryScore = 0.0;
    if (hillaryStand.currentPosition.type == type || hillaryStand.currentPosition.type == IssuePositionTypeNeutral) {
        hillaryScore += 0.5;
    }
    if (hillaryStand.recordPosition.type == type || hillaryStand.recordPosition.type == IssuePositionTypeNeutral) {
        hillaryScore += 0.5;
    }
    hillaryStand.matchScore = hillaryScore;
    
    if (bernieScore >= hillaryScore) {
        return  @[bernieStand, hillaryStand];
    } else {
        return @[hillaryStand, bernieStand];
    }
}

#pragma mark - Collection view methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    // Candidates + 1 for the Next Question button
    return _isShowingCandidatePositions?self.currentQuestionCandidateStands.count + 1 : 0;
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
            IssuePosition *userPosition = self.userResponses[question.uid];
            [cell updateForCandidateIssuePosition:isCurrent?stand.currentPosition:stand.recordPosition isCurrent:isCurrent userPositionType:userPosition.type];
            return cell;
        }
    
    } else {
        if (self.nextQuestionCell == nil) {
            self.nextQuestionCell = [collectionView dequeueReusableCellWithReuseIdentifier:NextQuestionCellIdentifier forIndexPath:indexPath];
            [self.nextQuestionCell.btnNextQuestion addTarget:self action:@selector(btnNextQuestionPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        // Update button title
        if (self.currentQuestionIndex == self.questions.count - 1) {
            [self.nextQuestionCell.btnNextQuestion setTitle:@"SHOW RESULTS" forState:UIControlStateNormal];
        } else {
            [self.nextQuestionCell.btnNextQuestion setTitle:@"NEXT QUESTION" forState:UIControlStateNormal];
        }
        return self.nextQuestionCell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
        if (self.header == nil) {
            self.header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
            [self.header.btnNotSure addTarget:self action:@selector(btnNotSurePressed:) forControlEvents:UIControlEventTouchUpInside];
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
