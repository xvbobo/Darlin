//
//  SHServeController.h
//  com.threeti
//
//  Created by alan on 15/10/29.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHServeController : UIViewController
@property (nonatomic,strong)CartListGoodsModel * model;
@property (nonatomic,strong) NSString * order_sn;
@property (nonatomic,strong) NSString * order_id;
@property (nonatomic,strong) NSString * order_Status;
@property (nonatomic,strong) NSString * formTitle;
@end
