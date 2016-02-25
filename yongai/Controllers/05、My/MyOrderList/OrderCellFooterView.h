//
//  OrderCellFooterView.h
//  Yongai
//
//  Created by Kevin Su on 14/11/30.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataButton.h"

/// 我的订单页面  订单状态view
@interface OrderCellFooterView : UIView

@property (strong, nonatomic) IBOutlet UILabel *orderStateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *orderStatusImg; 

@property (strong, nonatomic) IBOutlet UILabel *stateLabel;

-(void)initDataWithInfo:(OrderListModel *)dataInfo index:(NSInteger)index;
@end
