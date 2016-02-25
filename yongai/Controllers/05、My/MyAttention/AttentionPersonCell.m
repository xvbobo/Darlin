//
//  AttentionPersonCell.m
//  Yongai
//
//  Created by myqu on 14/11/10.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "AttentionPersonCell.h"
#import "TTIFont.h"
@implementation AttentionPersonCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10,60, 60)];
        [self addSubview:self.headImgView];
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:self.nameLabel];
        self.sexImgView = [[UIImageView alloc] init];
        [self addSubview:self.sexImgView];
        self.rankLabel = [[UIImageView alloc] init];
        [self addSubview:self.rankLabel];
        UIImageView * lineview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 84.5, UIScreenWidth, 0.5)];
        lineview.backgroundColor = LINE;
        [self addSubview:lineview];
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

- (void) setInfo:(RankModel *) dict;
{
    
    [self.rankLabel setImage:[UIImage imageNamed:@"post_detail_hguang"]];
    [_headImgView setImageWithURL:[NSURL URLWithString:dict.user_photo] placeholderImage:[UIImage imageNamed:Default_UserHead]];
    _headImgView.layer.masksToBounds = YES;
    _headImgView.layer.cornerRadius = _headImgView.frame.size.width/2;

    if([dict.sex isEqualToString:@"0"])
        [_sexImgView setImage:[UIImage imageNamed:@"post_detail_female"]];
    else
        [_sexImgView setImage:[UIImage imageNamed:@"post_detail_male"]];
    
    if([dict.user_rank isEqualToString:@"1"])
    {
        self.rankLabel.hidden = YES;//等级
    }else
    {
        self.rankLabel.hidden = NO;//等级
    }
    
    CGFloat nameW = [TTIFont calWidthWithText:dict.nickname font:[UIFont systemFontOfSize:15.0] limitWidth:30];
    _nameLabel.frame = CGRectMake(self.headImgView.frame.origin.x+self.headImgView.frame.size.width+20, self.headImgView.frame.origin.y+self.headImgView.frame.size.height/2-7.5, nameW,15);
    _sexImgView.frame = CGRectMake(self.nameLabel.frame.size.width+self.nameLabel.frame.origin.x+10, self.nameLabel.frame.origin.y,15,15);
    _rankLabel.frame = CGRectMake(self.sexImgView.frame.origin.x+20, self.sexImgView.frame.origin.y,15,15);
    _nameLabel.text = dict.nickname;
    _nameLabel.textColor = RGBACOLOR(160, 154, 149, 1);

}

@end
