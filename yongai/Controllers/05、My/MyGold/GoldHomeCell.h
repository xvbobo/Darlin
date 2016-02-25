//
//  GoldHomeCell.h
//  Yongai
//
//  Created by myqu on 14/11/5.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  我的金币首页cell
 */
@interface GoldHomeCell : UITableViewCell

// 金币任务cell

// cell图片
@property (strong, nonatomic) IBOutlet UIImageView *cellImgView;

// cell名称
@property (strong, nonatomic) IBOutlet UILabel *cellNameLabel;

// 金币数
@property (strong, nonatomic) IBOutlet UILabel *goldNumLabel;

// 比例数
@property (strong, nonatomic) IBOutlet UILabel *ratioLabel;

// 金币标签图
@property (strong, nonatomic) IBOutlet UIImageView *goldTagImgView;

// cell分割线
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cellLineView;
@end
