//
//  DingDanHaoViewCell.m
//  com.threeti
//
//  Created by alan on 15/10/29.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "DingDanHaoViewCell.h"
#import "TTIFont.h"
@implementation DingDanHaoViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat width = [TTIFont calWidthWithText:@"订单号：2015100968664" font:[UIFont systemFontOfSize:15.0] limitWidth:25];
        self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,5, width, 25)];
        self.numberLabel.textColor = BLACKTEXT;
        self.numberLabel.text = @"订单号：2015100968664";
        self.numberLabel.textAlignment = NSTextAlignmentLeft;
        self.numberLabel.font = [UIFont systemFontOfSize:15.0];
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.numberLabel.frame.origin.y+self.numberLabel.frame.size.height, UIScreenWidth, 20)];
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        self.timeLabel.textColor = TEXT;
        self.timeLabel.text = @"下单时间：2015-10-09 14：05：37";
        self.timeLabel.font = [UIFont systemFontOfSize:15.0];
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(UIScreenWidth-120,5, 100, 25)];
        self.statusLabel.text = @"等待确认收货";
        self.statusLabel.textAlignment = NSTextAlignmentRight;
        self.statusLabel.textColor = beijing;
        self.statusLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.numberLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.statusLabel];
        _lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0,59.5, UIScreenWidth,0.5)];
        _lineView.backgroundColor = LINE;
        [self addSubview:_lineView];
//        self.layer.borderColor = LINE.CGColor;
//        self.layer.borderWidth = 0.5;
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
