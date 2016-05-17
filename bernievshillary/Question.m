//
//  Question.m
//  bernievshillary
//
//  Created by emersonmalca on 5/16/16.
//
//

#import "Question.h"
#import "IssuePosition.h"

@implementation Question

+ (nonnull Question *)questionWithDictionary:(nonnull NSDictionary *)dict {
    Question *question = [[Question alloc] initWithDictionary:dict];
    return question;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [self init];
    if (self) {
        // Process question info
        self.uid = dict[@"_id"];
        self.text = dict[@"question"];
        self.responseAText = dict[@"responseALabel"];
        self.responseBText = dict[@"responseBLabel"];
        self.sortOrder = [dict[@"sortOrder"] unsignedIntegerValue];
        
        // Bernie position
        self.bernieRecordPosition = [IssuePosition issuePositionWithType:[IssuePosition typeFromNumber:dict[@"bernieSandersRecord"]] text:dict[@"bernieSandersRecordText"]];
        self.bernieCurrentPosition = [IssuePosition issuePositionWithType:[IssuePosition typeFromNumber:dict[@"bernieSandersPosition"]] text:dict[@"bernieSandersPositionText"]];
        
        // Hillary position
        self.hillaryRecordPosition = [IssuePosition issuePositionWithType:[IssuePosition typeFromNumber:dict[@"hillaryClintonRecord"]] text:dict[@"hillaryClintonRecordText"]];
        self.hillaryCurrentPosition = [IssuePosition issuePositionWithType:[IssuePosition typeFromNumber:dict[@"hillaryClintonPosition"]] text:dict[@"hillaryClintonPositionText"]];
    }
    return self;
}

@end
