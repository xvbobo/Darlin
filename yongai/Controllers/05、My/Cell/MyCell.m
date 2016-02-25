//
//  MyCell.m
//  Yongai
//
//  Created by Kevin Su on 14-10-27.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MyCell.h"

@implementation MyCell

- (void)awakeFromNib {
    // Initialization code
     self.pointRemindImageView.hidden = YES;
    self.cellLine.backgroundColor = BJCLOLR;
    self.cellineH.constant = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   
}

@end
