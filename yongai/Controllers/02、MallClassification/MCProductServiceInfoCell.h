//
//  MCProductServiceInfoCell.h
//  Yongai
//
//  Created by Kevin Su on 14-11-10.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//
//  商品服务信息
#import <UIKit/UIKit.h>

@protocol MCProductServiceInfoCellDelegate <NSObject>

//显示免运费政策
- (void)showFreeFreightView;

- (void)showGoldRuleView;

@end

@interface MCProductServiceInfoCell : UITableViewCell

@property (nonatomic, assign) float  payContentHeight;
@property (nonatomic, strong) NSString  *payContentString;

@property (nonatomic, assign) id<MCProductServiceInfoCellDelegate> delegate;

//是否显示货到付款规则
@property (nonatomic) BOOL isContentShown;


@end
