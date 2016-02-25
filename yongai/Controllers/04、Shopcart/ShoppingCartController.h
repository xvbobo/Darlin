//
//  ShoppingCartController.h
//  Yongai
//
//  Created by arron on 14/11/2.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 购物车页面
@interface ShoppingCartController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *payView;
@property (strong, nonatomic) IBOutlet UITableView *cartTableView;
@property (strong, nonatomic) IBOutlet UILabel *cartGoodsPrice;//购物车商品总价
@property (strong, nonatomic) IBOutlet UIButton *payBtn;//结算按钮
@property (strong, nonatomic) IBOutlet UILabel *policyLbl1;
@property (strong, nonatomic) IBOutlet UIButton *choiceAllBtn;//勾选全部按钮

@property (nonatomic, assign) BOOL bFromOtherView; // 是否来自其它页面 是：则显示返回按钮  否：不显示返回按钮

@end
