//
//  QDetailCell.m
//  com.threeti
//
//  Created by alan on 15/10/30.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "QDetailCell.h"

@implementation QDetailCell 
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView * lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 10)];
        lineView.backgroundColor = BJCLOLR;
        lineView.layer.borderColor = LINE.CGColor;
        lineView.layer.borderWidth = 0.5;
        [self addSubview:lineView];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 100, 20)];
        label.text = @"问题描述";
        label.textColor = BLACKTEXT;
        label.font = font(14);
        [self addSubview:label];
        self.textView = [[UITextField alloc] initWithFrame:CGRectMake(10, label.frame.origin.y+label.frame.size.height+10, UIScreenWidth - 80, 60)];
        self.textView.text = @"恍恍惚惚好";
//        self.textView.backgroundColor  =TEXT;
        self.textView.layer.masksToBounds = YES;
        self.textView.layer.cornerRadius = 5;
        self.textView.layer.borderWidth = 0.5;
        self.textView.layer.borderColor = LINE.CGColor;
        [self addSubview:self.textView];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
