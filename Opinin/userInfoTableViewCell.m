//
//  userInfoTableViewCell.m
//  Apinion
//
//  Created by Jeremy Mackey on 2/9/15.
//  Copyright (c) 2015 Jeremy Mackey. All rights reserved.
//

#import "userInfoTableViewCell.h"

@implementation userInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code


}
- (void) layoutSubviews {
    [super layoutSubviews];
    [self.textLabel removeFromSuperview];
    
    [self.detailTextLabel setFrame:CGRectMake(self.frame.size.width - 63, 0,44, 20)];


//    //was 280 for width
//    self.textLabel.frame = CGRectMake(15, 0, self.contentView.frame.size.width * 0.746667, self.contentView.frame.size.height);
//    self.detailTextLabel.frame = CGRectMake(self.contentView.frame.size.width - 63, 35, 42, 20);
//    NSLog(@"%f",self.textLabel.frame.size.width/self.contentView.frame.size.width);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
