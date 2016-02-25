//
//  leftView.m
//  com.threeti
//
//  Created by alan on 15/10/8.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "leftView.h"
#import "TTIFont.h"
@implementation leftView
{
   
    UIImageView * LetfBackView;
    UIImageView * sanjiao;
    CGFloat headW;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createInterFace];
        headW = 40;
    }
    return self;
}
- (void)createInterFace
{
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake((UIScreenWidth - 100)/2, 0, 110, 20)];
//    _timeLabel.text = @"123";
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.layer.masksToBounds = YES;
    _timeLabel.layer.cornerRadius = 5;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.backgroundColor = TEXT;
    _timeLabel.alpha = 0.5;
    _timeLabel.textColor = [UIColor whiteColor];
    [self addSubview:_timeLabel];
    _LeftHeadView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30,headW,headW)];
    _LeftHeadView.layer.masksToBounds = YES;
    _LeftHeadView.layer.cornerRadius = 20;
    _LeftHeadView.backgroundColor = beijing;
    [self addSubview:_LeftHeadView];
    LetfBackView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 30, UIScreenWidth - 130, 50)];
    LetfBackView.backgroundColor = [UIColor whiteColor];
    LetfBackView.layer.masksToBounds = YES;
    LetfBackView.layer.cornerRadius = 10;
    LetfBackView.layer.borderColor = LINE.CGColor;
    LetfBackView.layer.borderWidth = 0.6;
    [self addSubview:LetfBackView];
   sanjiao = [[UIImageView alloc] initWithFrame:CGRectMake(70, _LeftHeadView.frame.origin.y+_LeftHeadView.frame.size.height/2-10, 13, 13)];
    sanjiao.image = [UIImage imageNamed:@"白三角"];
    [self addSubview:sanjiao];
    _contentLable = [[UILabel alloc] initWithFrame:CGRectMake(5,5, LetfBackView.frame.size.width-10, LetfBackView.frame.size.height)];
    _contentLable.numberOfLines = 0;
    _contentLable.textColor = BLACKTEXT;
    _contentLable.font = [UIFont systemFontOfSize:17];
    [LetfBackView addSubview:_contentLable];
}
- (void)updataHeightAndWidth:(NSString *)contentText withIfTime:(BOOL)if_time
{
    CGSize  size = [contentText sizeWithFont:[UIFont systemFontOfSize:17]];
    CGFloat height = [TTIFont calHeightWithText:contentText font:[UIFont systemFontOfSize:17] limitWidth:UIScreenWidth - 130];
    CGFloat width = [TTIFont calWidthWithText:contentText font:[UIFont systemFontOfSize:17] limitWidth:UIScreenWidth - 130];
    if (width > UIScreenWidth - 130) {
        width = UIScreenWidth - 130;
    }
    if (UIScreenHeight > 480) {
        if (if_time == YES){
            _LeftHeadView.frame  = CGRectMake(15,5, headW, headW);
            LetfBackView.frame = CGRectMake(70,5, width+20, height);
        }else if (if_time == NO){
            _LeftHeadView.frame  = CGRectMake(15,35, headW, headW);
            LetfBackView.frame = CGRectMake(70, 35, width+20, height);
            
        }
        
    }else{
        if (if_time == YES){
            _LeftHeadView.frame  = CGRectMake(15,5, headW, headW);
            LetfBackView.frame = CGRectMake(70,5, width+20, height+20);
        }else if (if_time == NO){
            _LeftHeadView.frame  = CGRectMake(15,35, headW, headW);
            LetfBackView.frame = CGRectMake(70, 35, width+20, height+20);
            
        }
        
    }

//    if (if_time == YES){
//        _LeftHeadView.frame  = CGRectMake(15,5, headW, headW);
//        LetfBackView.frame = CGRectMake(70,5, width+20, height);
//    }else if (if_time == NO){
//        _LeftHeadView.frame  = CGRectMake(15,35, headW, headW);
//       LetfBackView.frame = CGRectMake(70, 35, width+20, height);
//        
//    }
    sanjiao.frame = CGRectMake(60, _LeftHeadView.frame.origin.y+_LeftHeadView.frame.size.height/2-10, 13, 13);
    NSLog(@"size.width = %f,size.height = %f",size.width,size.height);
//    LetfBackView.frame = CGRectMake(80, 30, width+20, height);
    _contentLable.frame = CGRectMake(10,10, width, height);
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
