//
//  LoadingView.m
//  com.threeti
//
//  Created by alan on 15/12/1.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
//        self.loadViewbtn.frame = frame;
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        imageView.center = CGPointMake(self.center.x, self.center.y-imageView.frame.size.height/2);
        imageView.image = [UIImage imageNamed:@"加载"];
        [self addSubview:imageView];
        for (int i = 0; i< 2; i++) {
            UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.origin.y+imageView.frame.size.height+i*30, UIScreenWidth, 20)];
            lable.textAlignment = NSTextAlignmentCenter;
            lable.textColor = BLACKTEXT;
            lable.font = [UIFont systemFontOfSize:14.0];
            if (i == 0) {
                lable.text = @"网络君精疲力尽了，";
            }else {
                lable.text = @"试试再点一下...";
            }
            [self addSubview:lable];
        }
        self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0];
        
        
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
