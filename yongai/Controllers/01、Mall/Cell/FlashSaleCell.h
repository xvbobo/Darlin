//
//  FlashSaleCell.h
//  Yongai
//
//  Created by Kevin Su on 14/11/19.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FlashSaleDelegate <NSObject>

- (void)imageClick:(NSString *)good_id;

@end
//限时销售
@interface FlashSaleCell : UITableViewCell
@property(assign,nonatomic) id <FlashSaleDelegate>delegate;
@property (strong ,nonatomic) NSString * stringTime;
@property (strong,nonatomic) UILabel * labelTime;
@property(assign,nonatomic) BOOL Yes;
- (void)initWithArray:(NSArray *)array;
- (void)createEndTime:(NSString*)endTime;
@end
