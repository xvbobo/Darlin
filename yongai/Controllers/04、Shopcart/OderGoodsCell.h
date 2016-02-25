//
//  OderGoodsCell.h
//  Yongai
//
//  Created by arron on 14/11/6.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  商品清单列表上的cell
 */
@interface OderGoodsCell : UITableViewCell

//  公用部分控件
@property (strong, nonatomic) IBOutlet UIImageView *goodsImgView; // 商品头像
@property (strong, nonatomic) IBOutlet UILabel *goodsNameLabel; //  商品名称
@property (strong, nonatomic) IBOutlet UILabel *priceLabel; // 商品价格


//购买商品上的控件
@property (strong, nonatomic) IBOutlet UILabel *goodsCountLabel;//  商品数量label
@property (strong, nonatomic) IBOutlet UILabel *goodsSpecLabel; // 商品规则描述
@property (weak, nonatomic) IBOutlet UILabel *guiGe;
@property (strong, nonatomic) IBOutlet UIImageView *zengTagImg;
@property (strong, nonatomic) IBOutlet UIImageView *dropTagImg;

@property (strong, nonatomic)CartListGoodsModel  *goodsInfo;

// 赠品cell上的控件
@property (strong, nonatomic) IBOutlet UIButton *goodsCountBtn;//  商品数量Button
@property (strong, nonatomic) GiftGoodsModel  *giftInfo;

@end
