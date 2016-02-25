//
//  UpDatePicCell.m
//  com.threeti
//
//  Created by alan on 15/10/30.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "UpDatePicCell.h"
@implementation UpDatePicCell
{
    UIButton * btn;
    CGFloat width;
    int number;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        number = 0;
        width = (UIScreenWidth - 50)/4;
        UIImageView * lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 10)];
        lineView.backgroundColor = BJCLOLR;
        lineView.layer.borderColor = LINE.CGColor;
        lineView.layer.borderWidth = 0.5;
        [self addSubview:lineView];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 100, 20)];
        label.text = @"上传图片";
        label.textColor = BLACKTEXT;
        label.font = font(14);
        [self addSubview:label];
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(10, label.frame.origin.y+label.frame.size.height+10, width, width)];
        image.backgroundColor = BJCLOLR;
        [self addSubview:image];
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame  =CGRectMake(image.frame.origin.x+width+10, image.frame.origin.y, width, width);
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 40;
        [btn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = BJCLOLR;
        [self addSubview:btn];
       
    }
    return self;
}
- (void)action:(UIButton *)button
{
    number ++;
    if (number < 3) {
        btn.frame = CGRectMake(10+width+number*(width+10), button.frame.origin.y, width, width);
    }
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
