//
//  MCProductPromotionCell.h
//  Yongai
//
//  Created by Kevin Su on 14-11-10.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//
//  促销信息
#import <UIKit/UIKit.h>

@interface MCProductPromotionCell : UITableViewCell
//赠品提示按钮
@property (strong ,nonatomic) UILabel * xLabel;
@property (strong,nonatomic) UIImageView * pic1;
@property (strong,nonatomic) UIImageView * imagePic;
@property (strong,nonatomic) NSString * string1;
@property (strong,nonatomic) NSString * jiangStr;
@property (strong,nonatomic) NSString * yunFeiStr;
@property (strong,nonatomic) UIImageView * lineDown;

-(void)initWithGoodsInfo:(GoodsInfoModel *)goodsInfo withEndTime:(NSString *)endtime ;
@end
