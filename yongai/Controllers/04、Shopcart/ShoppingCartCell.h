//
//  ShoppingCartCell.h
//  Yongai
//
//  Created by arron on 14/11/2.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShopCartCellDelegate <NSObject>

/**
 *  更新某一行的cell商品数量
 *
 *  @param countStr 更新后的价格
 *  @param row      更新cell的行数
 */
-(void)updateGoodsCountWithRow:(NSInteger)row  goodsCount:(NSString*)countStr;

/**
 *  删除某一行cell
 *
 *  @param row cell的行数
 */
-(void)delGoodsCell:(NSInteger)row;

/**
 *  选择/取消选择 某一行cell
 *
 *  @param row     cell的行数
 *  @param bSelect 选择的状态
 */
-(void)selectGoodsCell:(NSInteger)row status:(BOOL)bSelect;

@end

@interface ShoppingCartCell : UITableViewCell

@property (nonatomic, strong)CartListGoodsModel *goodsInfo;

@property (strong, nonatomic) IBOutlet UIButton *cartSelBtn;//勾选按钮
@property (strong, nonatomic) IBOutlet UIImageView *goodsImageView;//商品图片
@property (strong, nonatomic) IBOutlet UILabel *goodsNameLabel;//商品名称
@property (strong, nonatomic) IBOutlet UILabel *goodsPropertiesLabel;//商品属性
@property (strong, nonatomic) IBOutlet UIButton *goodCountBtn;//商品数量按钮
@property (strong, nonatomic) IBOutlet UILabel *goodPriceLabel;//商品价格
@property (strong, nonatomic) IBOutlet UILabel *goodsStateLabel;

@property (strong, nonatomic) IBOutlet UIImageView *iconZengView;
@property (strong, nonatomic) IBOutlet UIImageView *iconJiangView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zengW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jiangLeft;
@property (weak, nonatomic) IBOutlet UILabel *number;

@property (strong, nonatomic) IBOutlet UIView *marginView;
@property (nonatomic,assign)id<ShopCartCellDelegate> delegate;

@end
