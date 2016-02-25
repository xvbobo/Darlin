//
//  ConfirmExchangeViewController.h
//  Yongai
//
//  Created by myqu on 14/11/13.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  确认兑换页面
 */
@interface ConfirmExchangeViewController : UIViewController
@property (nonatomic ,strong)    ExchangeListModel *goodsInfo;
@property (nonatomic ,strong)    AddressModel *address;
@end
