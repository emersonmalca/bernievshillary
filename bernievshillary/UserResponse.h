//
//  UserResponse.h
//  bernievshillary
//
//  Created by emersonmalca on 5/22/16.
//
//

#import <Foundation/Foundation.h>
#import "IssuePosition.h"
@class CandidateStand;

@interface UserResponse : NSObject

+ (UserResponse *)userResponseWithPositionType:(IssuePositionType)userPositionType questionID:(NSString *)questionID candidateStands:(NSArray<CandidateStand*> *)candidateStands;

@end
