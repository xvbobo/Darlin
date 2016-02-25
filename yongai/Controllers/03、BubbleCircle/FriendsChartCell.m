//
//  FriendsChartCell.m
//  Yongai
//
//  Created by myqu on 14/11/17.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "FriendsChartCell.h"
#import "TTIFont.h"
@implementation FriendsChartCell{
    UIImageView * image;
    UILabel * dengjiLabel;
}

- (void)awakeFromNib {
    // Initialization code
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.cornerRadius = self.headImgView.frame.size.width/2;
    self.rankLabel.textColor = beijing;
    self.nameLabel.textColor = BLACKTEXT;
    self.levelLabel.textColor = BLACKTEXT;
    self.contributionLabel.textColor = BLACKTEXT;
    self.line.backgroundColor = LINE;
    self.lineH.constant = 0.5;
    self.nameLableTop.constant = 38;
    image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 16, 16)];
    [self.dengJIVIew addSubview:image];
    dengjiLabel = [[UILabel alloc] init];
    [self.dengJIVIew addSubview:dengjiLabel];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRankInfo:(RankModel *)rankInfo
{
    _rankInfo = rankInfo;
    
    dengjiLabel.text = [NSString stringWithFormat:@"LV.%@",rankInfo.exp_rank];
    dengjiLabel.textColor = [UIColor whiteColor];
    dengjiLabel.layer.masksToBounds = YES;
    dengjiLabel.layer.cornerRadius = 2;
    dengjiLabel.font = [UIFont systemFontOfSize:12];
    dengjiLabel.backgroundColor = expBJ;

    CGFloat  dengJiW = [TTIFont calWidthWithText:dengjiLabel.text font:[UIFont systemFontOfSize:13] limitWidth:18];
    self.dengjiBViewW.constant = dengJiW+16;
    dengjiLabel.frame = CGRectMake(image.frame.origin.x+image.frame.size.width+2, image.frame.origin.y, dengJiW, 16);
    _rankLabel.text = _rankInfo.rank;
    [_headImgView setImageWithURL:[NSURL URLWithString:_rankInfo.user_photo] placeholderImage:[UIImage imageNamed:Default_UserHead]];
    
    if([_rankInfo.rank isEqualToString:@"1"])
        _flowerImgView.hidden = NO;
    else
        _flowerImgView.hidden = YES;
    
    _nameLabel.text = _rankInfo.nickname;
//    _levelLabel.text = _rankInfo.rank_name;
    
    _contributionLabel.text = [NSString stringWithFormat:@"月贡献：%@", _rankInfo.gold_num];
    
    if([_rankInfo.up_down isEqualToString:@"up"])
        _stateImgView.image = [UIImage imageNamed:@"growthTag"];
    
    else if ([_rankInfo.up_down isEqualToString:@"down"])
        _stateImgView.image = [UIImage imageNamed:@"reduceTag"];
    
    else if ([_rankInfo.up_down isEqualToString:@"flat"])
        _stateImgView.image = [UIImage imageNamed:@"flatTag"];
    
    
    if([_rankInfo.sex  isEqualToString:@"0"])
        image.image = [UIImage imageNamed:@"post_detail_female"];
    else
        image.image = [UIImage imageNamed:@"post_detail_male"];
    
}
@end
