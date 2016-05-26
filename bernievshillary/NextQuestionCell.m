//
//  NextQuestionCell.m
//  bernievshillary
//
//  Created by emersonmalca on 5/22/16.
//
//

#import "NextQuestionCell.h"

@interface NextQuestionCell ()

@property (strong, nonatomic, readwrite) IBOutlet UIButton *btnNextQuestion;

@end

@implementation NextQuestionCell {
    BOOL _isHeightCalculated;
    CGSize _cachedSize;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.alpha = 0.0;
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    if (!_isHeightCalculated) {
        [self setNeedsLayout];
        [self layoutIfNeeded];
        CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
        _cachedSize = size;
        CGRect newFrame = layoutAttributes.frame;
        newFrame.size.width = ceilf(size.width);
        newFrame.size.height = ceilf(size.height);
        layoutAttributes.frame = newFrame;
        _isHeightCalculated = YES;
    }
    layoutAttributes.size = _cachedSize;
    return layoutAttributes;
}

@end
