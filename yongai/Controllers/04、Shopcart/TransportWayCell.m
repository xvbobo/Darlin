//
//  TransportWayCell.m
//  Yongai
//
//  Created by arron on 14/11/5.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "TransportWayCell.h"

@implementation TransportWayCell

- (void)awakeFromNib {
    // Initialization code
    self.titleLabel.textColor = BLACKTEXT;
    self.contentLabel.textColor = BLACKTEXT;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
