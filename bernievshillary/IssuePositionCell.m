//
//  IssuePositionCell.m
//  bernievshillary
//
//  Created by emersonmalca on 5/21/16.
//
//

#import "IssuePositionCell.h"
#import "BHKit.h"
#import <DTCoreText/NSAttributedString+HTML.h>
#import <DTCoreText/DTCoreTextConstants.h>

@interface IssuePositionCell ()

@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextView *textView;

@end

@implementation IssuePositionCell {
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

- (void)updateForCandidateIssuePosition:(IssuePosition *)candidatePosition isCurrent:(BOOL)isCurrent userPositionType:(IssuePositionType)userPositionType {
    
    _isHeightCalculated = NO;
    
    // Update title
    NSString *currentPositionTitleString = NSLocalizedString(@"issuePositionCell.label.currentPosition", @"Title for a candidate's current position");
    NSString *pastRecordTItleString = NSLocalizedString(@"issuePositionCell.label.pastRecord", @"Title for a candidate's past record");
    self.titleLabel.text = isCurrent?currentPositionTitleString:pastRecordTItleString;
    
    // Update text, but keep text style
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithHTMLData:[candidatePosition.text dataUsingEncoding:NSUTF8StringEncoding] options:@{DTUseiOS6Attributes:@YES} documentAttributes:nil];
    [attr removeTrailingWhitespacesAndNewLineCharacters];
    [attr setFont:self.textView.font];
    self.textView.attributedText = attr;
    
    // We need to calculate how we want to display the issue based on the user position
    IssuePositionType visualPositionType = IssuePositionTypeNeutral;
    if (userPositionType != IssuePositionTypeNeutral && candidatePosition.type != IssuePositionTypeNeutral) {
        if (userPositionType == candidatePosition.type) {
            visualPositionType = IssuePositionTypeFor;
        } else {
            visualPositionType = IssuePositionTypeAgainst;
        }
    }
    
    // Update colors and icon based on visual position
    switch (visualPositionType) {
        case IssuePositionTypeFor: {
            self.icon.image = [UIImage imageNamed:@"icon-agree"];
            self.titleLabel.textColor = [UIColor mainGreen];
            break;
        }
        case IssuePositionTypeAgainst: {
            self.icon.image = [UIImage imageNamed:@"icon-disagree"];
            self.titleLabel.textColor = [UIColor mainRed];
            break;
        }
        case IssuePositionTypeNeutral: {
            self.icon.image = [UIImage imageNamed:@"icon-neutral"];
            self.titleLabel.textColor = [UIColor mediumLightGray];
            break;
        }
    }
    
}

@end
