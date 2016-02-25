//
//  ProductSpecView.h
//  Yongai
//
//  Created by Kevin Su on 14-11-14.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductSpecViewDelegate <NSObject>

/**
 *  关闭规格选择View
 **/
- (void)closeProductSpecView:(id)sender;

/**
 *  显示规格选择View
 **/
- (void)showProductSpecView:(id)sender;

- (void)specButtonSelected:(NSDictionary *)dic;

@end

@interface ProductSpecView : UIView

@property (nonatomic, assign) id<ProductSpecViewDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIView *productSpecView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *productSpecViewHeight;
 

@property (strong, nonatomic) IBOutlet UIImageView *picView;

@property (strong, nonatomic) IBOutlet UILabel *pnameLabel;

// 价格label
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

//规格label
@property (strong, nonatomic) IBOutlet UILabel *specLabel;

//规格
@property (strong, nonatomic) IBOutlet UIView *specView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *specViewHeight;



@property (strong, nonatomic) IBOutlet UIView *buyNumberView;

@property (strong, nonatomic) IBOutlet UIButton *closeButton;

@property (strong, nonatomic) IBOutlet UIButton *minusButton;

@property (strong, nonatomic) IBOutlet UIButton *addButton;

@property (strong, nonatomic) IBOutlet UIButton *resultButton;

@property (nonatomic) int resultCount;

@property (strong, nonatomic) IBOutlet UILabel *goodsStatusLabel;

//选中的规格
@property (nonatomic, strong) NSDictionary *selectedSpecDic;

// 规格提示label  规格线
@property (strong, nonatomic) IBOutlet UILabel *specStrLabel; 

//不同规则对应的赠、降tag
@property (strong, nonatomic) IBOutlet UIImageView *specZengTag;
@property (strong, nonatomic) IBOutlet UIImageView *specJiangTag;
@property (weak, nonatomic) IBOutlet UILabel *gouMaiNumber;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zengW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jiangLeft;

- (void)initDataWithDictionary:(NSDictionary *)dataDic width:(CGFloat)width;

@end
