//
//  PayWayCell.h
//  Yongai
//
//  Created by arron on 14/11/5.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PayWayCellDelegate <NSObject>

/**
 *  选择支付方式
 *
 *  @param index 1：cod  2：alipay  3：weixin
 */
-(void)didSelectPayWay:(NSInteger)index;

@end

/// 支付方式cell
@interface PayWayCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *codfreeLabel;
@property (strong, nonatomic) IBOutlet UILabel *alipayFreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *weiXinFreeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *order_line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *on_lineH;

@property (strong, nonatomic) IBOutlet UIButton *codBtn;
@property (strong, nonatomic) IBOutlet UIButton *alipayBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiXinBtn;

@property(nonatomic, strong)PaymentObject *payment;
@property(nonatomic, assign)id<PayWayCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *payWay;
@property (weak, nonatomic) IBOutlet UILabel *huoDaoPay;
@property (weak, nonatomic) IBOutlet UILabel *zhiFuBao;
@property (weak, nonatomic) IBOutlet UILabel *weiXin;

@property (strong, nonatomic) IBOutlet UIView *payMarginView;
@end
