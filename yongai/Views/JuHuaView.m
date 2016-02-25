//
//  JuHuaView.m
//  com.threeti
//
//  Created by alan on 15/11/23.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "JuHuaView.h"

@implementation JuHuaView
{
   UIActivityIndicatorView *flower;//菊花视图
}
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        flower = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        flower.frame = CGRectMake(0, 0, 20, 20);
        flower.center = self.center;
        [self addSubview:flower];
    }
    return self;
}
- (void)stopView
{
    [flower stopAnimating];
}
- (void)startView{
    [flower startAnimating];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
