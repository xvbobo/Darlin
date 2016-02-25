//
//  TieBaCell.h
//  com.threeti
//
//  Created by alan on 15/7/8.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TieBaCell : UITableViewCell
@property (nonatomic,strong) UIImageView * headView;
@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * detailLabel;
@property (nonatomic,strong) UILabel * timeLabel;
@property (nonatomic,strong) UILabel * tieLabel;
@property (nonatomic,strong) UIImageView * detailImage;
- (void)cellWithTiebaModel:(Tongzhi*)model;
@end
