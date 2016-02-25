//
//  CacheView.m
//  Yongai
//
//  Created by wangfang on 14/11/18.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "CacheView.h"

@implementation CacheView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    
    UserInfo *info = [[LocalStoreManager shareInstance] getValueFromDefaultWithKey:DefaultKey_PeepPassword];
    if (info.bRememberPwd == NO) {
        
        // 默认
        self.button1.selected = YES;
        self.button2.selected = NO;
    }
    else
    {
        // 关闭
        self.button1.selected = NO;
        self.button2.selected = YES;
    }
    self.sureButton.backgroundColor = beijing;
    [self.sureButton setTitle:@"确认" forState:UIControlStateNormal];
    self.sureButton.titleLabel.textColor = [UIColor whiteColor];
}

- (IBAction)changeBtn:(id)sender {
    
    if([self.delegate respondsToSelector:@selector(changeCacheViewBtn:)])
    {
        [self.delegate changeCacheViewBtn:sender];
    }
}

@end
