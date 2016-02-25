//
//  MallProductClassificationCell.h
//  Yongai
//
//  Created by Kevin Su on 14/11/19.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//
///首页商品分类
#import <UIKit/UIKit.h>

@protocol MallProductClassificationCellDelegate <NSObject>

//显示分类页
- (void)showClassification:(NSString *)cid  title:(NSString *)title;

@end

//商品分类
@interface MallProductClassificationCell : UITableViewCell

@property (nonatomic, assign) id<MallProductClassificationCellDelegate> delegate;


- (void)initWithArray:(NSArray *)array;

@end
