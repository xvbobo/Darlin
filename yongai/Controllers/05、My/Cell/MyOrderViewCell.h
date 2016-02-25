//
//  MyOrderViewCell.h
//  com.threeti
//
//  Created by alan on 15/10/29.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyOrderViewCellDelegate <NSObject>

- (void)DingDanLieBiaoAll;
- (void)DingDanLieBiaoFenLei:(UIButton *)button;

@end
@interface MyOrderViewCell : UITableViewCell
@property (nonatomic,assign) id <MyOrderViewCellDelegate> delegate;
- (void)initWithDict:(NSDictionary *) dict;
@end
