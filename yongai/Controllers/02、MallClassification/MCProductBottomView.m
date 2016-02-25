//
//  MCProductBottomView.m
//  Yongai
//
//  Created by Kevin Su on 14-11-12.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MCProductBottomView.h"
#import "QFControl.h"
@implementation MCProductBottomView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth+10, frame.size.height)];
        self.imageView1.userInteractionEnabled = YES;
        [self addSubview:self.imageView1];
        self.imageView2 = [[UIImageView alloc] initWithFrame:frame];
        self.imageView2.userInteractionEnabled = YES;
        self.imageView2.hidden = YES;
        [self addSubview:self.imageView2];
        UIButton * kefu = [QFControl createButtonWithFrame:CGRectMake(0,0, UIScreenWidth/6, frame.size.height) title:nil target:self action:@selector(kefuAction) tag:0];
        kefu.layer.borderColor = LINE.CGColor;
        kefu.layer.borderWidth = 0.5;
        self.kefuImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,30, 25)];
        self.kefuImage.center = CGPointMake(kefu.center.x, kefu.center.y-8);
        self.kefuImage.image = [UIImage imageNamed:@"客服彩色"];
       
        [self.imageView1 addSubview:self.kefuImage];
        [self.imageView1 addSubview:kefu];
        UILabel * label0 = [[UILabel alloc] initWithFrame:CGRectMake(0,30,UIScreenWidth/6, 15)];
        label0.textColor = BLACKTEXT;
        label0.text = @"客服";
        label0.font = [UIFont systemFontOfSize:11.0];
        label0.textAlignment = NSTextAlignmentCenter;
        [self.imageView1 addSubview:label0];
        self.showShopCartButton = [QFControl createButtonWithFrame:CGRectMake(kefu.frame.size.width,0, UIScreenWidth/6, frame.size.height) title:nil target:self action:@selector(showShopcartView) tag:0];
        self.shopcartCountImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 25)];
        self.shopcartCountImageView.center = CGPointMake(self.showShopCartButton.center.x, self.showShopCartButton.center.y-8);
        self.shopcartCountImageView.image = [UIImage imageNamed:@"购物车"];
        [self.imageView1 addSubview:self.shopcartCountImageView];
        self.shopcartCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.shopcartCountImageView.frame.origin.x+self.shopcartCountImageView.frame.size.width-8, self.shopcartCountImageView.frame.origin.y-3,13, 13)];
        self.shopcartCountLabel.hidden = YES;
        self.shopcartCountLabel.text = @"12";
        self.shopcartCountLabel.textAlignment = NSTextAlignmentCenter;
        self.shopcartCountLabel.font = [UIFont systemFontOfSize:8.0];
        self.shopcartCountLabel.textColor = [UIColor whiteColor];
        self.shopcartCountLabel.backgroundColor = beijing;
        self.shopcartCountLabel.layer.masksToBounds = YES;
        self.shopcartCountLabel.layer.cornerRadius = self.shopcartCountLabel.frame.size.width/2;
        [self.imageView1 addSubview:self.shopcartCountLabel];
        [self.imageView1 addSubview:self.showShopCartButton];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(self.showShopCartButton.frame.origin.x, self.shopcartCountImageView.frame.origin.y+self.shopcartCountImageView.frame.size.height+1, self.showShopCartButton.frame.size.width, 15)];
        label.textColor = BLACKTEXT;
        label.text = @"购物车";
        label.font = [UIFont systemFontOfSize:11.0];
        label.textAlignment = NSTextAlignmentCenter;
        [self.imageView1 addSubview:label];
        self.addShopCartButton = [QFControl createButtonWithFrame:CGRectMake(UIScreenWidth/3, 0, UIScreenWidth/3, frame.size.height) title:@"加入购物车" target:self action:@selector(addToShopcartAction) tag:0];
        self.addShopCartButton.backgroundColor = RGBACOLOR(255, 144, 46, 1);
        self.addShopCartButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [self.addShopCartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.imageView1 addSubview:self.addShopCartButton];
        self.buyButton = [QFControl createButtonWithFrame:CGRectMake(UIScreenWidth/3*2, 0, UIScreenWidth/3+5, frame.size.height) title:@"立即购买" target:self action:@selector(buyAction) tag:0];
        self.buyButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [self.buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.buyButton.backgroundColor = beijing;
        [self.imageView1 addSubview:self.buyButton];
        
        self.confirmAddButton = [QFControl createButtonWithFrame:CGRectMake(-1, 0, UIScreenWidth+2, frame.size.height) title:@"确认添加" target:self action:@selector(confirmAddAction) tag:0];
        self.confirmBuyButton = [QFControl createButtonWithFrame:CGRectMake(-1, 0, UIScreenWidth+2, frame.size.height) title:@"确认购买" target:self action:@selector(confirmBuyAction) tag:0];
        [self.confirmAddButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.confirmBuyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.confirmAddButton.backgroundColor = beijing;
        self.confirmBuyButton.backgroundColor = beijing;
        self.confirmAddButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
        self.confirmBuyButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [self addSubview:self.confirmBuyButton];
        [self addSubview:self.confirmAddButton];
        self.userInteractionEnabled = YES;

    }
    return self;
}

- (void)initDataWithDictionary:(NSDictionary *)dataDic{
    
    NSString *count = dataDic[@"cart_num"];
    if(![count isKindOfClass:[NSNull class]] && count.length > 0)
    {
        self.shopcartCountLabel.hidden = NO;
        self.shopcartCountLabel.text = dataDic[@"cart_num"];
    }
    else{
       self.shopcartCountLabel.text = @"0";
    }
    

    
}
- (void)kefuAction
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(kefuClick)]){
        
        [self.delegate kefuClick];
    }
}

/**
 *  加入购物车
 **/
- (void)addToShopcartAction{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(addToShopcartAction)]){
        
        [self.delegate addToShopcartAction];
    }
}

/**
 *  立即购买
 **/
- (void)buyAction{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(buyAction)]){
        
        [self.delegate buyAction];
    }
}

/**
 *  查看购物车
 **/
- (void)showShopcartView{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(showShopcartView)]){
        
        [self.delegate showShopcartView];
    }
}

/**
 *  确定添加
 **/
- (void)confirmAddAction{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(confirmAddAction)]){
        
        [self.delegate confirmAddAction];
    }
}

/**
 *  确定购买
 **/
- (void)confirmBuyAction{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(confirmBuyAction)]){
        
        [self.delegate confirmBuyAction];
    }
}

@end
