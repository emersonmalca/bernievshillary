//
//  NSMutableAttributedString+Utilities.m
//  bernievshillary
//
//  Created by emersonmalca on 5/22/16.
//
//

#import "NSMutableAttributedString+Utilities.h"

@implementation NSString (NSMutableAttributedStringHelpers)

- (BOOL)_hasSuffixCharacterFromSet:(NSCharacterSet *)characterSet
{
    if (![self length])
    {
        return NO;
    }
    
    unichar lastChar = [self characterAtIndex:[self length]-1];
    
    return [characterSet characterIsMember:lastChar];
}

@end

@implementation NSMutableAttributedString (Utilities)

-(void)setTextColor:(UIColor*)color
{
    [self setTextColor:color range:[self fullRange]];
}

-(void)setTextColor:(UIColor*)color range:(NSRange)range
{
    // kCTForegroundColorAttributeName
    [self removeAttribute:NSForegroundColorAttributeName range:range]; // Work around for Apple leak
    [self addAttribute:NSForegroundColorAttributeName value:(__bridge id)color.CGColor range:range];
}

- (void)setString:(NSString *)string {
    [self replaceCharactersInRange:NSMakeRange(0, [self length]) withString:string];
}

- (void)setFont:(UIFont *)font {
    [self setFont:font range:[self fullRange]];
}

- (void)setFont:(UIFont *)font range:(NSRange)range {
    [self addAttribute:NSFontAttributeName value:font range:range];
}

- (NSRange)fullRange {
    return NSMakeRange(0,[self length]);
}

- (void)removeTrailingWhitespacesAndNewLineCharacters {
    while ([[self string] _hasSuffixCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]) {
        [self deleteCharactersInRange:NSMakeRange([self length]-1, 1)];
    }
}

@end
