//
//  ConfirmGoodsCell.m
//  Yongai
//
//  Created by myqu on 14/11/13.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "ConfirmGoodsCell.h"

@implementation ConfirmGoodsCell

- (void)awakeFromNib {
    // Initialization code
//    self.contentView.backgroundColor = BJCLOLR;
    self.view1.backgroundColor = BJCLOLR;
    self.view2.backgroundColor = BJCLOLR;
    self.goodsNameLabel.textColor = BLACKTEXT;
    self.goodsDetialLabel.textColor = BLACKTEXT;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
