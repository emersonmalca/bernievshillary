//
//  NSMutableAttributedString+Utilities.h
//  bernievshillary
//
//  Created by emersonmalca on 5/22/16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (Utilities)

- (void)setTextColor:(UIColor*)color;
- (void)setTextColor:(UIColor*)color range:(NSRange)range;
- (void)setString:(NSString *)string;
- (void)setFont:(UIFont *)font;
- (void)setFont:(UIFont *)font range:(NSRange)range;
- (NSRange)fullRange;
- (void)removeTrailingWhitespacesAndNewLineCharacters;

@end
