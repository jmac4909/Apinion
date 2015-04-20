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

    self.dotsImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.detailTextLabel.frame.origin.x, self.frame.size.height/2, 30, 30)];
    [self.dotsImage setImage:[UIImage imageNamed:@"threeDots"]];
    self.dotsImage.contentMode = UIViewContentModeScaleToFill;
    self.dotsImage.alpha = 0.25;
    
    [self.contentView addSubview:self.dotsImage];
    self.dotsImage.hidden = YES;

     self.displayNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width * 0.746667 + 15, self.frame.size.height - 5, self.contentView.frame.size.width - (self.contentView.frame.size.width * 0.746667), 10)];
    [self.displayNameLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:self.displayNameLabel.font.pointSize]];
    [self.contentView addSubview:self.displayNameLabel];

}
- (void) layoutSubviews {
    [super layoutSubviews];
    [self.textLabel removeFromSuperview];
    [self.displayNameLabel setFrame:CGRectMake((self.contentView.frame.size.width * 0.746667) + 15, self.contentView.frame.size.height - 20, (self.contentView.frame.size.width - (self.contentView.frame.size.width * 0.746667)) - 15, 20)];
    self.displayNameLabel.adjustsFontSizeToFitWidth = YES;

    


    [self.detailTextLabel setFrame:CGRectMake(self.frame.size.width - 63, 0,44, 20)];
    self.detailTextLabel.textAlignment = NSTextAlignmentRight;
    
    
    
        [self.dotsImage setFrame:CGRectMake(self.detailTextLabel.frame.origin.x + self.dotsImage.frame.size.width/2, self.frame.size.height/2 - self.detailTextLabel.frame.size.height/2, 30, 30)];

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
