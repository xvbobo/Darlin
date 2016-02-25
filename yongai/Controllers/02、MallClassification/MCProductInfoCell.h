//
//  MCProductInfoCell.h
//  Yongai
//
//  Created by Kevin Su on 14-11-10.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//
//  商品信息
#import <UIKit/UIKit.h>

@interface MCProductInfoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *pDescLabel;

@property (strong, nonatomic) IBOutlet UILabel *preferentialLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsMessage;
 

-(void)initDataWithInfo:()info;

@end
