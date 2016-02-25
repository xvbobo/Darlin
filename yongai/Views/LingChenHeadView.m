//
//  LingChenHeadView.m
//  com.threeti
//
//  Created by alan on 15/5/20.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import "LingChenHeadView.h"
//#import "ExchangeCenterViewController.h"
#define space 80
#define With 90
@implementation LingChenHeadView
- (instancetype)init
{
    if (self = [super init]) {
        CGRect rect = CGRectMake(0, 0,UIScreenWidth, (UIScreenWidth*330)/720);
        UIImageView * imageView = [[UIImageView alloc ] init];
        imageView.backgroundColor = RGBACOLOR(255, 97, 46, 1);
        imageView.frame = rect;
        imageView.userInteractionEnabled = YES;
        UIButton * headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headBtn.frame = CGRectMake(0,0, With, With);
        [headBtn addTarget:self action:@selector(headBtnAction) forControlEvents:UIControlEventTouchUpInside];
        self.headImgView = [[UIImageView alloc] init];
        self.headImgView.userInteractionEnabled = YES;
        self.headImgView.frame = CGRectMake(30, rect.size.height - 145, With, With);
        [self.headImgView addSubview:headBtn];
        UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = CGRectMake(UIScreenWidth - 30-With, self.headImgView.frame.origin.y, With, With);
         [button1 setBackgroundImage:[UIImage imageNamed:@"金币1"] forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(jinBiClick) forControlEvents:UIControlEventTouchUpInside];
        
        [imageView addSubview:self.headImgView];
        [imageView addSubview:button1];
        self.button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button2.frame = CGRectMake(self.headImgView.frame.origin.x+10, self.headImgView.frame.origin.y+With+10, 80, 25);
        [self.button2 addTarget:self action:@selector(zhuceClick) forControlEvents:UIControlEventTouchUpInside];
        [self.button2 setTitle:@"注册/登录" forState:UIControlStateNormal];
        self.button2.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.button2 setTitleColor:RGBACOLOR(255, 255, 255, 1) forState:UIControlStateNormal];
        [imageView addSubview:self.button2];
        self.zhuCeLable = [[UILabel alloc ] init];
        self.zhuCeLable.text  = @"加圈子发帖得金币哦，发的越多得的越多!";
        self.zhuCeLable.textColor = [UIColor whiteColor];
        self.zhuCeLable.font = font(13);
        [imageView addSubview:self.zhuCeLable];
        UIImageView * moneyView = [[UIImageView alloc ] init];
        moneyView.center = imageView.center;
        moneyView.frame = CGRectMake(self.headImgView.center.x+With/4-15, self.headImgView.frame.origin.y+With/6,button1.frame.origin.x-self.headImgView.frame.origin.x-With/4, With/1.5);
        moneyView.userInteractionEnabled = YES;
        moneyView.backgroundColor= RGBACOLOR(255, 140, 103, 0.74);
        [imageView insertSubview:moneyView belowSubview:self.headImgView];
        self.moneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.moneyBtn.frame = CGRectMake(0, 0, moneyView.frame.size.width, moneyView.frame.size.height);
        [self.moneyBtn addTarget:self action:@selector(moneyBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [moneyView addSubview:self.moneyBtn];
         UILabel * label = [[UILabel alloc ] init];
        if (UIScreenWidth > 320) {
            label.frame = CGRectMake(self.headImgView.frame.origin.x+With/3, imageView.frame.origin.y+4, 100, 25);
            self.zhuCeLable.frame = CGRectMake(self.button2.frame.origin.x+30,self.button2.frame.origin.y+10,UIScreenWidth, 25);
        }else{
            self.zhuCeLable.frame = CGRectMake(self.button2.frame.origin.x+10,self.button2.frame.origin.y+10,UIScreenWidth, 25);
            label.frame = CGRectMake(self.headImgView.frame.origin.x, imageView.frame.origin.y+4, 100, 25);
        }
        label.text = @"您 的 财 富 值";
        label.font = font(14);
        label.textColor = [UIColor whiteColor];
        [moneyView addSubview:label];
        
        
        self.lable1 = [[UILabel alloc ] init];
        self.lable1.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y+30, label.frame.size.width, label.frame.size.height);
        self.lable1.text = @"0  金 币";
        self.lable1.font = font(14);
        self.lable1.textColor = [UIColor whiteColor];
        [moneyView addSubview:self.lable1];
        [self addSubview:imageView];
    }
    return self;
}
- (void)jinBiClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jinBiAction)]) {
        [self.delegate jinBiAction];
    }
}
- (void)zhuceClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(zhuCeAction)]) {
        [self.delegate zhuCeAction];
    }
}
-(void)headBtnAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(headBtn)]) {
        [self.delegate headBtn];
    }
}
- (void)moneyBtnAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(moneyBtn)]) {
        [self.delegate moneyBtn];
    }
}
@end
