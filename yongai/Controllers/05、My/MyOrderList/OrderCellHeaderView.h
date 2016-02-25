//
//  OrderCellHeaderView.h
//  Yongai
//
//  Created by Kevin Su on 14/11/30.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCellHeaderView : UIView
//订单号
@property (strong, nonatomic) IBOutlet UILabel *orderNoLabel;
//订单金额
@property (strong, nonatomic) IBOutlet UILabel *orderPriceLabel;
//下单时间
@property (strong, nonatomic) IBOutlet UILabel *orderDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dingDanMoney;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIButton *canclebtn;

//- (void)initDataWithDictionary:(NSDictionary *)dataDic;

-(void)initDataWithInfo:(OrderListModel *)dataInfo;
@end
