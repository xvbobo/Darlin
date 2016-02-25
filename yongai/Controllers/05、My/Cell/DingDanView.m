//
//  DingDanView.m
//  com.threeti
//
//  Created by alan on 15/10/29.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "DingDanView.h"

@implementation DingDanView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.image = [[UIImageView alloc] init];
        [self addSubview:self.image];
        self.label = [[UILabel alloc] init];
        self.nameLabel = [[UILabel alloc] init];
        [self addSubview:self.nameLabel];
        [self addSubview:self.label];
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
