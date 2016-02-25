//
//  LingChenHeadView.h
//  com.threeti
//
//  Created by alan on 15/5/20.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LingChenHeadViewDelegate <NSObject>

- (void)jinBiAction;
- (void)zhuCeAction;
- (void)headBtn;
- (void)moneyBtn;

@end
@interface LingChenHeadView : UIView
@property (assign,nonatomic) id <LingChenHeadViewDelegate> delegate;
@property (strong, nonatomic)  UIImageView *headImgView;
@property (strong, nonatomic)  UIButton *button2;
@property (strong, nonatomic)  UILabel *zhuCeLable;
@property (strong, nonatomic)  UILabel * lable1;
@property (weak, nonatomic) IBOutlet UIButton *dengLuBtn;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *moneyView;
@property (strong,nonatomic) UIButton * moneyBtn;

@end
