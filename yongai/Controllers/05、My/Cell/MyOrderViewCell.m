//
//  MyOrderViewCell.m
//  com.threeti
//
//  Created by alan on 15/10/29.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "MyOrderViewCell.h"
#import "DingDanView.h"
@implementation MyOrderViewCell
{
    UIImageView * View1;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = LINE.CGColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.userInteractionEnabled = YES;
        [self createInterFace];
    }
    return self;
}
- (void)createInterFace
{
    self.backgroundColor = BJCLOLR;
    View1 =  [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, UIScreenWidth, 130)];
    View1.userInteractionEnabled = YES;
    View1.layer.borderWidth = 0.5;
    View1.layer.borderColor = LINE.CGColor;
    View1.backgroundColor = [UIColor whiteColor];
    UIImageView * iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 30, 30)];
    iconView.image = [UIImage imageNamed:@"my_cell_order_icon"];
    [View1 addSubview:iconView];
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconView.frame.origin.x+10+iconView.frame.size.width, iconView.frame.origin.y+7, 80, 15)];
    titleLabel.text = @"我的订单";
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    titleLabel.textColor = BLACKTEXT;
    [View1 addSubview:titleLabel];
    UIImageView * jianTouView = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenWidth - 20, titleLabel.frame.origin.y,7, 13)];
    jianTouView.image = [UIImage imageNamed:@"SettingViewCell_right"];
    [View1 addSubview:jianTouView];
    UILabel * titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(jianTouView.frame.origin.x - 90,titleLabel.frame.origin.y, 80, 15)];
    titleLabel1.text = @"查看全部订单";
    titleLabel1.font = [UIFont systemFontOfSize:13.0];
    titleLabel1.textColor = TEXT;
    [View1 addSubview:titleLabel1];
    UIImageView * lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, iconView.frame.origin.y+iconView.frame.size.height+15, UIScreenWidth, 0.5)];
    lineView.backgroundColor = LINE;
    [View1 addSubview:lineView];
    CGFloat bianju = 18;
    CGFloat viewW = 40;
    CGFloat jianju = (UIScreenWidth - bianju*2 - viewW*5)/4;
    for (int i = 0; i< 5; i++) {
        DingDanView * dingDan = [[DingDanView alloc] initWithFrame:CGRectMake(18+i*(viewW+jianju),lineView.frame.origin.y+16, viewW, viewW)];
        dingDan.userInteractionEnabled = YES;
        dingDan.tag = 200+i;
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(18+i*(viewW+jianju),lineView.frame.origin.y+16, viewW, viewW);
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        dingDan.image.frame = CGRectMake(8, 0, viewW-15, viewW-20);
        if (i < 4) {
            dingDan.label.hidden = NO;
        }else {
            dingDan.label.hidden = YES;
            
        }
        dingDan.label.frame = CGRectMake(dingDan.image.frame.size.width, dingDan.image.frame.origin.y-5, 12, 12);
        dingDan.label.textColor = [UIColor whiteColor];
        dingDan.label.font = [UIFont systemFontOfSize:8];
        dingDan.label.textAlignment = NSTextAlignmentCenter;
        dingDan.label.layer.masksToBounds = YES;
        dingDan.label.layer.cornerRadius = 6;
        dingDan.label.backgroundColor = beijing;
        dingDan.label.hidden = YES;
        dingDan.nameLabel.frame = CGRectMake(0, viewW-10, viewW+15, 10);
        dingDan.nameLabel.center = CGPointMake(dingDan.image.center.x, dingDan.image.center.y+25);
        if (i==3) {
            dingDan.nameLabel.text = @"待评价";
            dingDan.image.image = [UIImage imageNamed:@"待评价"];
        }else if (i == 1){
            dingDan.nameLabel.text = @"待发货";
            dingDan.image.image = [UIImage imageNamed:@"待发货"];
        }else if (i == 0){
            dingDan.nameLabel.text = @"待付款";
            dingDan.image.image = [UIImage imageNamed:@"待付款"];
        }else if(i == 2){
            dingDan.nameLabel.text = @"待收货";
            dingDan.image.image = [UIImage imageNamed:@"待收货"];
        }else{
            dingDan.nameLabel.text = @"返修/退换";
            dingDan.image.image = [UIImage imageNamed:@"返修"];
        }

        dingDan.nameLabel.textAlignment = NSTextAlignmentCenter;
        dingDan.nameLabel.font = [UIFont systemFontOfSize:12.0];
        dingDan.nameLabel.textColor = TEXT;
        [View1 addSubview:dingDan];
        [View1 insertSubview:btn aboveSubview:dingDan];
    }
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0,15,UIScreenWidth,40);
    btn.tag = 1000;
    [btn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [View1 addSubview:btn];
    [self addSubview:View1];
}
- (void)initWithDict:(NSDictionary *)dict
{
    
       for (int i = 0; i < 5; i++) {
        DingDanView * dingDan = (DingDanView*)[View1 viewWithTag:200+i];
        if (dict == nil) {
            dingDan.label.hidden = YES;
        }else{
        if (i==3) {
            dingDan.label.text =[NSString stringWithFormat:@"%@",[dict objectForKey:@"to_comment"]] ;
        }else if (i == 1){
            dingDan.label.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"to_deliver"]];
        }else if (i == 0){
            dingDan.label.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"to_pay"]];
        }else if(i == 2){
            dingDan.label.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"to_confirm"]];
        }else{
            dingDan.label.text = @"0";
        }
        if ([dingDan.label.text isEqualToString:@"0"]) {
            dingDan.label.hidden = YES;
        }else{
            dingDan.label.hidden = NO;
        }
        }
    }
}
- (void)action:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(DingDanLieBiaoFenLei:)]) {
        [self.delegate DingDanLieBiaoFenLei:button];
    }
    NSLog(@"%ld",button.tag);
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
