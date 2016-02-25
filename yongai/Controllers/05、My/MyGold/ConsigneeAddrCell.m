//
//  ConsigneeAddrCell.m
//  Yongai
//
//  Created by myqu on 14/11/13.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "ConsigneeAddrCell.h"

@implementation ConsigneeAddrCell

- (void)awakeFromNib {
    // Initialization code
    self.shouHuoDiZhi.textColor = BLACKTEXT;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
