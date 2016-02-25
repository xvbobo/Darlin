//
//  RightChatViewCell.m
//  Yongai
//
//  Created by wangfang on 14/11/13.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "RightChatViewCell.h"
#import "CommonHelper.h"
#import "Masonry.h"
#import "TTIFont.h"

#define BUBBLE_RIGHT_LEFT_CAP_WIDTH 35 // 文字在右侧时,bubble用于拉伸点的X坐标
#define BUBBLE_RIGHT_TOP_CAP_HEIGHT 30 // 文字在右侧时,bubble用于拉伸点的Y坐标

@implementation RightChatViewCell
{
    int top;
}

- (void)awakeFromNib {
    // Initialization code
    self.contentView.backgroundColor = BJCLOLR;
    self.headImg.layer.masksToBounds = YES;
    self.headImg.layer.cornerRadius = self.headImgW.constant/2;
    self.msgLable.textColor = BLACKTEXT;
    self.timeButton.backgroundColor = LINE;;
    self.timeButton.layer.masksToBounds = YES;
    self.timeButton.layer.cornerRadius = 5;
    self.timeButton.titleLabel.font = [UIFont systemFontOfSize:14];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithMessage:(MessageContentModel *)message {

    // 判断是否显示时间
    int top1;
//    int bottom;
    if (![message.mesc_display isEqualToString:@"1"]) {
        self.timeButton.hidden = YES;
        top1 = 22;
//        bottom = 22;
    }
    else
    {
        top1 = 44;
//        bottom = 0;
        self.timeButton.hidden = NO;
        [self.timeButton setTitle:[CommonHelper formatterWithTime:message.mesc_time andWithType:@"MM月dd日 HH:mm"] forState:UIControlStateNormal];
    }
    
    [self.headImg setImageWithURL:[NSURL URLWithString:message.user_photo] placeholderImage:[UIImage imageNamed:Default_UserHead]];
   
    if (_backImg == nil) {
        
        self.backImg = [[UIImageView alloc] init];
        self.backImg.image = [[UIImage imageNamed:@"ChatViewCell_right1"] stretchableImageWithLeftCapWidth:BUBBLE_RIGHT_LEFT_CAP_WIDTH topCapHeight:BUBBLE_RIGHT_TOP_CAP_HEIGHT];
        [self.contentView addSubview:self.backImg];
    }
    CGFloat withLength = [TTIFont calWidthWithText:message.mesc_content font:[UIFont systemFontOfSize:18] limitWidth:UIScreenWidth - 55 - 56];
     CGFloat contentWith = UIScreenWidth - 55 - 56;
    self.headImageTop.constant = top1;
    if (withLength > contentWith) {
        [self.backImg mas_updateConstraints:^(MASConstraintMaker *make) {
            //改变聊天框的大小
            make.left.equalTo(self.contentView.mas_left).offset(55);
            make.right.equalTo(self.contentView.mas_right).offset(-56);
            make.top.equalTo(self.contentView.mas_top).offset(top1);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
        }];
    }
    else
    {
        CGFloat with = UIScreenWidth - withLength - 55 - 56;
        [self.backImg mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.mas_left).offset(with + 20);
            make.top.equalTo(self.contentView.mas_top).offset(top1);
            make.right.equalTo(self.contentView.mas_right).offset(-56);
            make.height.equalTo(@36);
        }];
    }
    
    if (_msgLable == nil) {
        
        self.msgLable = [[UILabel alloc] init];
        self.msgLable.backgroundColor = [UIColor clearColor];
        self.msgLable.font = [UIFont systemFontOfSize:17];
        self.msgLable.numberOfLines = 0;
        self.msgLable.textAlignment = NSTextAlignmentJustified;
        [self.backImg addSubview:self.msgLable];
    }
    self.msgLable.text = message.mesc_content;
    if (withLength > contentWith) {
        [self.msgLable mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.backImg.mas_left).offset(10);
            //改变聊天框的大小
            make.right.equalTo(self.contentView.mas_right).offset(-65);
            make.top.equalTo(self.backImg.mas_top).offset(1);
            make.bottom.equalTo(self.backImg.mas_bottom).offset(-1);
        }];
    }else{
        [self.msgLable mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.backImg.mas_left).offset(10);
            //改变聊天框的大小
            make.right.equalTo(self.contentView.mas_right).offset(-70);
            make.top.equalTo(self.backImg.mas_top).offset(0);
            make.bottom.equalTo(self.backImg.mas_bottom).offset(0);
        }];
    }
}

@end
