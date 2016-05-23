//
//  CandidateStand.m
//  bernievshillary
//
//  Created by emersonmalca on 5/22/16.
//
//

#import "CandidateStand.h"

@implementation CandidateStand

+ (CandidateStand *)candidateStandForCandidate:(Candidate)candidate currentPosition:(IssuePosition *)currentPosition recordPosition:(IssuePosition *)recordPosition {
    CandidateStand *stand = [[CandidateStand alloc] init];
    stand.candidate = candidate;
    stand.currentPosition = currentPosition;
    stand.recordPosition = recordPosition;
    return stand;
}

@end