//
//  CandidateCell.m
//  bernievshillary
//
//  Created by emersonmalca on 5/20/16.
//
//

#import "CandidateCell.h"

@interface CandidateCell ()

@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation CandidateCell {
    BOOL _isHeightCalculated;
    CGSize _cachedSize;
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    if (!_isHeightCalculated) {
        [self setNeedsLayout];
        [self layoutIfNeeded];
        CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
        _cachedSize = size;
        CGRect newFrame = layoutAttributes.frame;
        newFrame.size.width = ceilf(size.width);
        layoutAttributes.frame = newFrame;
        _isHeightCalculated = YES;
    }
    layoutAttributes.size = _cachedSize;
    return layoutAttributes;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.alpha = 0.0;
}

- (void)updateWithImage:(UIImage *)image name:(NSString *)name {
    self.avatar.image = image;
    self.nameLabel.text = name;
}

@end
