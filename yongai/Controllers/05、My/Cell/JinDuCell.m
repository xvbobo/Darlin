//
//  JinDuCell.m
//  com.threeti
//
//  Created by alan on 15/11/4.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "JinDuCell.h"
#import "TTIFont.h"
@implementation JinDuCell
{
    UILabel * serveNum;
    UILabel * goodsName;
    UILabel * statusLabel;
    UILabel * timeLabel;
    UIButton * cancelBtn;
    UIButton * chectBtn;
    UIImageView * lineView ;
    UIImageView * imageview;//背景
    NSIndexPath * indexPath1;//所在行
    UILabel * leaveMessage;//留言
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, UIScreenHeight, 150)];
        imageview.userInteractionEnabled = YES;
        imageview.backgroundColor = [UIColor whiteColor];
        imageview.layer.borderColor = LINE.CGColor;
        imageview.layer.borderWidth = 0.5;
        [self addSubview:imageview];
        serveNum = [[UILabel alloc] initWithFrame:CGRectMake(10,5, UIScreenWidth-20,30)];
        serveNum.font = [UIFont systemFontOfSize:13.0];
        serveNum.textColor = BLACKTEXT;
        lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, serveNum.frame.origin.y+serveNum.frame.size.height, UIScreenWidth, 0.5)];
        lineView.backgroundColor = LINE;
        [imageview addSubview:lineView];
        [imageview addSubview:serveNum];
        goodsName = [[UILabel alloc] initWithFrame:CGRectMake(10, lineView.frame.origin.y+10, UIScreenWidth-30, 30)];
        goodsName.numberOfLines = 0;
        goodsName.text = @"2112123123";
        goodsName.textColor = BLACKTEXT;
        goodsName.font = [UIFont systemFontOfSize:13.0];
        [imageview addSubview:goodsName];
        statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, goodsName.frame.origin.y+goodsName.frame.size.height+5, UIScreenWidth, 20)];
        statusLabel.font = [UIFont systemFontOfSize:13.0];
        statusLabel.numberOfLines = 0 ;
        statusLabel.textColor = TEXT;
        [imageview addSubview:statusLabel];
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, statusLabel.frame.origin.y+statusLabel.frame.size.height+5, UIScreenWidth, 20)];
        timeLabel.textColor = TEXT;
        timeLabel.font = [UIFont systemFontOfSize:13.0];
        [imageview addSubview:timeLabel];
        leaveMessage = [[UILabel alloc] init];
        leaveMessage.textColor = TEXT;
        leaveMessage.numberOfLines = 0;
        leaveMessage.font = [UIFont systemFontOfSize:13.0];
        [imageview addSubview:leaveMessage];
        cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(UIScreenWidth-90, timeLabel.frame.origin.y+timeLabel.frame.size.height+5, 80, 30);
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [cancelBtn setTitle:@"取消审核" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:BLACKTEXT forState:UIControlStateNormal];
//        cancelBtn.tag = 100;
        cancelBtn.layer.masksToBounds = YES;
        cancelBtn.layer.cornerRadius = 5;
        cancelBtn.layer.borderColor = LINE.CGColor;
        cancelBtn.layer.borderWidth = 0.5;
        [cancelBtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [imageview addSubview:cancelBtn];
        chectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        chectBtn.frame = CGRectMake(cancelBtn.frame.origin.x-100, cancelBtn.frame.origin.y, 100, 30);
        [chectBtn setTitle:@"查看邮寄地址" forState:UIControlStateNormal];
        chectBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [chectBtn setTitleColor:BLACKTEXT forState:UIControlStateNormal];
        chectBtn.tag = 101;
        chectBtn.layer.masksToBounds = YES;
        chectBtn.layer.cornerRadius = 5;
        chectBtn.layer.borderColor = LINE.CGColor;
        chectBtn.layer.borderWidth = 0.5;
        [chectBtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [imageview addSubview:chectBtn];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = BJCLOLR;
    }
    return self;
}
- (void)action:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(buttonAction:withServeId:)]) {
         NSString * serveStr = [self.model objectForKey:@"service_id"];
        [self.delegate buttonAction:button withServeId:serveStr];
    }
}
- (void)initWithDict:(NSDictionary *) dict withIndexPath:(NSIndexPath *)indexPath
{
    NSString * serveStr = [dict objectForKey:@"service_id"];
    NSString * goodsStr = [dict objectForKey:@"goods_name"];
    NSString * statusStr = [dict objectForKey:@"service_status"];
    NSString * isReturn = [dict objectForKey:@"is_return"];
    cancelBtn.tag = serveStr.intValue;
    indexPath1 = indexPath;
    if ([statusStr isEqualToString:@"0"]||[statusStr isEqualToString:@"6"]) {
        chectBtn.hidden = YES;
        cancelBtn.hidden = NO;
    }else if ([statusStr isEqualToString:@"1"]){
        if ([isReturn isEqualToString:@"1"]) {
           chectBtn.hidden = YES;
            cancelBtn.hidden = YES;
        }else{
           chectBtn.hidden = NO;
            cancelBtn.hidden = NO;
        }
    
        
    }else {
        chectBtn.hidden = YES;
        cancelBtn.hidden = YES;
    }
    
    NSString * string;
    switch (statusStr.intValue) {
        case 0:
            string = @"审核中";
            break;
            case 1:
            string = @"等待用户寄出";
            break;
            case 2:
            string = @"已完成";
            break;
            case 3:
            string = @"驳回";
            break;
            case 4:
            string = @"客服关单";
            break;
            case 5:
            string = @"用户关单";
            break;
            case 6:
            string = @"客服处理中";
            break;
            
        default:
            break;
    }
    NSString * timeStr = [dict objectForKey:@"modifytime"];
    NSString * str = [dict objectForKey:@"backup"];
    serveNum.text = [NSString stringWithFormat:@"服务单号：%@",serveStr];
    CGFloat H = [TTIFont calHeightWithText:goodsStr font:[UIFont systemFontOfSize:13.0] limitWidth:UIScreenWidth-30];
    goodsName.frame = CGRectMake(10, lineView.frame.origin.y+5, UIScreenWidth-30, H);
    goodsName.text = goodsStr;
    
    if ([string isEqualToString:@"等待用户寄出"] && [isReturn isEqualToString:@"1"]) {
        string = [NSString stringWithFormat:@"审核通过，形成新订单，单号为：%@",serveStr];
    }else{
        NSLog(@"%@",string);
    }
    NSString * money = [dict objectForKey:@"refund_money"];
    NSString * is_refund = [dict objectForKey:@"is_refund"];
    if (is_refund.intValue == 1) {
        string = [NSString stringWithFormat:@"审核通过，退款%@元将在24小时内到帐",money];
        chectBtn.hidden = YES;
        cancelBtn.hidden = YES;
    }else{
        NSLog(@"%@",string);
    }

    NSMutableAttributedString * AttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"状态：%@",string]];
    [AttributedString addAttribute:NSForegroundColorAttributeName value:beijing range:NSMakeRange(3, string.length)];
    [statusLabel setAttributedText:AttributedString];
    NSLog(@"%@",statusLabel.text);
    CGFloat Height = [TTIFont calHeightWithText:statusLabel.text font:[UIFont systemFontOfSize:13.0] limitWidth:UIScreenWidth-20];
    timeLabel.text = [NSString stringWithFormat:@"审核时间：%@",timeStr];
    statusLabel.frame = CGRectMake(10, goodsName.frame.origin.y+goodsName.frame.size.height+5, UIScreenWidth, Height);
//    CGFloat leaveMessageH = [TTIFont calHeightWithText:@"审核留言：你是我的小雅小苹果，怎么爱你都不嫌多" font:[UIFont systemFontOfSize:13.0] limitWidth:UIScreenWidth];
    
//    if (![str isEqualToString:@""]) {
//        
//    }else{
//        leaveMessageH = 0;
//    }
    CGFloat leaveMessageH;
    if (![str isEqualToString:@""]) {
        leaveMessage.hidden = NO;
        leaveMessageH = [TTIFont calHeightWithText:[NSString stringWithFormat:@"审核留言：%@",str] font:[UIFont systemFontOfSize:13.0] limitWidth:UIScreenWidth-20];
        leaveMessage.frame =  CGRectMake(10, statusLabel.frame.origin.y+statusLabel.frame.size.height+5, UIScreenWidth-20, leaveMessageH);
        leaveMessage.text = [NSString stringWithFormat:@"审核留言：%@",str];
        timeLabel.frame = CGRectMake(10, leaveMessage.frame.origin.y+leaveMessageH+5, UIScreenWidth, 20);
    }else{
        leaveMessage.hidden = YES;
        timeLabel.frame = CGRectMake(10, statusLabel.frame.origin.y+statusLabel.frame.size.height+5, UIScreenWidth, 20);
    }
    cancelBtn.frame = CGRectMake(UIScreenWidth-90, timeLabel.frame.origin.y+timeLabel.frame.size.height+10, 80, 30);
    chectBtn.frame = CGRectMake(cancelBtn.frame.origin.x-110, cancelBtn.frame.origin.y, 100, 30);
    if (cancelBtn.hidden == YES && chectBtn.hidden == YES) {
        imageview.frame = CGRectMake(0,15, UIScreenWidth,timeLabel.frame.origin.y+timeLabel.frame.size.height+10);
    }else{
        imageview.frame = CGRectMake(0,15, UIScreenWidth,cancelBtn.frame.origin.y+cancelBtn.frame.size.height+10);
    }
    

//    if ([string isEqualToString:@"用户关单"] || [isReturn isEqualToString:@"1"]) {
//        imageview.frame = CGRectMake(0,15, UIScreenWidth, 140);
//    }else{
//        imageview.frame = CGRectMake(0,15, UIScreenWidth, 160+leaveMessageH);
//    }
//    

}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
