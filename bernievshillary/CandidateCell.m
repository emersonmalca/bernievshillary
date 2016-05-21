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

@implementation CandidateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateWithImage:(UIImage *)image name:(NSString *)name {
    self.avatar.image = image;
    self.nameLabel.text = name;
}

@end
