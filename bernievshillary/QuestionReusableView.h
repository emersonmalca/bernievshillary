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

- (void)updateForQuestion:(Question *)question totalQuestionCount:(NSUInteger)total currentIndex:(NSUInteger)currentIndex;

@end
