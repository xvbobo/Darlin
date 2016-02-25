//
//  MCProductSpecCell.m
//  Yongai
//
//  Created by Kevin Su on 14-11-10.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MCProductSpecCell.h"

@implementation MCProductSpecCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView * lineView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, UIScreenWidth, 0.5)];
        lineView.backgroundColor = LINE;
        [self addSubview:lineView];

        self.guiGeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.frame.size.height/2-10, 40, 20)];
        self.guiGeLabel.text = @"规格";
        self.guiGeLabel.textColor = TEXT;
        self.guiGeLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.guiGeLabel];
        self.specLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.guiGeLabel.frame.origin.x+30+10,self.guiGeLabel.frame.origin.y,UIScreenWidth - 10 - 40 - 30, 20)];
        self.specLabel.textColor = BLACKTEXT;
        self.specLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.specLabel];
        UIImageView * rightView = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenWidth-20,self.guiGeLabel.frame.origin.y+2,8,15)];
        rightView.image = [UIImage imageNamed:@"common_cell_right_point"];
        [self.contentView addSubview:rightView];
//        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

@end
