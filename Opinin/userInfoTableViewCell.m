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
//    [self.detailTextLabel setFrame:CGRectMake(self.frame.size.width - 63, 0,44, 20)];

    self.dotsImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.detailTextLabel.frame.origin.x, self.frame.size.height/2 + 15, 30, 30)];
    [self.dotsImage setImage:[UIImage imageNamed:@"threeDots"]];
    self.dotsImage.contentMode = UIViewContentModeScaleToFill;
    self.dotsImage.alpha = 0.25;
    
    [self.contentView addSubview:self.dotsImage];
    self.dotsImage.hidden = YES;


}
- (void) layoutSubviews {
    [super layoutSubviews];
    [self.textLabel removeFromSuperview];
    
    [self.dotsImage setFrame:CGRectMake(self.detailTextLabel.frame.origin.x, self.frame.size.height/2 + 15, 30, 30)];

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
