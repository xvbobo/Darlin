//
//  KeFuCell.h
//  com.threeti
//
//  Created by alan on 15/10/12.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol KeFuCellDelegate <NSObject>
- (void)goodsAction:(UIButton *)button;
@end
@interface KeFuCell : UITableViewCell
//1,用户，0客服
@property (nonatomic,assign) id <KeFuCellDelegate> delegate;
- (void)cellWithMessage:(NSDictionary *) message withIndex:(NSString*)lineNumer andTimeStr:(NSString *)inserterTime;
@property (nonatomic,strong) UIButton * goodsBtn;
@property (nonatomic,assign) BOOL clicked;
@property (nonatomic,assign) BOOL shuaXin;
@end
