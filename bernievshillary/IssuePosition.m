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
@property (strong, nonatomic, readwrite, nullable) NSString *text;

@end

@implementation IssuePosition

+ (nonnull IssuePosition *)issuePositionWithType:(IssuePositionType)type {
    return [self issuePositionWithType:type text:nil];
}

+ (nonnull IssuePosition *)issuePositionWithType:(IssuePositionType)type text:(nullable NSString *)text {
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
