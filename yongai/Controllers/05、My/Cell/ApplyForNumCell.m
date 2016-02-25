//
//  ApplyForNumCell.m
//  com.threeti
//
//  Created by alan on 15/10/30.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "ApplyForNumCell.h"

@implementation ApplyForNumCell
{
    UILabel * numLabel;
    int number;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        number = 1;
        UIImageView * lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 10)];
        lineView.backgroundColor = BJCLOLR;
        lineView.layer.borderColor = LINE.CGColor;
        lineView.layer.borderWidth = 0.5;
        [self addSubview:lineView];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 100, 20)];
        label.text = @"申请数量";
        label.textColor = BLACKTEXT;
        label.font = font(14);
        [self addSubview:label];
        CGFloat leftJian = 10;
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(leftJian, label.frame.origin.y+label.frame.size.height+10, 30, 30);
        [btn setTitle:@"➖" forState:UIControlStateNormal];
        btn.backgroundColor = BJCLOLR;
        btn.tag = 100;
        [btn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        numLabel = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.origin.x+btn.frame.size.width+5, btn.frame.origin.y, 30, 30)];
        numLabel.text = @"1";
        numLabel.layer.borderColor = LINE.CGColor;
        numLabel.layer.borderWidth = 0.5;
        numLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:numLabel];
        UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = CGRectMake(numLabel.frame.origin.x+numLabel.frame.size.width+5 ,btn.frame.origin.y, 30, 30);
        btn2.tag = 101;
        [btn2 setTitle:@"➕" forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn2.backgroundColor = beijing;
        [btn2 addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn2];
        UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(leftJian, btn.frame.size.height+btn.frame.origin.y+5, UIScreenWidth - 50, 30)];
        label1.text = @"您最多可提交数量为1个";
        label1.textColor = TEXT;
        label1.font = [UIFont systemFontOfSize:13.0];
        [self addSubview:label1];
    }
    return self;
}
- (void)action:(UIButton *)button
{
    if (button.tag == 100) {
        //－
        if (number != 1) {
             number -- ;
            numLabel.text = [NSString stringWithFormat:@"%d",number];
        }
       
    }else if (button.tag == 101){
        //加
        number ++;
        numLabel.text = [NSString stringWithFormat:@"%d",number];
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
