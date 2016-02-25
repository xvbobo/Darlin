//
//  LeftChatViewCell.m
//  Yongai
//
//  Created by wangfang on 14/11/13.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "LeftChatViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "CommonHelper.h"
#import "Masonry.h"
#import "TTIFont.h"

#define BUBBLE_LEFT_LEFT_CAP_WIDTH 35 // 文字在左侧时,bubble用于拉伸点的X坐标
#define BUBBLE_LEFT_TOP_CAP_HEIGHT 30 // 文字在左侧时,bubble用于拉伸点的Y坐标

@implementation LeftChatViewCell

- (void)awakeFromNib {
    // Initialization code
    self.contentView.backgroundColor = BJCLOLR;
    self.headImg.layer.masksToBounds = YES;
    self.headImg.layer.cornerRadius = self.headImageW.constant/2;
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

    int top1;
    if (![message.mesc_display isEqualToString:@"1"]) {
        self.timeButton.hidden = YES;
        top1 = 22;
    }
    else
    {
        top1 = 44;
        self.timeButton.hidden = NO;
        [self.timeButton setTitle:[CommonHelper formatterWithTime:message.mesc_time andWithType:@"MM月dd日 HH:mm"] forState:UIControlStateNormal];
    }
    
    [self.headImg setImageWithURL:[NSURL URLWithString:message.user_photo] placeholderImage:[UIImage imageNamed:Default_UserHead]];
    
    self.headImageTop.constant = top1;
    if (_backImg == nil) {
        
        self.backImg = [[UIImageView alloc] init];
        self.backImg.image = [[UIImage imageNamed:@"ChatViewCell_left1"] stretchableImageWithLeftCapWidth:BUBBLE_LEFT_LEFT_CAP_WIDTH topCapHeight:BUBBLE_LEFT_TOP_CAP_HEIGHT];
        [self.contentView addSubview:self.backImg];
    }
    
    CGFloat withLength = [TTIFont calWidthWithText:message.mesc_content font:[UIFont systemFontOfSize:18] limitWidth:UIScreenWidth - 56 - 55];
    CGFloat contentWith = UIScreenWidth - 55 - 56;

    if (withLength > contentWith) {

        [self.backImg mas_updateConstraints:^(MASConstraintMaker *make) {

            make.left.equalTo(self.contentView.mas_left).offset(50);
            //改变聊天框的大小
            make.right.equalTo(self.contentView.mas_right).offset(-55);
            make.top.equalTo(self.contentView.mas_top).offset(top1);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
        }];
    }
    else
    {
        [self.backImg mas_updateConstraints:^(MASConstraintMaker *make) {
             CGFloat with = UIScreenWidth - withLength - 55 -56;
            make.left.equalTo(self.contentView.mas_left).offset(50);
            make.top.equalTo(self.contentView.mas_top).offset(top1);
            make.right.equalTo(self.contentView.mas_right).offset(-with-30);
            make.height.equalTo(@36);
        }];
    }
    
    if (_msgLable == nil) {
        self.msgLable = [[UILabel alloc] init];
        self.msgLable.backgroundColor = [UIColor clearColor];
        self.msgLable.font = [UIFont systemFontOfSize:17];
        self.msgLable.textAlignment = NSTextAlignmentLeft;
        self.msgLable.numberOfLines = 0;
        [self.contentView addSubview:self.msgLable];
    }
    self.msgLable.text = message.mesc_content;
    if (withLength > contentWith) {
        [self.msgLable mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.backImg.mas_left).offset(15);
            //改变聊天框的大小
            make.right.equalTo(self.backImg.mas_right).offset(-5);
            make.top.equalTo(self.backImg.mas_top).offset(0);
            make.bottom.equalTo(self.backImg.mas_bottom).offset(0);
        }];
    }else
    {
        [self.msgLable mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.backImg.mas_left).offset(10);
            //改变聊天框的大小
            make.right.equalTo(self.backImg.mas_right).offset(0);
            make.top.equalTo(self.backImg.mas_top).offset(0);
            make.bottom.equalTo(self.backImg.mas_bottom).offset(0);
        }];
    }
    
}

@end
