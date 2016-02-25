//
//  RetureMoneyWayCell.m
//  com.threeti
//
//  Created by alan on 15/10/30.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "RetureMoneyWayCell.h"

@implementation RetureMoneyWayCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView * lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 10)];
        lineView.backgroundColor = BJCLOLR;
        lineView.layer.borderColor = LINE.CGColor;
        lineView.layer.borderWidth = 0.5;
        [self addSubview:lineView];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 100, 20)];
        label.text = @"退款方式";
        label.textColor = BLACKTEXT;
        label.font = font(14);
        [self addSubview:label];
        CGFloat leftJian = 10;
        CGFloat Width = (UIScreenWidth - 10*4)/3;
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(leftJian, label.frame.origin.y+label.frame.size.height+10, Width,Width/4);
        [btn setTitle:@"原支付返还" forState:UIControlStateNormal];
        [btn setTitleColor:beijing forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"spec_button_selected"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
//        btn setBackgroundImage:(nullable UIImage *) forState:(UIControlState)
        [self addSubview:btn];
        UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(leftJian+5, btn.frame.size.height+btn.frame.origin.y+10, UIScreenWidth - 50, 50)];
        NSString * text = @"如为支付宝或者微信支付，仅支持原路返回；如果为货到付款支付，将会有人工客服通过电话或系统消息主动与您确认您的收款账号";
        label1.textColor = TEXT;
        label1.numberOfLines = 0;
        label1.font = [UIFont systemFontOfSize:11.0];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        [paragraphStyle setLineSpacing:5.0];//调整行间距
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
        label1.attributedText = attributedString;
        [self addSubview:label1];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
