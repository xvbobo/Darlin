//
//  SureOderCell.h
//  Yongai
//
//  Created by arron on 14/11/5.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SureOderCellDelegate <NSObject>

/**
 *  修改使用金币数
 *
 *  @param num 修改后的值
 */
-(void)changeGoldNum:(NSInteger )num;

@end

/// 确认订单列表上的cell
@interface SureOderCell : UITableViewCell <UITextFieldDelegate>

@property(nonatomic, assign)id <SureOderCellDelegate> delegate;

/**
 *  收货人地址的cell
 */
@property (strong, nonatomic) IBOutlet UILabel *actionName; //事件cell名称
@property (strong, nonatomic) IBOutlet UILabel *consigneeLabel;
@property (strong, nonatomic) IBOutlet UILabel *mobileLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIView *addressMarginView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addHeight;

/**
 *  填写收货人地址的cell
 */
@property (strong, nonatomic) IBOutlet UIView *addAddressMarginView;


/**
 *  商品金额信息的cell
 */
@property (strong, nonatomic) IBOutlet UILabel *goodsPriceLabel; // 商品金额
@property (strong, nonatomic) IBOutlet UILabel *goodsDiscountLabel; // 先款优惠
@property (strong, nonatomic) IBOutlet UILabel *goodsDeductionLabel; // 金币抵扣
@property (strong, nonatomic) IBOutlet UILabel *goodsFreightLabel; // 运费
@property (strong, nonatomic) IBOutlet UIView *priceMarginView;
@property (weak, nonatomic) IBOutlet UIImageView *order_line1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *order_line1H;
@property (weak, nonatomic) IBOutlet UIImageView *order_line2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *order_line2H;
@property (weak, nonatomic) IBOutlet UIImageView *order_line3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *order_line3H;



/**
 *  使用金币的cell
 */
- (IBAction)minusBtnClick:(id)sender;
- (IBAction)addBtnClick:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *goldCountTextFiled;
@property (strong, nonatomic) IBOutlet UILabel *canUseGoldLabel;

@property (strong, nonatomic) IBOutlet UIView *goldMarginView;
@property (weak, nonatomic) IBOutlet UILabel *shouHuoAdress;
@property (weak, nonatomic) IBOutlet UILabel *shouHuoPeople;
@property (weak, nonatomic) IBOutlet UILabel *shouji;
@property (weak, nonatomic) IBOutlet UILabel *dizhi;
@property (weak, nonatomic) IBOutlet UILabel *goodsMoney;
@property (weak, nonatomic) IBOutlet UILabel *jinBiDi;
@property (weak, nonatomic) IBOutlet UILabel *moneyFirst;
@property (weak, nonatomic) IBOutlet UILabel *yunMoney;
@property (weak, nonatomic) IBOutlet UILabel *useJinBi;
@property (weak, nonatomic) IBOutlet UILabel *keYongJinBi;


@end
