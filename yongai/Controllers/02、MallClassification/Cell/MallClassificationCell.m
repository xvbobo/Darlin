//
//  MallClassificationCell.m
//  Yongai
//
//  Created by Kevin Su on 14-10-29.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MallClassificationCell.h"

@implementation MallClassificationCell
{
    UILabel * label;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}
- (void)awakeFromNib {
 
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)initDataWithArray:(NSArray *)dataArray
{
    int with1 = (UIScreenWidth-40)/3;
    for (int i = 0; i< dataArray.count; i++) {
        NSDictionary * dict = dataArray[i];
        UIImageView * backimage = [[UIImageView alloc] initWithFrame:CGRectMake(10+i%3*(with1+10), 10+i/3*(with1+45), with1, with1+35)];
        backimage.userInteractionEnabled = YES;
        backimage.backgroundColor = [UIColor whiteColor];
        UIImageView * pic = [[UIImageView alloc]initWithFrame:CGRectMake(20,10, with1-40, with1-40)];
        [pic setImageWithURL: [NSURL URLWithString:dict[@"logo"]] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
        UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(0, pic.frame.origin.y+pic.frame.size.height+10,with1, 18)];
        name.text = dict[@"name"];
        name.textColor = BLACKTEXT;
        name.textAlignment = NSTextAlignmentCenter;
        
        [backimage addSubview:name];
        UILabel * detail = [[UILabel alloc] initWithFrame:CGRectMake(0, name.frame.origin.y+name.frame.size.height+10, name.frame.size.width, 15)];
        detail.text = dict[@"desc"];
        detail.textColor = TEXT;
        
        detail.textAlignment = NSTextAlignmentCenter;
        [backimage addSubview:detail];
        [backimage addSubview:pic];
        name.font = font(17);
        detail.font = [UIFont systemFontOfSize:15];

        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = pic.frame;
        NSString * str = dict[@"id"];
        btn.tag = str.integerValue;
        btn.titleLabel.text = dict[@"name"];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents: UIControlEventTouchUpInside];
        [backimage addSubview:btn];
        [self.contentView addSubview:backimage];
    }
}
- (void)btnAction:(UIButton * )button
{
    NSString * str = [NSString stringWithFormat:@"%ld",button.tag];
//    NSLog(@"%@",(int)button.tag);
    if ([self.delegate respondsToSelector:@selector(imageClicked: withName:)]) {
        [self.delegate imageClicked:str withName:button.titleLabel.text];
    }
}
- (void)initDataWithDictionary:(NSDictionary *)dataDic{
    
    [self.picImageView setImageWithURL:[NSURL URLWithString:dataDic[@"logo"]] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
    self.ptitleLabel.text = dataDic[@"name"];
    self.pdescLabel.text = dataDic[@"desc"];
}

@end
