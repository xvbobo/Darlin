//
//  RightView.h
//  com.threeti
//
//  Created by alan on 15/10/9.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RightView : UIView
@property (nonatomic,strong) UILabel * timeLabel;
@property (nonatomic,strong) UIImageView * RightHeadView;
@property (nonatomic,strong) NSString * Height;
@property (nonatomic,strong) UILabel * contentLable;
@property (nonatomic,strong) UIActivityIndicatorView *flower;//菊花视图
@property (nonatomic,strong) UIButton * shangPinBtn;
@property (nonatomic,assign) BOOL hide;
@property (nonatomic,assign) BOOL if_time;
- (void)updataHeightAndWidth:(NSString *) contentText withIndex:(NSString *)lineNumber withIfTime:(BOOL)if_time;
- (void)UpDateShangPinMessage:(GoodsInfoModel*)goodsInfo withIfTime:(BOOL)hiden;

@end
