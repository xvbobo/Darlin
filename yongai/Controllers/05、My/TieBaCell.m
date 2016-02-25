//
//  TieBaCell.m
//  com.threeti
//
//  Created by alan on 15/7/8.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import "TieBaCell.h"
#import "TTIFont.h"
#import "CommonHelper.h"
#import "ConvertToCommonEmoticonsHelper.h"
@implementation TieBaCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tieba"]) {
        self.headView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10,55, 55)];
        self.headView.backgroundColor = BJCLOLR;
        self.headView.layer.masksToBounds = YES;
        self.headView.layer.cornerRadius = self.headView.frame.size.width/2;
        [self.contentView addSubview:self.headView];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headView.frame.origin.x+self.headView.frame.size.width+5,10, 200,30)];
        self.nameLabel.textColor = TEXTCOLOR;
        self.nameLabel.font = font(18 );
        [self.contentView addSubview:self.nameLabel];
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y+self.nameLabel.frame.size.height+3, 200,20)];
        self.timeLabel.textColor = TEXT;
        self.timeLabel.font = font(14);
        [self.contentView addSubview:self.timeLabel];
        self.tieLabel = [[UILabel alloc] init ];
        self.tieLabel.textColor = TEXTCOLOR;
        self.tieLabel.font = font(18);
        [self.contentView addSubview:self.tieLabel];
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textColor = BLACKTEXT;
        self.titleLabel.font = font(17);
        [self.contentView addSubview:self.titleLabel];
        self.detailImage = [[UIImageView alloc] init];
        self.detailImage.image = [UIImage imageNamed:@"tiebahuifu"];
        [self.contentView addSubview:self.detailImage];
        self.detailLabel = [[UILabel alloc] init];
        self.detailLabel.textColor = TEXT;
        self.detailLabel.font = [UIFont systemFontOfSize:17];
        [self.detailImage addSubview:self.detailLabel];
        self.contentView.layer.borderColor = LINE.CGColor;
        self.contentView.layer.borderWidth = 0.5;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)cellWithTiebaModel:(Tongzhi*)model
{
    [self.headView setImageWithURL:[NSURL URLWithString:model.user_photo] placeholderImage:[UIImage imageNamed:Default_UserHead]];
    self.nameLabel.text = model.nickname;
    self.timeLabel.text = model.addtime;
//    self.timeLabel.text = [CommonHelper formatterWithTime:model.addtime andWithType:@"MM月dd日 HH:mm"];
    self.tieLabel.text = [NSString stringWithFormat:@"【%@】",model.forum_name];
    CGFloat with = [TTIFont calWidthWithText:model.forum_name font:font(18) limitWidth:30]+40;
    self.tieLabel.frame = CGRectMake(UIScreenWidth -with,10, with,30);
    self.tieLabel.font = font(18);
    self.titleLabel.text = [ConvertToCommonEmoticonsHelper convertToSystemEmoticons:model.message];
    CGFloat titleH = [TTIFont calHeightWithText:self.titleLabel.text font:font(17) limitWidth:UIScreenWidth-20];
    self.titleLabel.frame = CGRectMake(self.headView.frame.origin.x, self.headView.frame.origin.y+self.headView.frame.size.height+10, UIScreenWidth-20,titleH);
    self.detailImage.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height, UIScreenWidth-20, 50);
    
    self.detailLabel.frame = CGRectMake(5, 10, UIScreenWidth-20, self.detailImage.frame.size.height-10);
    if ([model.pup isEqualToString:@"0"]) {
        self.detailLabel.text = [NSString stringWithFormat:@"回复了你的话题:%@",[ConvertToCommonEmoticonsHelper convertToSystemEmoticons:model.my_message]];
    }else {
       self.detailLabel.text = [NSString stringWithFormat:@"回复了你的评论:%@",[ConvertToCommonEmoticonsHelper convertToSystemEmoticons:model.my_message]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
