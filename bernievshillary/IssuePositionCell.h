//
//  IssuePositionCell.h
//  bernievshillary
//
//  Created by emersonmalca on 5/21/16.
//
//

#import <UIKit/UIKit.h>
#import "IssuePosition.h"

@interface IssuePositionCell : UICollectionViewCell

- (void)updateForCandidateIssuePosition:(IssuePosition *)candidatePosition isCurrent:(BOOL)isCurrent userPositionType:(IssuePositionType)userPositionType;

@end
