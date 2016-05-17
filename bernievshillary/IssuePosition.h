//
//  IssuePosition.h
//  bernievshillary
//
//  Created by emersonmalca on 5/16/16.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, IssuePositionType) {
    IssuePositionTypeFor,
    IssuePositionTypeAgainst,
    IssuePositionTypeNeutral
};

@interface IssuePosition : NSObject

@property (nonatomic, readonly) IssuePositionType type;
@property (strong, nonatomic, readonly, nonnull) NSString *text;

+ (nonnull IssuePosition *)issuePositionWithType:(IssuePositionType)type text:(nonnull NSString *)text;
+ (IssuePositionType)typeFromNumber:(nonnull NSNumber *)number;

@end
