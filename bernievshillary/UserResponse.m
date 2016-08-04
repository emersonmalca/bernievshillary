//
//  UserResponse.m
//  bernievshillary
//
//  Created by emersonmalca on 5/22/16.
//
//

#import "UserResponse.h"
#import "bernievshillary-Swift.h"

@class Question;
@class CandidateStand;

@interface UserResponse ()

@property (nonatomic, readwrite) IssuePositionType userPositionType;
@property (strong, nonatomic, readwrite) NSString *questionID;
@property (strong, nonatomic, readwrite) NSArray<CandidateStand*> *candidateStands;

@end

@implementation UserResponse

+ (UserResponse *)userResponseWithPositionType:(IssuePositionType)userPositionType questionID:(NSString *)questionID candidateStands:(NSArray<CandidateStand*> *)candidateStands {
    UserResponse *response = [[UserResponse alloc] initWithPositionType:userPositionType questionID:questionID candidateStands:candidateStands];
    return response;
}

- (id)initWithPositionType:(IssuePositionType)userPositionType questionID:(NSString *)questionID candidateStands:(NSArray<CandidateStand*> *)candidateStands {
    self = [super init];
    if (self) {
        self.userPositionType = userPositionType;
        self.questionID = questionID;
        self.candidateStands = [NSArray arrayWithArray:candidateStands];
    }
    return self;
}

@end
