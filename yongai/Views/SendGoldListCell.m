//
//  SendGoldListCell.m
//  yongai
//
//  Created by wangfang on 15/1/22.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import "SendGoldListCell.h"
#import "UIImageView+AFNetworking.h"

@implementation SendGoldListCell

- (void)awakeFromNib {
    // Initialization code
    self.img.layer.masksToBounds = YES;
    self.img.layer.cornerRadius = self.img.frame.size.width/2;
    self.titleLable.textColor = BLACKTEXT;
    self.goldNunLable.textColor = TEXT;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateCellWithDic:(NSDictionary *)dic {

    [self.img setImageWithURL:[NSURL URLWithString:dic[@"user_photo"]] placeholderImage:[UIImage imageNamed:Default_UserHead]];
    self.titleLable.text = dic[@"nickname"];
    self.goldNunLable.text = dic[@"fg_num"];
}

- (IBAction)headBtnAction:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(showOtherInfoWithRow:)])
        [self.delegate showOtherInfoWithRow:self.tag];
}

@end
