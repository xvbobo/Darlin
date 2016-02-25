//
//  CartEmptyView.m
//  Yongai
//
//  Created by arron on 14/11/5.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "CartEmptyView.h"

@implementation CartEmptyView
//去逛逛
- (void)awakeFromNib {
    self.titleLabel.textColor = RGBACOLOR(108, 97, 85, 1);
    [self.carBtn setBackgroundColor:beijing];
    self.carBtn.layer.masksToBounds = YES;
    self.carBtn.layer.cornerRadius = 5;
    [self.carBtn setTitle:@"去逛逛" forState:UIControlStateNormal];
    self.carBtn.titleLabel.textColor = [UIColor whiteColor];

}


- (IBAction)doGotoMallToBuy:(UIButton *)sender
{
    
    if(self.emptyDelegate != nil && [self.emptyDelegate respondsToSelector:@selector(goToMall)])
    {
        [self.emptyDelegate goToMall];
    }
}
@end
