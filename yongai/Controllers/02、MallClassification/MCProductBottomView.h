//
//  MCProductBottomView.h
//  Yongai
//
//  Created by Kevin Su on 14-11-12.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//
//  商品详情底部加入购物车/立即购买菜单栏
#import <UIKit/UIKit.h>

@protocol MCProductBottomViewDelegate <NSObject>

/**
 *  加入购物车
 **/
- (void)addToShopcartAction;

/**
 *  立即购买
 **/
- (void)buyAction;

/**
 *  查看购物车
 **/
- (void)showShopcartView;

/**
 *  确定添加
 **/
- (void)confirmAddAction;

/**
 *  确定购买
 **/
- (void)confirmBuyAction;
/**
 *  客服点击
 **/
- (void)kefuClick;

@end

@interface MCProductBottomView : UIView

@property (nonatomic , assign) id<MCProductBottomViewDelegate> delegate;

//加入购物车



@property (strong, nonatomic) UIButton *addShopCartButton;

//立即购买
@property (strong, nonatomic)  UIButton *buyButton;

//查看购物车
@property (strong, nonatomic) UIButton *showShopCartButton;

@property (strong, nonatomic) UIView *shopcartView;

@property (strong, nonatomic)  UIImageView *shopcartCountImageView;

@property (strong, nonatomic)  UILabel *shopcartCountLabel;

@property (strong, nonatomic)  UIButton *confirmAddButton;

@property (strong, nonatomic)  UIButton *confirmBuyButton;
@property (strong,nonatomic) UIImageView * kefuImage;
@property (strong,nonatomic) UIImageView * imageView1;
@property (strong,nonatomic) UIImageView * imageView2;
- (void)initDataWithDictionary:(NSDictionary *)dataDic;

@end
