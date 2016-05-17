//
//  Question.h
//  bernievshillary
//
//  Created by emersonmalca on 5/16/16.
//
//

#import <Foundation/Foundation.h>
@class IssuePosition;

@interface Question : NSObject

@property (strong, nonatomic, nonnull) NSString *uid;
@property (strong, nonatomic, nonnull) NSString *text;
@property (strong, nonatomic, nonnull) NSString *responseAText;
@property (strong, nonatomic, nonnull) NSString *responseBText;
@property (nonatomic) NSUInteger sortOrder;

@property (strong, nonatomic, nonnull) IssuePosition *bernieCurrentPosition;
@property (strong, nonatomic, nonnull) IssuePosition *bernieRecordPosition;
@property (strong, nonatomic, nonnull) IssuePosition *hillaryCurrentPosition;
@property (strong, nonatomic, nonnull) IssuePosition *hillaryRecordPosition;

+ (nonnull Question *)questionWithDictionary:(nonnull NSDictionary *)dict;

@end
