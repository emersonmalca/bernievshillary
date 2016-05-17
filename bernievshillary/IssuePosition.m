//
//  IssuePosition.m
//  bernievshillary
//
//  Created by emersonmalca on 5/16/16.
//
//

#import "IssuePosition.h"

@interface IssuePosition ()

@property (nonatomic, readwrite) IssuePositionType type;
@property (strong, nonatomic, readwrite, nonnull) NSString *text;

@end

@implementation IssuePosition

+ (nonnull IssuePosition *)issuePositionWithType:(IssuePositionType)type text:(nonnull NSString *)text {
    IssuePosition *issue = [[IssuePosition alloc] init];
    issue.type = type;
    issue.text = text;
    return issue;
}

+ (IssuePositionType)typeFromNumber:(NSNumber *)number {
    switch ([number intValue]) {
        case 1:
            return IssuePositionTypeFor;
            break;
        case 0:
            return IssuePositionTypeAgainst;
        default:
            return IssuePositionTypeNeutral;
            break;
    }
}

@end
