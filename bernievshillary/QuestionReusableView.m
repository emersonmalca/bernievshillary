//
//  QuestionReusableView.m
//  bernievshillary
//
//  Created by emersonmalca on 5/19/16.
//
//

#import "QuestionReusableView.h"
#import "Question.h"
#import <FXPageControl/FXPageControl.h>

@interface QuestionReusableView ()

@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) IBOutlet FXPageControl *pageControl;
@property (strong, nonatomic, readwrite) IBOutlet UIButton *btnNotSure;
@property (strong, nonatomic) IBOutlet UIView *legendView;

@end

@implementation QuestionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize labelSize = [self.questionLabel sizeThatFits:CGSizeMake(self.questionLabel.bounds.size.width, CGFLOAT_MAX)];
    CGFloat labelTotalVerticalMargin = self.bounds.size.height - self.questionLabel.bounds.size.height;
    return CGSizeMake(self.bounds.size.width, labelSize.height + labelTotalVerticalMargin);
}

#pragma mark - Custom methods

- (void)updateForQuestion:(Question *)question totalQuestionCount:(NSUInteger)total currentIndex:(NSUInteger)currentIndex {
    
    // Update question text
    NSString *text = [NSString stringWithFormat:@"%lu. %@", currentIndex+1, question.text];
    self.questionLabel.text = text;
    
    // Update page control
    self.pageControl.numberOfPages = total;
    self.pageControl.currentPage = currentIndex;
    
    // Show not sure button
    self.btnNotSure.alpha = 1.0;
    
    // Hide legend
    self.legendView.alpha = 0.0;
}

- (void)showLegend {
    
    // Hide not sure button
    self.btnNotSure.alpha = 0.0;
    
    // Show legend
    self.legendView.alpha = 1.0;
}

@end
