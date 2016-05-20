//
//  QuestionReusableView.m
//  bernievshillary
//
//  Created by emersonmalca on 5/19/16.
//
//

#import "QuestionReusableView.h"

@implementation QuestionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize labelSize = [self.questionLabel sizeThatFits:CGSizeMake(self.questionLabel.bounds.size.width, CGFLOAT_MAX)];
    CGFloat labelTotalVerticalMargin = self.bounds.size.height - self.questionLabel.bounds.size.height;
    return CGSizeMake(self.bounds.size.width, labelSize.height + labelTotalVerticalMargin);
}

@end
