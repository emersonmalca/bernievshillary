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

@property (nonatomic, readonly) IssuePositionType userPositionType;
@property (strong, nonatomic, readonly) NSString *questionID;
@property (strong, nonatomic, readonly) NSArray<CandidateStand*> *candidateStands;

+ (UserResponse *)userResponseWithPositionType:(IssuePositionType)userPositionType questionID:(NSString *)questionID candidateStands:(NSArray<CandidateStand*> *)candidateStands;

@end
