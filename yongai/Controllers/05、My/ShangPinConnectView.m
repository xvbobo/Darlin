//
//  ShangPinConnectView.m
//  com.threeti
//
//  Created by alan on 15/10/12.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "ShangPinConnectView.h"
#import "CrosslineLabel.h"
#import "TTIFont.h"
@implementation ShangPinConnectView
{
    UIImageView * imageViewGood;
    UILabel * goodsName;
    UILabel * goodsP;
    CrosslineLabel * goodsYP;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
       imageViewGood = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        imageViewGood.backgroundColor = BJCLOLR;
        goodsName = [[UILabel alloc] initWithFrame:CGRectMake(imageViewGood.frame.origin.x+imageViewGood.frame.size.width+10, imageViewGood.frame.origin.y, UIScreenWidth/3*2, 50)];
        goodsName.numberOfLines = 2;
        goodsName.font = [UIFont systemFontOfSize:17];
        goodsName.textColor = BLACKTEXT;
        goodsP = [[UILabel alloc] initWithFrame:CGRectMake(goodsName.frame.origin.x,goodsName.frame.origin.y+goodsName.frame.size.height, 60, 20)];
        goodsP.textColor = beijing;
        goodsP.font = [UIFont systemFontOfSize:17];
        goodsYP = [[CrosslineLabel alloc] initWithFrame:CGRectMake(goodsP.frame.origin.x+goodsP.frame.size.width,goodsName.frame.origin.y+goodsName.frame.size.height, 60,20)];
        goodsYP.textColor = TEXT;
        goodsYP.font = [UIFont systemFontOfSize:15];
        _lianJieBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lianJieBtn.frame = CGRectMake(goodsP.frame.origin.x,frame.size.height - 30, 100, 25);
        _lianJieBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _lianJieBtn.layer.masksToBounds = YES;
        _lianJieBtn.layer.cornerRadius = 5;
        _lianJieBtn.layer.borderColor = beijing.CGColor;
        _lianJieBtn.layer.borderWidth = 1;
        [_lianJieBtn setTitle:@"发送链接" forState:UIControlStateNormal];
        [_lianJieBtn setTitleColor:beijing forState:UIControlStateNormal];
        UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, UIScreenWidth, 0.5)];
        line.backgroundColor = LINE;
        [self addSubview:line];
        [self addSubview:_lianJieBtn];
        [self addSubview:goodsYP];
        [self addSubview:goodsP];
        [self addSubview:goodsName];
        [self addSubview:imageViewGood];
        self.userInteractionEnabled = YES;
    }
    return self;
}
- (void)UpdateGoodsMessage:(GoodsInfoModel * )goodsInfo
{
    [imageViewGood setImageWithURL:[NSURL URLWithString:goodsInfo.img_url] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
    NSString * prcie = [NSString stringWithFormat:@"￥%@",goodsInfo.price];
    CGFloat width1 = [TTIFont calWidthWithText:prcie font:[UIFont systemFontOfSize:17] limitWidth:20];
    goodsP.frame = CGRectMake(goodsName.frame.origin.x,goodsName.frame.origin.y+goodsName.frame.size.height,width1, 20);
    CGFloat width2 = [TTIFont calWidthWithText:goodsInfo.market_price font:[UIFont systemFontOfSize:15] limitWidth:20];
    goodsYP.frame = CGRectMake(goodsP.frame.origin.x+goodsP.frame.size.width+10,goodsName.frame.origin.y+goodsName.frame.size.height,width2,20);
    goodsName.text = goodsInfo.goods_name;
    goodsP.text = [NSString stringWithFormat:@"￥%@",goodsInfo.price];
    goodsYP.text = goodsInfo.market_price;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
