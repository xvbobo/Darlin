//
//  JiBITableViewCell.m
//  com.threeti
//
//  Created by alan on 15/10/22.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "JiBITableViewCell.h"

@implementation JiBITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createInterFace];
    }
    return self;
}
- (void)createInterFace
{
//    if ([g_userInfo.rank_name isEqualToString:@"高级会员"]) {
//        return 150;
//    }else{
//        return 180;
//    }

    self.backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 150)];
    self.backView.image = [UIImage imageNamed:@"myGoldBgView"];
    self.backView.userInteractionEnabled = YES;
    UIButton * headbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headbtn.frame = CGRectMake((UIScreenWidth-80)/2,40, 80, 80);
    headbtn.layer.masksToBounds = YES;
    headbtn.layer.cornerRadius = headbtn.frame.size.width/2;
    UIImageView * image = [[UIImageView alloc] initWithFrame:headbtn.bounds];
    [image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",g_userInfo.user_photo]] placeholderImage:[UIImage imageNamed:Default_UserHead]];
    UILabel * nameLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0,headbtn.frame.origin.y+headbtn.frame.size.height+5, UIScreenWidth,15)];
    nameLabel1.text = g_userInfo.nickname;
    nameLabel1.textAlignment = NSTextAlignmentCenter;
    nameLabel1.textColor = [UIColor whiteColor];
    nameLabel1.font = [UIFont systemFontOfSize:15];
    [self.backView addSubview:nameLabel1];
    [headbtn addSubview:image];
    [self.backView addSubview:headbtn];
    _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _changeBtn.frame = CGRectMake(headbtn.frame.origin.x+headbtn.frame.size.width+50, headbtn.frame.origin.y+headbtn.frame.size.height/2-10, 60, 20);
    [_changeBtn setTitle:@"去兑换" forState:UIControlStateNormal];
    _changeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_changeBtn setTitleColor:beijing forState:UIControlStateNormal];
    [self.backView addSubview:_changeBtn];
    UIImageView * jinBIView = [[UIImageView alloc] initWithFrame:CGRectMake(headbtn.frame.origin.x-headbtn.frame.size.width-20, _changeBtn.frame.origin.y, 20, 20)];
    jinBIView.image = [UIImage imageNamed:@"goldColorTag"];
    [self.backView addSubview:jinBIView];
     _jinbiLabel = [[UILabel alloc] initWithFrame:CGRectMake(jinBIView.frame.origin.x+jinBIView.frame.size.width+5, jinBIView.frame.origin.y, 100, 20)];
    _jinbiLabel.font = [UIFont systemFontOfSize:15];
    _jinbiLabel.textColor = beijing;
    [self.backView addSubview:_jinbiLabel];
    if (![g_userInfo.rank_name isEqualToString:@"高级会员"]) {
        _chajuLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, nameLabel1.frame.origin.y+nameLabel1.frame.size.height+10, UIScreenWidth, 30)];
        _chajuLabel.backgroundColor = RGBACOLOR(175,67, 31, 1);
        _chajuLabel.textAlignment = NSTextAlignmentCenter;
//        int a = _jinBiStr.intValue;
//        int b = g_userInfo.pay_points.intValue;
        _chajuLabel.textColor = [UIColor whiteColor];
        _chajuLabel.font = [UIFont systemFontOfSize:14];
//        NSString * cha = [NSString stringWithFormat:@"%d",abs(50 - b)];
//        NSString * str = [NSString stringWithFormat:@"您距离升级为皇冠会员，还差%@个金币",cha];
//        
//        NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc ] initWithString:str];
//        NSRange redRange = NSMakeRange(str.length-3-cha.length, 3);
//        [string1 addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(253,222,15, 1) range:redRange];
//        
//        [_chajuLabel setAttributedText:string1];
        [self.backView addSubview:_chajuLabel];
    }
    self.contentView.backgroundColor = BJCLOLR;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.backView];

}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
