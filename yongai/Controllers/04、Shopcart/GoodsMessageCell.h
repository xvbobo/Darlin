//
//  GoodsMessageCell.h
//  com.threeti
//
//  Created by alan on 15/11/2.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsMessageCell : UITableViewCell
//UIImageView * goodPic;
//UILabel * goodLabel;
@property (nonatomic,strong)UIImageView * goodPic;
@property (nonatomic,strong)UILabel * goodLabel;
-(void)initDataWithInfo:(CartListGoodsModel *)goodsInfo;
@end
