//
//  MyMessageViewCell.m
//  Yongai
//
//  Created by wangfang on 14/11/13.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MyMessageViewCell.h"

@implementation MyMessageViewCell
{
    UIImageView * huangGuan ;
}

- (void)awakeFromNib {
    // Initialization code
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    if (huangGuan == nil) {
        huangGuan = [[UIImageView alloc ] init];
        [self.contentView addSubview:huangGuan];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMessageInfo:(MessageModel *)messageInfo
{
    _messageInfo = messageInfo;
    _headImgView.layer.masksToBounds = YES;
    _headImgView.layer.cornerRadius = _headImgView.frame.size.width/2;
    [_headImgView setImageWithURL:[NSURL URLWithString:_messageInfo.user_photo] placeholderImage:[UIImage imageNamed:Default_UserHead]];
    
    if([_messageInfo.mesu_unread isEqualToString:@"0"])
    {
        _hasNewMsgBtn.hidden = YES;
    }
    else
    {
        _hasNewMsgBtn.hidden = NO;
    }
    
    _nameLabel.text = _messageInfo.nickname;
    CGSize size = [_nameLabel.text sizeWithFont:[UIFont systemFontOfSize:16]];
    huangGuan.frame = CGRectMake(self.nameLabel.frame.origin.x+self.sexImgView.frame.size.width+size.width+9, self.sexImgView.frame.origin.y+0.35, self.sexImgView.frame.size.width, self.sexImgView.frame.size.height);
    _nameLabel.textColor = RGBACOLOR(108, 97, 85, 1);
    _contentLabel.text = _messageInfo.message_latest;
    if([_messageInfo.sex isEqualToString:@"1"])
    {
        _sexImgView.image = [UIImage imageNamed:@"post_detail_male"];
    }
    else
    {
        _sexImgView.image = [UIImage imageNamed:@"post_detail_female"];
    }
    if ([_messageInfo.user_rank isEqualToString:@"2"]) {
        huangGuan.backgroundColor = [UIColor clearColor];
    }else{
        huangGuan.backgroundColor = [UIColor clearColor];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"MM月dd日";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_messageInfo.message_time.intValue];
    _timeLabel.text = [formatter stringFromDate:date];
}

@end
