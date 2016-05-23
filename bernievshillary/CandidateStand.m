//
//  CandidateStand.m
//  bernievshillary
//
//  Created by emersonmalca on 5/22/16.
//
//

#import "CandidateStand.h"
#import "UIColor+BernieVSHillary.h"

@implementation CandidateStand

+ (CandidateStand *)candidateStandForCandidate:(Candidate)candidate currentPosition:(IssuePosition *)currentPosition recordPosition:(IssuePosition *)recordPosition {
    CandidateStand *stand = [[CandidateStand alloc] init];
    stand.candidate = candidate;
    stand.currentPosition = currentPosition;
    stand.recordPosition = recordPosition;
    return stand;
}

+ (NSString *)fullNameForCandidate:(Candidate)candidate {
    switch (candidate) {
        case CandidateBernie: {
            return @"Bernie Sanders";
            break;
        }
        case CandidateHillary: {
            return @"Hillary Clinton";
            break;
        }
    }
}

+ (UIImage *)fullSizeImageForCandidate:(Candidate)candidate {
    switch (candidate) {
        case CandidateBernie: {
            return [UIImage imageNamed:@"bernie-big"];
            break;
        }
        case CandidateHillary: {
            return [UIImage imageNamed:@"hillary-big"];
            break;
        }
    }
}

+ (UIColor *)colorForCandidate:(Candidate)candidate {
    switch (candidate) {
        case CandidateBernie: {
            return [UIColor bernieColor];
            break;
        }
        case CandidateHillary: {
            return [UIColor hillaryColor];
            break;
        }
    }
}

@end