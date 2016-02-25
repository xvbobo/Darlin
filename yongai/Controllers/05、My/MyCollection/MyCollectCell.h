//
//  MyCollectCell.h
//  Yongai
//
//  Created by myqu on 14/11/7.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  我的收藏cell
 */
@interface MyCollectCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *goodsImgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *isZengTagImgView;
@property (strong, nonatomic) IBOutlet UIImageView *isDownTagImgView;
@property (strong, nonatomic) IBOutlet UILabel *marketPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *shiChangPrice;


@property (nonatomic ,strong) GoodModel *goodsInfo;
@end
