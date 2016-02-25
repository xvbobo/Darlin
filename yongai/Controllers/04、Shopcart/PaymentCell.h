//
//  PaymentCell.h
//  Yongai
//
//  Created by myqu on 14/12/2.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  立即支付页面上的cell
 */
@interface PaymentCell : UITableViewCell

// 订单状态
@property (strong, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (strong, nonatomic) IBOutlet UIButton *orderActionBtn;
@property (strong, nonatomic) IBOutlet UILabel *invoice;// 运单号
@property (strong, nonatomic) IBOutlet UILabel *invoiceLable;// 运单号
@property (weak, nonatomic) IBOutlet UILabel *dingDanStatus;
@property (weak, nonatomic) IBOutlet UILabel *dingDanNum;

// 订单金额
@property (strong, nonatomic) IBOutlet UILabel *orderPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *shippingfeeLabel;
@property (strong, nonatomic) IBOutlet UILabel *discountGoldLabel;
@property (strong, nonatomic) IBOutlet UILabel *integralMoneyLabel; //先款优惠
@property (weak, nonatomic) IBOutlet UILabel *dingMoney;
@property (weak, nonatomic) IBOutlet UILabel *shangMoney;
@property (weak, nonatomic) IBOutlet UILabel *yunMoney;
@property (weak, nonatomic) IBOutlet UIImageView *order_money_line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *order_money_lineH;

@property (weak, nonatomic) IBOutlet UILabel *jinDi;
@property (weak, nonatomic) IBOutlet UILabel *xianKuan;

// 商品信息抬头


// 商品信息cell
@property (strong, nonatomic) IBOutlet UIImageView *goodsImgView;
@property (strong, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *goodsCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *goodsSpecLabel;
@property (weak, nonatomic) IBOutlet UILabel *shangMessage;
@property (weak, nonatomic) IBOutlet UIImageView *imageLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *linrH;
@property (weak, nonatomic) IBOutlet UIImageView *goodsLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsLineH;

@property (nonatomic, strong) CartListGoodsModel *goodsInfo;


// 收货人信息
@property (strong, nonatomic) IBOutlet UILabel *consigneeLabel;
@property (strong, nonatomic) IBOutlet UILabel *mobileLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;


// 支付方式+配送方式cell
@property (strong, nonatomic) IBOutlet UILabel *payWayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pay_line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pay_lineH;
@property (strong, nonatomic) IBOutlet UILabel *deliveryWayLabel;
@property (strong, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhiFuMethod;
@property (weak, nonatomic) IBOutlet UILabel *peiSongMethod;
@property (weak, nonatomic) IBOutlet UILabel *yunDanHao;

@property (weak, nonatomic) IBOutlet UIButton *checkDetail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkDetailW;
- (void)createdWuliuDetail:(NSString*)yundanNumber;
@end
