//
//  NewOrderFooterCell.m
//  com.threeti
//
//  Created by alan on 15/11/3.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "NewOrderFooterCell.h"

@implementation NewOrderFooterCell
{
    UILabel * statusLabel;
    UILabel * button1;
    UILabel * button2;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.backgroundColor = beijing;
        statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 30)];
//        statusLabel.text = @"订单状态：代发货";
        statusLabel.textColor = beijing;
        statusLabel.font = [UIFont systemFontOfSize:13.0];
        [self addSubview:statusLabel];
        button1 = [[UILabel alloc]initWithFrame:CGRectMake(UIScreenWidth-90,10, 80,25)];
//        button1.frame = CGRectMake(UIScreenWidth-90,10, 80,25);
        button1.layer.masksToBounds = YES;
        button1.layer.borderColor = LINE.CGColor;
        button1.layer.borderWidth = 0.5;
        button1.tag = 100;
        button1.layer.cornerRadius = 5;
        button1.backgroundColor = beijing;
        button1.text = @"确认收货";
        button1.textAlignment = NSTextAlignmentCenter;
        button1.textColor = [UIColor whiteColor];
        button1.font = [UIFont systemFontOfSize:12.0];
//        [button1 setTitle:@"确认收货" forState:UIControlStateNormal];
//        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        button1.titleLabel.font = [UIFont systemFontOfSize:12.0];
        button1.hidden = YES;
        button2 = [[UILabel alloc] initWithFrame:CGRectMake(button1.frame.origin.x-90,10, 80, 25)];
//        button2.frame = CGRectMake(button1.frame.origin.x-90,10, 80, 25);
        button2.layer.masksToBounds = YES;
        button2.layer.cornerRadius = 5;
        button2.layer.borderColor = LINE.CGColor;
        button2.layer.borderWidth = 0.5;
        button2.textColor = [UIColor whiteColor];
        button2.text = @"取消订单";
        button2.backgroundColor = beijing;
        button2.textAlignment = NSTextAlignmentCenter;
//       [button2 setTitle:@"取消订单" forState:UIControlStateNormal];
//        [button2 setTitleColor:BLACKTEXT forState:UIControlStateNormal];
        button2.tag = 101;
        button2.font = [UIFont systemFontOfSize:12.0];
//        [button2 addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
//        [button1 addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button2];
        [self addSubview:button1];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)action:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(NewOrderFooterCellButtonAction:)]) {
        [self.delegate NewOrderFooterCellButtonAction:btn];
    }
}
-(void)initDataWithInfo:(OrderListModel *)dataInfo index:(NSInteger)index
{
    // 1待付款，2待发货，3待收货，4已完成，5已取消
    statusLabel.text = [NSString stringWithFormat:@"订单状态：%@",dataInfo.order_status_text];
    NSString * str = dataInfo.order_status;
    if (str.intValue == 1) {
        button1.hidden = NO;
        button2.hidden = NO;
        button2.text = @"取消订单";
        button1.text = @"去支付";
//        [button2 setTitle:@"取消订单" forState:UIControlStateNormal];
//        [button1 setTitle:@"去支付" forState:UIControlStateNormal];
    }else if (str.intValue == 2){
        button1.hidden = NO;
        button2.hidden = YES;
        button1.text = @"取消订单";
//        [button1 setTitle:@"取消订单" forState:UIControlStateNormal];
//        button2.frame = button1.frame;
    }else if (str.intValue == 3){
        button1.hidden = NO;
        button2.hidden = YES;
        button1.text = @"确认收货";
//       [button1 setTitle:@"确认收货" forState:UIControlStateNormal];
    }else if (str.intValue == 4){
        button1.hidden = NO;
        button2.hidden = NO;
        if(![dataInfo.order_comment isKindOfClass:[NSNull class]] && [dataInfo.order_comment intValue] == 0   && ![dataInfo.pay_code isEqualToString:@"integral"]){
            //未评论,显示评论
            button1.text = @"去评价";
//           [button1 setTitle:@"去评价" forState:UIControlStateNormal];
            
        }else{
            
//            self.orderStatusImg.hidden = YES;
            button1.text = @"再次购买";
//            [button1 setTitle:@"再次购买" forState:UIControlStateNormal];
//            button2.frame = button1.frame;
        }
        button2.text = @"删除";
//        [button2 setTitle:@"删除" forState:UIControlStateNormal];
    }else if (str.intValue == 5){
        button1.hidden = NO;
        button2.hidden = NO;
        button2.text = @"删除";
         button1.text = @"再次购买";
//         [button2 setTitle:@"删除" forState:UIControlStateNormal];
//        [button1 setTitle:@"再次购买" forState:UIControlStateNormal];
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
