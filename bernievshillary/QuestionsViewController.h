//
//  QuestionsViewController.h
//  bernievshillary
//
//  Created by emersonmalca on 5/19/16.
//
//

#import <UIKit/UIKit.h>
@class Question;
@class IssuePosition;
@protocol QuestionsViewControllerDelegate;

@interface QuestionsViewController : UIViewController

@property (weak, nonatomic) id<QuestionsViewControllerDelegate> delegate;

@end

@protocol QuestionsViewControllerDelegate <NSObject>

/*
    Called when user finished answering the questions.
    Returns the array of questions asked and a dictionary with the user reponses. The key in the user responses is the uid of the question.
    This is all the necessary data to then calculate affinity to a candidate
 */
- (void)questionsViewController:(QuestionsViewController *)controller didFinishWithQuestions:(NSArray<Question*> *)questions userResponses:(NSMutableDictionary<NSString*, IssuePosition*> *)userResponses;

@end
