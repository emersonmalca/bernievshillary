//
//  IssuePositionCell.m
//  bernievshillary
//
//  Created by emersonmalca on 5/21/16.
//
//

#import "IssuePositionCell.h"
#import "BHKit.h"

@interface IssuePositionCell ()

@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextView *textView;

@end

@implementation IssuePositionCell

- (void)updateForCandidateIssuePosition:(IssuePosition *)candidatePosition isCurrent:(BOOL)isCurrent userPositionType:(IssuePositionType)userPositionType {
    
    // Update title
    self.titleLabel.text = isCurrent?@"CURRENT POSITION":@"PAST RECORD";
    
    // Update text
    self.textView.text = candidatePosition.text;
    
    // We need to calculate how we want to display the issue based on the user position
    IssuePositionType visualPositionType = IssuePositionTypeNeutral;
    if (userPositionType != IssuePositionTypeNeutral) {
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
