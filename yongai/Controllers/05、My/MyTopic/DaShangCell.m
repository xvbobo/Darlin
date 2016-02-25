//
//  DaShangCell.m
//  com.threeti
//
//  Created by alan on 15/8/28.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import "DaShangCell.h"

@implementation DaShangCell
{
    UIImageView * headImage;
    UILabel * nameLable;
    UILabel * jinbiLabel;
    UIImageView * jinbiView;
    UIButton * btn;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)createCell
{
    headImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 50, 50)];
    headImage.userInteractionEnabled = YES;
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 50);
    [btn addTarget:self action:@selector(headBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headImage addSubview:btn];
    headImage.layer.masksToBounds = YES;
    headImage.layer.cornerRadius = headImage.frame.size.width/2;
    headImage.backgroundColor = BJCLOLR;
    [self.contentView addSubview:headImage];
    nameLable = [[UILabel alloc] initWithFrame:CGRectMake(headImage.frame.origin.x+headImage.frame.size.width+10, headImage.frame.origin.y+headImage.frame.size.height/2-10, UIScreenWidth, 20)];
    nameLable.textColor = TEXT;
    nameLable.font = [UIFont systemFontOfSize:14];
    nameLable.text = @"冉冉";
    [self.contentView addSubview:nameLable];
    jinbiView = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenWidth - 30,nameLable.frame.origin.y, 20, 20)];
    jinbiView.image = [UIImage imageNamed:@"金币(1)"];
    [self.contentView addSubview:jinbiView];
    jinbiLabel = [[UILabel alloc] initWithFrame:CGRectMake(jinbiView.frame.origin.x - 25, nameLable.frame.origin.y, 20,20)];
    jinbiLabel.text = @"+2";
    jinbiLabel.textColor = beijing;
    jinbiLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:jinbiLabel];
   
}
- (void)upCellWithDict:(NSDictionary *)dict
{
    [headImage setImageWithURL:[NSURL URLWithString:dict[@"user_photo"]] placeholderImage:[UIImage imageNamed:Default_UserHead]];
    nameLable.text = dict[@"nickname"];
    btn.tag = [[dict objectForKey:@"user_id"]integerValue];
}
- (void)headBtnAction:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(headClick:)]) {
        [self.delegate headClick:[NSString stringWithFormat:@"%ld",button.tag]];
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
