//
//  ReturnBackViewController.h
//  com.threeti
//
//  Created by alan on 15/11/9.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReturnBackViewController : UIViewController
@property (nonatomic,strong) NSString * order_id;
@property (nonatomic,strong)CartListGoodsModel * model;
@property (nonatomic,strong) NSString * order_sn;
@property (nonatomic,strong) NSString * order_Status;
@property (nonatomic,strong) UIImage * image0;
@property (nonatomic,strong) UIImage * image1;
@property (nonatomic,strong) UIImage * image2;
@property (nonatomic,strong) NSString * number;
@property (nonatomic,strong) NSString * serveType;
@property (nonatomic,strong) NSString * descript;
@end
