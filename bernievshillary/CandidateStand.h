//
//  CandidateStand.h
//  bernievshillary
//
//  Created by emersonmalca on 5/22/16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class IssuePosition;

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
+ (NSString *)fullNameForCandidate:(Candidate)candidate;
+ (UIImage *)fullSizeImageForCandidate:(Candidate)candidate;
+ (UIColor *)colorForCandidate:(Candidate)candidate;
+ (NSString *)hashtagForCandidate:(Candidate)candidate;

@end
