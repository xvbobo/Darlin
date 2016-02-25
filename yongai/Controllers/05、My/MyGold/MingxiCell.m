//
//  MingxiCell.m
//  com.threeti
//
//  Created by alan on 15/7/2.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import "MingxiCell.h"

@implementation MingxiCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        int with = (UIScreenWidth - 40)/2-10;
        NSArray * nameArr = @[@"日期",@"操作",@"数量"];
        for (int i = 0; i< 3; i++) {
            _lable = [[UILabel alloc] initWithFrame:CGRectMake(10+i*with, 10,200, 30)];
            _lable.text = nameArr[i];
            _lable.tag = 100+i;
            _lable.textColor = TEXT;
            _lable.font = [UIFont systemFontOfSize:13];
            [self.contentView addSubview:_lable];
            
            
        }
        UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, UIScreenWidth,0.5)];
        line.backgroundColor = LINE;
        [self.contentView addSubview:line];
    }
    
    return self;

}
- (void)cellWithModel:(NSDictionary *)model
{
    UILabel * lable1 = (UILabel*)[self viewWithTag:100];
    UILabel * lable2 = (UILabel*)[self viewWithTag:101];
    lable2.font = [UIFont systemFontOfSize:14];
    UILabel * lable3 = (UILabel*)[self viewWithTag:102];
    lable1.text = model[@"task_date"];
    lable2.text = model[@"task_code"];
    lable3.text  = model[@"gold_num"];
}
@end
