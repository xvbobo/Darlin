//
//  MCProductOtherInfoCell.h
//  Yongai
//
//  Created by Kevin Su on 14-11-10.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//
//  图文详情 商品评价 基本参数
#import <UIKit/UIKit.h>
#import "CWStarRateView.h"

@protocol MCProductOtherInfoCellDelegate <NSObject>
/**
 *  显示图文页
 *//**
 *  显示商品评论页
 */
- (void)showProductCommentView:(UITapGestureRecognizer *)gesture;
@end

@interface MCProductOtherInfoCell : UITableViewCell

@property (nonatomic, assign)id<MCProductOtherInfoCellDelegate> delegate;
//商品评论
@property (strong, nonatomic) IBOutlet UIView *productCommentView;
//评论数量
@property (strong, nonatomic) IBOutlet UILabel *commentNumLabel;
//评论星级
@property (weak, nonatomic) IBOutlet UIImageView *line2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line2H;

-(void)initDataWithGoodsInfo:(GoodsInfoModel*)goodsInfo;

@property (weak, nonatomic) IBOutlet UILabel *label2;
 

@end
