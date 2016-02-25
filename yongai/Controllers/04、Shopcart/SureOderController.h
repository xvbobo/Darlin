//
//  SureOderController.h
//  Yongai
//
//  Created by arron on 14/11/5.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>
/// 订单确认页面
@interface SureOderController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *sureOderTable;
@property (weak, nonatomic) IBOutlet UILabel *shouldMoney;
@property (weak, nonatomic) IBOutlet UILabel *dingDanDown;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property(nonatomic, strong) SettlementModel *settleInfo; //  订单信息
@property(nonatomic, strong) NSMutableString *goodsIds; //商品列表的商品ids

@end
