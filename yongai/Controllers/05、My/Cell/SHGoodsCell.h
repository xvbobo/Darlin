//
//  SHGoodsCell.h
//  com.threeti
//
//  Created by alan on 15/10/29.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SHGoodsCellDelegate <NSObject>

- (void)shouHouFuWu:(CartListGoodsModel *) button withOrderModel:(OrderListModel *) orderMD;

@end
@interface SHGoodsCell : UITableViewCell
@property (nonatomic,assign) id <SHGoodsCellDelegate> delegate;
@property (nonatomic,strong) UIImageView * lineView;
@property (nonatomic,strong) CartListGoodsModel * listMd;
@property (nonatomic,strong) NSString * Order_sn;
@property (nonatomic,strong) NSString * Order_id;
@property (nonatomic,strong) NSString * Order_Status;
@property (nonatomic,strong) UIImageView * footerView;
@property (nonatomic,strong)OrderListModel * OrderModel;
- (void)initWithModel:(CartListGoodsModel*) model;
@end
