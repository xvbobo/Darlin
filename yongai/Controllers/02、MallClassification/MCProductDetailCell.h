//
//  MCProductDetailCell.h
//  Yongai
//
//  Created by Kevin Su on 14-11-10.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//
//  商品信息  商品详情（图片，价格...）
#import <UIKit/UIKit.h>
#import "TTICycleScrollView.h"
#import "CrosslineLabel.h"
@protocol MCProductDetailCellDelegate <NSObject>

- (void)shijiandao;

@end

@interface MCProductDetailCell : UITableViewCell<TTICycleScrollViewDatasource, TTICycleScrollViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *picsArray;
@property (assign,nonatomic) id <MCProductDetailCellDelegate> delegate;
@property (nonatomic, strong) TTICycleScrollView *imagesScrollView;
@property (nonatomic,strong) UIView * detailView;
@property (nonatomic,strong) UIView * ScrollView;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * detailLabel;
@property (nonatomic,strong) UILabel * priceLable;
@property (nonatomic, strong) UILabel * countLabel;
@property(nonatomic, strong) UIImageView * ZengView;
@property (nonatomic,strong) UIImageView * jiangView;
@property (nonatomic,strong) UIImageView * shijianView;
@property (nonatomic,strong) UILabel * shijianLabel;

-(void)initCellWithDeatilInfo:(GoodsDetailInfoModel *)info withCellHeight:(CGFloat) cellHeight with:(NSString *)saleNum;
@end
