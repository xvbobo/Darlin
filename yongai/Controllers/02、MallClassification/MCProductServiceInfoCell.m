//
//  MCProductServiceInfoCell.m
//  Yongai
//
//  Created by Kevin Su on 14-11-10.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MCProductServiceInfoCell.h"


@implementation MCProductServiceInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel * labelFu = [[UILabel alloc] initWithFrame:CGRectMake(10,self.frame.size.height/2-10, 30, 20)];
        labelFu.textColor = TEXT;
        labelFu.text = @"服务";
        labelFu.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:labelFu];
        
        
        UIImageView * imageView0 = [[UIImageView alloc] initWithFrame:CGRectMake(labelFu.frame.origin.x+labelFu.frame.size.width+5, labelFu.frame.origin.y+5, 12, 12)];
        imageView0.image = [UIImage imageNamed:@"货到付款1"];
        UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(imageView0.frame.origin.x+imageView0.frame.size.width+5,labelFu.frame.origin.y+3, 60, 15)];
        label1.text = @"货到付款";
        label1.textColor = beijing;
        label1.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:label1];
        [self.contentView addSubview:imageView0];
        
        
        UIImageView * imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(label1.frame.origin.x+label1.frame.size.width+5, labelFu.frame.origin.y+5,12,12)];
        imageView1.image = [UIImage imageNamed:@"在线支付奖励金币1"];
        UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(imageView1.frame.origin.x+imageView1.frame.size.width+5,labelFu.frame.origin.y+3, 150, 15)];
        label2.text = @"在线支付奖励金币";
        label2.textColor = beijing;
        label2.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:label2];
        [self.contentView addSubview:imageView1];
        UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(10,self.frame.size.height, UIScreenWidth, 0.5)];
        line.backgroundColor = LINE;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:line];
        UIImageView * line1 = [[UIImageView alloc] initWithFrame:CGRectMake(10,0, UIScreenWidth, 0.5)];
        line1.backgroundColor = LINE;
        [self.contentView addSubview:line1];
    }
    return self;
}


@end
