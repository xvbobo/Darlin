//
//  OrderCellHeaderView.m
//  Yongai
//
//  Created by Kevin Su on 14/11/30.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "OrderCellHeaderView.h"

@implementation OrderCellHeaderView

-(void)initDataWithInfo:(OrderListModel *)dataInfo
{
    self.orderDateLabel.textColor = BLACKTEXT;
    self.orderNoLabel.textColor = BLACKTEXT;
    self.dingDanMoney.textColor = BLACKTEXT;
    self.orderNoLabel.text = [NSString stringWithFormat:@"订单号: %@", dataInfo.order_sn];
    self.orderDateLabel.text = [NSString stringWithFormat:@"下单时间: %@", dataInfo.order_time];
    if ([dataInfo.order_sn rangeOfString:@"-"].location != NSNotFound) {
        self.orderPriceLabel.text = [NSString stringWithFormat:@"￥%@ (退换/维修)", dataInfo.order_amount];
    }else{
        self.orderPriceLabel.text = [NSString stringWithFormat:@"￥%@", dataInfo.order_amount];
    }
    
}
@end
