//
//  RightView.m
//  com.threeti
//
//  Created by alan on 15/10/9.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "RightView.h"
#import "TTIFont.h"
@implementation RightView
{
//    UILabel * timeLabel;
//    UIImageView * RightHeadView;
    UIImageView * RightBackView;
    UILabel * goodsLabel;
    UILabel * goodsPrice;
    UILabel * nowPrice;
    UIImageView * goodImage;
    UIImageView * beijingView;
    UIImageView * sanjiao;
    CGFloat HeadW;

}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        beijingView = [[UIImageView alloc] init];
        beijingView.userInteractionEnabled = YES;
//        self.backgroundColor = beijing;
//        beijingView.backgroundColor = beijing;
        self.userInteractionEnabled = YES;
        self.shangPinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        HeadW = 40;
        [self createInterFace];
        [self shangPinView];
    }
    return self;
}
- (void)createInterFace
{
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake((UIScreenWidth - 100)/2, 0, 130, 20)];
//    _timeLabel.text = @"123";
    _timeLabel.layer.masksToBounds = YES;
    _timeLabel.layer.cornerRadius = 5;
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.backgroundColor = TEXT;
    _timeLabel.alpha = 0.5;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.textColor = [UIColor whiteColor];
    [beijingView addSubview:_timeLabel];
    _RightHeadView = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenWidth-60, 30, HeadW,HeadW)];
    _RightHeadView.layer.masksToBounds = YES;
    _RightHeadView.layer.cornerRadius = _RightHeadView.frame.size.width/2;
    [_RightHeadView setImageWithURL:[NSURL URLWithString:g_userInfo.user_photo] placeholderImage:[UIImage imageNamed:Default_UserHead]];
    _RightHeadView.backgroundColor = beijing;
    [beijingView addSubview:_RightHeadView];
    RightBackView = [[UIImageView alloc] initWithFrame:CGRectMake(55, 30,UIScreenWidth - 130,50)];
    RightBackView.userInteractionEnabled = YES;
    RightBackView.backgroundColor = RGBACOLOR(204, 220, 0, 1);
    RightBackView.layer.masksToBounds = YES;
    RightBackView.layer.cornerRadius = 10;
    RightBackView.layer.borderColor = LINE.CGColor;
    RightBackView.layer.borderWidth = 0.6;
    [beijingView addSubview:RightBackView];
    sanjiao = [[UIImageView alloc] initWithFrame:CGRectMake(_RightHeadView.frame.origin.x-20, _RightHeadView.frame.origin.y+_RightHeadView.frame.size.height/2-10, 13, 13)];
    sanjiao.image = [UIImage imageNamed:@"绿三角"];
    [beijingView addSubview:sanjiao];
    _contentLable = [[UILabel alloc] initWithFrame:CGRectMake(5,5, RightBackView.frame.size.width-10, RightBackView.frame.size.height)];
    _contentLable.numberOfLines = 0;
    _contentLable.textColor = BLACKTEXT;
    _contentLable.font = [UIFont systemFontOfSize:17];
    [RightBackView addSubview:_contentLable];
    _flower = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
              UIActivityIndicatorViewStyleGray];
//    _flower.hidden = YES;
//    [flower startAnimating];
    [beijingView addSubview:_flower];
    [self addSubview:beijingView];
   
//    [self addSubview:beijingView];
}
- (void)shangPinView
{
    goodImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
//    goodImage.backgroundColor = beijing;
    [RightBackView addSubview:goodImage];
    goodsLabel = [[UILabel alloc] initWithFrame:CGRectMake(goodImage.frame.origin.x+goodImage.frame.size.width+10, 10, UIScreenWidth - 130-25- goodImage.frame.size.width, 40)];
    goodsLabel.numberOfLines = 2;
    goodsLabel.font = [UIFont systemFontOfSize:13];
    goodsLabel.textColor = BLACKTEXT;
    [RightBackView addSubview:goodsLabel];
    goodsPrice = [[UILabel alloc] initWithFrame:CGRectMake(goodsLabel.frame.origin.x, goodsLabel.frame.origin.y+goodsLabel.frame.size.height+5, 50, 20)];
//    goodsPrice.backgroundColor = beijing;
    goodsPrice.textColor = beijing;
    goodsPrice.font = [UIFont systemFontOfSize:15];
    [RightBackView addSubview:goodsPrice];
    nowPrice = [[UILabel alloc] initWithFrame:CGRectMake(goodsPrice.frame.origin.x+goodsPrice.frame.size.width+10, goodsPrice.frame.origin.y, 50, 20)];
    nowPrice.textColor = TEXT;
    nowPrice.font = [UIFont systemFontOfSize:11];
    [RightBackView addSubview:nowPrice];
}
- (void)updataHeightAndWidth:(NSString *)contentText withIndex:(NSString *)lineNumber withIfTime:(BOOL)if_time
{
    self.shangPinBtn.hidden = YES;
//    self.shangPinBtn.enabled = NO;
    _contentLable.hidden = NO;
    goodsPrice.hidden = YES;
    goodsLabel.hidden = YES;
    goodImage.hidden = YES;
    nowPrice.hidden = YES;
    _contentLable.text = contentText;
//    CGSize  size = [contentText sizeWithFont:[UIFont systemFontOfSize:17]];
    CGFloat height = [TTIFont calHeightWithText:contentText font:[UIFont systemFontOfSize:17] limitWidth:UIScreenWidth - 130];
    CGFloat width = [TTIFont calWidthWithText:contentText font:[UIFont systemFontOfSize:17] limitWidth:UIScreenWidth - 130];
    if (width > UIScreenWidth - 130) {
        width = UIScreenWidth - 130;
    }
//    NSLog(@"size.width = %f,size.height = %f",size.width,size.height);
      _contentLable.frame = CGRectMake(10,10, width, height);
    
    //菊花视图
    NSLog(@"%f",UIScreenHeight);
//    CGFloat screenH = self.view.frame.size.height;
//    CGFloat height = [TTIFont calHeightWithText:str font:[UIFont systemFontOfSize:17] limitWidth:UIScreenWidth - 130];
//    if (screenH > 480) {
//        if (hidden == YES) {
//            return height + 20;
//        }else if (hidden == NO){
//            return height + 50;
//        }else{
//            return height + 40;
//        }
//        
//    }else{
//        if (hidden == YES) {
//            return height + 50;
//        }else{
//            return height + 80;
//        }
//        
//    }
    if (UIScreenHeight > 480) {
        if (if_time == YES){
            _RightHeadView.frame  = CGRectMake(UIScreenWidth-60,5,HeadW,HeadW);
            RightBackView.frame = CGRectMake(UIScreenWidth - width - 93,5, width+20, height);
        }else if (if_time == NO){
            _RightHeadView.frame  = CGRectMake(UIScreenWidth-60, 35, HeadW, HeadW);
            RightBackView.frame = CGRectMake(UIScreenWidth - width - 93,35, width+20, height);
            
        }

    }else{
        if (if_time == YES){
            _RightHeadView.frame  = CGRectMake(UIScreenWidth-60,5,HeadW,HeadW);
            RightBackView.frame = CGRectMake(UIScreenWidth - width - 93,5, width+20, height+20);
        }else if (if_time == NO){
            _RightHeadView.frame  = CGRectMake(UIScreenWidth-60, 35, HeadW, HeadW);
            RightBackView.frame = CGRectMake(UIScreenWidth - width - 93,35, width+20, height+20);
            
        }

    }

         sanjiao.frame = CGRectMake(_RightHeadView.frame.origin.x-20, _RightHeadView.frame.origin.y+_RightHeadView.frame.size.height/2-10, 13, 13);
    _flower.frame = CGRectMake(RightBackView.frame.origin.x-20,RightBackView.frame.origin.y+height/4+5, 15, 15);
    if (self.hide == YES) {
        _flower.alpha = 1;
        _flower.hidden = NO;
        [_flower startAnimating];
       
    }else{
        _flower.hidden = YES;
    }
    [UIView animateWithDuration:2 animations:^{
//        [_flower stopAnimating];
        _flower.alpha = 0;
    }];
    
  
    
}
- (void)UpDateShangPinMessage:(GoodsInfoModel*)goodsInfo withIfTime:(BOOL)hiden
{
    self.shangPinBtn.hidden = NO;
//    self.shangPinBtn.enabled = YES;
    goodsPrice.hidden = NO;
    goodsLabel.hidden = NO;
    goodImage.hidden = NO;
    nowPrice.hidden = NO;
    _contentLable.hidden = YES;
    NSString * prcie = [NSString stringWithFormat:@"￥%@",goodsInfo.price];
    CGFloat width1 = [TTIFont calWidthWithText:prcie font:[UIFont systemFontOfSize:15] limitWidth:20];
    goodsPrice.frame = CGRectMake(goodsLabel.frame.origin.x, goodsLabel.frame.origin.y+goodsLabel.frame.size.height+5,width1,20);
    CGFloat width2 = [TTIFont calWidthWithText:goodsInfo.market_price font:[UIFont systemFontOfSize:11] limitWidth:20];
     nowPrice.frame = CGRectMake(goodsPrice.frame.origin.x+goodsPrice.frame.size.width+10, goodsPrice.frame.origin.y,width2, 20);
    
    [goodImage setImageWithURL:[NSURL URLWithString:goodsInfo.img_url] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
    goodsLabel.text = goodsInfo.goods_name;
    
    goodsPrice.text = prcie;
    nowPrice.text = goodsInfo.market_price;
    if (hiden == YES){
        _RightHeadView.frame  = CGRectMake(UIScreenWidth-60,5,HeadW,HeadW);
       RightBackView.frame = CGRectMake(55,5,UIScreenWidth - 130,80);
    }else if (hiden == NO){
        _RightHeadView.frame  = CGRectMake(UIScreenWidth-60, 35, HeadW, HeadW);
        RightBackView.frame = CGRectMake(55, 30,UIScreenWidth - 130,80);

        
    }

//     _RightHeadView.frame  = CGRectMake(UIScreenWidth-60, 35, HeadW, HeadW);
//    RightBackView.frame = CGRectMake(55, 30,UIScreenWidth - 130,80);

    
    sanjiao.frame = CGRectMake(_RightHeadView.frame.origin.x-20, _RightHeadView.frame.origin.y+_RightHeadView.frame.size.height/2-10, 13, 13);
    
//    nowPrice.text = goodsInfo
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
