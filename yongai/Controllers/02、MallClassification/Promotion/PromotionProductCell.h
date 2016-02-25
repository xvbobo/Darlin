//
//  PromotionProductCell.h
//  Yongai
//
//  Created by Kevin Su on 14-11-12.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//
//  赠品商品
#import <UIKit/UIKit.h>

@interface PromotionProductCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *gPicImageView;

@property (strong, nonatomic) IBOutlet UILabel *gNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *gPriceLabel;

@property (strong, nonatomic) IBOutlet UILabel *gAmountLabel;

- (void)initDataWithDic:(NSDictionary *)dataDic;
@end
