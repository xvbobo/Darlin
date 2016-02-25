//
//  SearchProductCell.h
//  Yongai
//
//  Created by Kevin Su on 14/12/1.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchProductCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *picView; // 商品图片

@property (strong, nonatomic) IBOutlet UILabel *pnameLabel; //

@property (strong, nonatomic) IBOutlet UILabel *priceLabel; // 价格 label

@property (strong, nonatomic) IBOutlet UILabel *marketPriceLabel; // 市场价格 label

@property (strong, nonatomic) IBOutlet UIImageView *iconZengView; // 赠 标签

@property (strong, nonatomic) IBOutlet UIImageView *iconJiangView; // 降 标签
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconZengW;

@property (strong, nonatomic) IBOutlet UIImageView *connerImageView; // 角标

- (void)initWithData:(NSDictionary *)dataDic;

@end
