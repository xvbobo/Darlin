//
//  PaymentViewController.h
//  Yongai
//
//  Created by myqu on 14/12/2.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  立即支付/订单详情页面
 */
@interface PaymentViewController : UIViewController

@property (nonatomic, strong) OrderDetailModel *orderInfo; //  订单信息
@property (nonatomic, strong) OrderListModel *dataInfo;
@property (nonatomic,strong) NSString * orderID;
@property (nonatomic, assign) BOOL bFromOrderList; //是否来自订单列表，是则直接返回上层
@property (nonatomic,strong) NSString * weixinStr;
@property (nonatomic,strong) NSString * adString;
@property (nonatomic,strong) NSString * myTitleString;
@end
