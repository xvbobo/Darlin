//
//  FaPiaoHeadCell.m
//  com.threeti
//
//  Created by alan on 15/11/24.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "FaPiaoHeadCell.h"
#import "TTIFont.h"
@implementation FaPiaoHeadCell
{
    UILabel * messageLabel;
    UILabel * faPiaoHeader;
    UILabel * faPiaoMessage;
    UILabel * faPiaoContent;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createInterFace];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)createInterFace
{
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, UIScreenWidth - 20, 30)];
    messageLabel.text = @"发票信息：单位";
    messageLabel.textColor = BLACKTEXT;
    messageLabel.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:messageLabel];
    UIImageView * lineview = [[UIImageView alloc] initWithFrame:CGRectMake(10, messageLabel.frame.origin.y+messageLabel.frame.size.height+5, UIScreenWidth - 20, 0.5)];
    lineview.backgroundColor  = LINE;
    [self.contentView addSubview:lineview];
    faPiaoHeader = [[UILabel alloc] initWithFrame:CGRectMake(10, messageLabel.frame.size.height+messageLabel.frame.origin.y+15,80, 20)];
    faPiaoHeader.textColor = BLACKTEXT;
    faPiaoHeader.text  = @"发票抬头：";
    faPiaoHeader.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:faPiaoHeader];
    CGFloat X = faPiaoHeader.frame.origin.x+faPiaoHeader.frame.size.width+5;
    faPiaoMessage = [[UILabel alloc] initWithFrame:CGRectMake(X, messageLabel.frame.size.height+messageLabel.frame.origin.y+16,UIScreenWidth - X-10 , 20)];
    faPiaoMessage.textColor = BLACKTEXT;
    faPiaoMessage.text  = @"adadkjahfdkljahflka";
    faPiaoMessage.numberOfLines = 0;
    faPiaoMessage.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:faPiaoMessage];
    faPiaoContent = [[UILabel alloc] initWithFrame:CGRectMake(10, faPiaoMessage.frame.origin.y+faPiaoMessage.frame.size.height+5, UIScreenWidth, 30)];
    faPiaoContent.textColor = BLACKTEXT;
    faPiaoContent.text = @"发票内容：";
    faPiaoContent.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:faPiaoContent];
}
- (void)updataWith:(NSString *) message andString:(NSString *) headMessage
        andString1:(NSString *) contentString
{
    CGFloat X = faPiaoHeader.frame.origin.x+faPiaoHeader.frame.size.width-5;
    faPiaoMessage.text = [NSString stringWithFormat:@"发票信息：%@",message];
    CGFloat Height = [TTIFont calHeightWithText:headMessage font:[UIFont systemFontOfSize:15.0] limitWidth:UIScreenWidth - X-10];
    faPiaoMessage.frame = CGRectMake(X, messageLabel.frame.size.height+messageLabel.frame.origin.y+16,UIScreenWidth - X-10 , Height);
    faPiaoMessage.text = headMessage;
    faPiaoContent.text = [NSString stringWithFormat:@"发票内容：%@",contentString];
    faPiaoContent.frame = CGRectMake(10, faPiaoMessage.frame.origin.y+faPiaoMessage.frame.size.height+5, UIScreenWidth, 30);
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
