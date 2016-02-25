//
//  OrderCellFooterView.m
//  Yongai
//
//  Created by Kevin Su on 14/11/30.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "OrderCellFooterView.h"

@implementation OrderCellFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)initDataWithInfo:(OrderListModel *)dataInfo index:(NSInteger)index
{
    NSMutableAttributedString *orderStateAttrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"订单状态:  %@", dataInfo.order_status_text]];
    [orderStateAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1 green:136/255.0 blue:64/255.0 alpha:1] range:NSMakeRange(5, [dataInfo.order_status_text length])];
    self.orderStateLabel.attributedText = orderStateAttrStr;
    
    NSString *orderStatus = dataInfo.order_status;
    NSString *statusStr;
    
//    BOOL isAliPay =[dataInfo.pay_code isEqualToString:@"alipay"]?YES:NO;
//     BOOL isWeiXin =[dataInfo.pay_code isEqualToString:@"weixin"]?YES:NO;
    // 1待付款，2待发货，3待收货，4已完成，5已取消
    if(orderStatus.intValue == 1)
    {
//        if ([dataInfo.pay_code isEqualToString:@"weiXin"]||[dataInfo.pay_code isEqualToString:@"alipay"]) {
            statusStr =@"去支付";
//
//        }else{
//            self.orderStateLabel.hidden = YES;
//            self.orderStatusImg.hidden = YES;
//        }
//        if(!isAliPay && !isWeiXin){
//            
//            self.orderStateLabel.hidden = YES;
//            self.orderStatusImg.hidden = YES;
//        }else{
//            statusStr =@"去支付";
//        }
    }
    else if(orderStatus.intValue == 2)
    {
        self.orderStatusImg.hidden = YES;
    }else if(orderStatus.intValue == 3){
        
        statusStr =@"确认收货";
    }
    else if(orderStatus.intValue == 4)
    {
        [self.orderStatusImg setImage:[UIImage imageNamed:@"paymentBtn"]];
        
        if(![dataInfo.order_comment isKindOfClass:[NSNull class]] && [dataInfo.order_comment intValue] == 0   && ![dataInfo.pay_code isEqualToString:@"integral"]){
            //未评论,显示评论
            statusStr = @"去评价";
            self.orderStatusImg.hidden = NO;
        }else{
            
            self.orderStatusImg.hidden = YES;
        }
        [self.orderStatusImg setImage:[UIImage imageNamed:@"paymentBtn"]];
        
    }else if(orderStatus.integerValue == 5){
        
        self.orderStatusImg.hidden = YES;
    }
  
    [self.stateLabel setText:statusStr];
}
 

@end
