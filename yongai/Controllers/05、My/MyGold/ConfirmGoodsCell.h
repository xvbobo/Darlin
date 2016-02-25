//
//  ConfirmGoodsCell.h
//  Yongai
//
//  Created by myqu on 14/11/13.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  确认兑换页面的商品信息cell
 */
@interface ConfirmGoodsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (strong, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *goodsGoldLabel;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UILabel *goodsDetialLabel;

@end
