//
//  QuestionReusableView.h
//  bernievshillary
//
//  Created by emersonmalca on 5/19/16.
//
//

#import <UIKit/UIKit.h>
@class Question;

@interface QuestionReusableView : UICollectionReusableView

@property (strong, nonatomic, readonly) UIButton *btnNotSure;
@property (strong, nonatomic, readonly) UIButton *btnChangeAnswer;

- (void)updateForQuestion:(Question *)question totalQuestionCount:(NSUInteger)total currentIndex:(NSUInteger)currentIndex;
- (void)showLegend;

@end