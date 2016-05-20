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

@interface QuestionsViewController ()

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet CSStickyHeaderFlowLayout *layout;
@property (strong, nonatomic) IBOutlet UIView *buttonsContainer;
@property (strong, nonatomic) QuestionReusableView *header;

@property (strong, nonatomic) NSMutableArray<Question*> *questions;
@property (nonatomic) NSUInteger currentQuestionIndex;

@end

@implementation QuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Prepare data
    self.questions = [NSMutableArray array];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"questions" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSArray<NSDictionary*> *rawQuestions = json[@"questions"];
    for (NSDictionary *dict in rawQuestions) {
        Question *question = [Question questionWithDictionary:dict];
        [self.questions addObject:question];
    }
    
    // Prepare UI
    self.buttonsContainer.alpha = 0.0;
    
    // Prepare collection view
    UINib *headerNib = [UINib nibWithNibName:@"QuestionReusableView" bundle:nil];
    [self.collectionView registerNib:headerNib forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader withReuseIdentifier:@"QuestionReusableView"];
    self.layout.parallaxHeaderAlwaysOnTop = YES;
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(320.0, 200.0);
    self.layout.parallaxHeaderReferenceSize = [self optimalSizeForHeader];
    self.collectionView.contentOffset = CGPointMake(0.0, self.view.bounds.size.height);
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.header layoutIfNeeded];
    self.layout.parallaxHeaderReferenceSize = [self optimalSizeForHeader];
}

- (void)runPostPresentationAnimationWithCompletion:(void(^)(BOOL finished))completion {
    
    [UIView animateWithSoftPhysicsDuration:0.6 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.collectionView.contentOffset = CGPointZero;
        
    } completion:^(BOOL finished){
       
        [UIView animateWithDuration:2.0 delay:1.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.buttonsContainer.alpha = 1.0;
        } completion:completion];
        
    }];
}

#pragma mark - Custom methods

- (void)updateUIForCurrentQuestion {
    Question *question = self.questions[self.currentQuestionIndex];
    self.header.questionLabel.text = [NSString stringWithFormat:@"%lu. %@", self.currentQuestionIndex+1, question.text];
}

- (CGSize)optimalSizeForHeader {
    if (self.header) {
        CGSize size = [self.header sizeThatFits:CGSizeMake(self.view.bounds.size.width, CGFLOAT_MAX)];
        return size;
    }
    return CGSizeMake(self.view.bounds.size.width, 240.0);
}

#pragma mark - Collection view methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *HeaderIdentifier = @"QuestionReusableView";
    
    if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
        if (self.header == nil) {
            self.header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
            [self updateUIForCurrentQuestion];
        }
        return self.header;
    }
    return nil;
}

@end
