//
//  ShangPinConnectView.h
//  com.threeti
//
//  Created by alan on 15/10/12.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShangPinConnectView : UIView
@property (nonatomic,strong) UIButton * lianJieBtn;
- (void)UpdateGoodsMessage:(GoodsInfoModel * )goodsInfo;
@end
