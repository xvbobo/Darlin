//
//  UserInfoCell.m
//  Yongai
//
//  Created by myqu on 14/11/6.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "UserInfoCell.h"

@implementation UserInfoCell

- (void)awakeFromNib {
    // Initialization code
    _headImgView.layer.masksToBounds = YES;
    _headImgView.layer.cornerRadius = _headImgView.frame.size.width/2;
    _descpLabel.textColor = BLACKTEXT;
    _titleLabel.textColor = BLACKTEXT;
    _promptLabel.textColor = BLACKTEXT;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
