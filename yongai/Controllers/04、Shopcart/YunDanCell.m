//
//  YunDanCell.m
//  com.threeti
//
//  Created by alan on 15/12/1.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "YunDanCell.h"
#import "TTIFont.h"
@implementation YunDanCell
{
    UILabel * timeLabel;
    UILabel * detailLabel;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, UIScreenWidth - 20, 30)];
        timeLabel.textColor = BLACKTEXT;
        timeLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:timeLabel];
        detailLabel = [[UILabel alloc] init];
        detailLabel.numberOfLines = 0;
        detailLabel.textColor = BLACKTEXT;
        detailLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:detailLabel];
        self.layer.borderColor = LINE.CGColor;
        self.layer.borderWidth = 0.5;
    }
    return self;
}
- (void)initWithTime:(NSString *)timeStr andDetailString:(NSString *)detailString
{
    
    if ([timeStr rangeOfString:@"-"].location != NSNotFound) {
        NSString * shijian = @"2015-11-04";
        NSString * string1 = [timeStr substringWithRange:NSMakeRange(0, shijian.length)];
        NSString * string2 = [timeStr substringFromIndex:shijian.length];
        timeLabel.text = [NSString stringWithFormat:@"%@  %@",string1,string2];
    }else{
       timeLabel.text = timeStr;
    }
    if ([detailString isEqualToString:@""]) {
        return;
    }else{
    detailLabel.text = detailString;
        CGFloat detailabelH = [TTIFont calHeightWithText:detailString font:[UIFont systemFontOfSize:14.0] limitWidth:UIScreenWidth - 20];
        detailLabel.frame = CGRectMake(timeLabel.frame.origin.x, timeLabel.frame.origin.y+timeLabel.frame.size.height, UIScreenWidth - 20, detailabelH);
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
