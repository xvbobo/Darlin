//
//  MyInfoLoginedCell.m
//  Yongai
//
//  Created by Kevin Su on 14-10-31.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MyInfoLoginedCell.h"
#import "TTIFont.h"
#import "QFControl.h"
@implementation MyInfoLoginedCell
{
    UIImageView * headView;
    UILabel * nameLable;
    UILabel * emailLable;
    UIImageView * sexImage;
    UIImageView * dengjiImage;
    UIImageView * huangGuanImage;
    UIImageView * headBG;
    UIImageView * imageUp0;//性别
    UIImageView * labelUp;//积分
    UIImageView * imageUp2;//等级
    UIImageView * imageUp3;//楼主
}
- (id)initWithFrame:(CGRect)frame
{
    CGFloat height = 210;
    if (self = [super initWithFrame:frame]) {
        UIImageView * imageBG = [[UIImageView alloc] initWithFrame:frame];
        imageBG.userInteractionEnabled = YES;
        int namelabelW = [TTIFont calWidthWithText:g_userInfo.nickname font:[UIFont systemFontOfSize:17] limitWidth:20];
        int huangGuan;
        if ([g_userInfo.rank_name isEqualToString:@"高级会员"]) {
            huangGuan = 3;
        }else{
            huangGuan = 2;
        }
        if (g_LoginStatus == 0) {
            
            UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,UIScreenWidth, 20)];
             lable.center = CGPointMake(imageBG.center.x, imageBG.center.y-60);
            lable.font = [UIFont systemFontOfSize:15];
            lable.text = @"欢迎来到Darlin";
            lable.textAlignment = NSTextAlignmentCenter;
            lable.textColor = [UIColor whiteColor];
            [imageBG addSubview:lable];
            UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            loginBtn.frame = CGRectMake(0, 0, 100, 30);
            loginBtn.center = CGPointMake(imageBG.center.x, imageBG.center.y-25);
            loginBtn.layer.masksToBounds = YES;
            loginBtn.layer.cornerRadius = 5;
            [loginBtn setBackgroundImage:[UIImage imageNamed:@"common_button_background_white.png"] forState:UIControlStateNormal];
//            loginBtn.backgroundColor = [UIColor whiteColor];
            [loginBtn setTitle:@"注册/登陆" forState:UIControlStateNormal];
            [loginBtn setTitleColor:BLACKTEXT forState:UIControlStateNormal];
            loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
            loginBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [imageBG addSubview:loginBtn];
            
        }else{
            headBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,80+5*4+namelabelW+20*huangGuan, 80)];
            headBG.userInteractionEnabled = YES;
            _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _headBtn.frame = headBG.frame;
            [headBG addSubview:_headBtn];
            headBG.center = CGPointMake(imageBG.center.x, imageBG.center.y-30);
            [imageBG addSubview:headBG];
            headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
            [headView setImageWithURL:[NSURL URLWithString:g_userInfo.user_photo] placeholderImage:[UIImage imageNamed:Default_UserHead]];
            headView.backgroundColor = beijing;
            headView.layer.masksToBounds = YES;
            headView.layer.cornerRadius = headView.frame.size.width/2;
            [headBG addSubview:headView];
            nameLable = [[UILabel alloc] initWithFrame:CGRectMake(headView.frame.origin.x+headView.frame.size.width+5, 10,namelabelW, 20)];
            nameLable.textColor = [UIColor whiteColor];
            nameLable.font = [UIFont systemFontOfSize:17];
            nameLable.text = g_userInfo.nickname;
            [headBG addSubview:nameLable];
            emailLable = [[UILabel alloc] initWithFrame:CGRectMake(nameLable.frame.origin.x, nameLable.frame.origin.y+nameLable.frame.size.height+10, UIScreenWidth, 20)];
            emailLable.font = [UIFont systemFontOfSize:17];
            emailLable.text = g_userInfo.email;
            emailLable.textColor = [UIColor whiteColor];
            [headBG addSubview:emailLable];
            UILabel * dengjiLabel = [[UILabel alloc] init];
            dengjiLabel.backgroundColor =expBJ;
            dengjiLabel.layer.masksToBounds = YES;
            dengjiLabel.layer.cornerRadius = 2;
            dengjiLabel.textAlignment = NSTextAlignmentCenter;
            dengjiLabel.text = [NSString stringWithFormat:@"LV.%@",g_userInfo.dengji];
            dengjiLabel.textColor = [UIColor whiteColor];
            dengjiLabel.font = [UIFont systemFontOfSize:12];
            CGFloat dengjiW = [TTIFont calWidthWithText:dengjiLabel.text font:[UIFont systemFontOfSize:12] limitWidth:20]+5;
//            dengjiLabel.frame = CGRectMake(nameLable.frame.origin.x+nameLable.frame.size.width+2,nameLable.frame.origin.y,dengjiW,18);
            if (g_userInfo.dengji) {
                [headBG addSubview:dengjiLabel];
            }
            
            NSString * imageStr;
            if ([g_userInfo.sex isEqualToString:@"1"])
            {
                imageStr = @"post_detail_male";
            }else{
                imageStr = @"post_detail_female";
            }
            imageUp0 = [QFControl createUIImageViewWithFrame:CGRectMake(nameLable.frame.origin.x+nameLable.frame.size.width+2,nameLable.frame.origin.y, 18, 18) imageName:imageStr];
            [headBG addSubview:imageUp0];
            if ([g_userInfo.user_rank isEqualToString:@"2"]) {
                imageUp2 = [QFControl createUIImageViewWithFrame:CGRectMake(imageUp0.frame.origin.x+imageUp0.frame.size.width+2,nameLable.frame.origin.y, 18, 18) imageName:@"post_detail_hguang"];
                dengjiLabel.frame = CGRectMake(imageUp2.frame.origin.x+imageUp2.frame.size.width+2,imageUp2.frame.origin.y,dengjiW,18);
                [headBG addSubview:imageUp2];
            }else {
                imageUp2.frame = imageUp0.frame;
                dengjiLabel.frame = CGRectMake(imageUp0.frame.origin.x+imageUp0.frame.size.width+2,imageUp0.frame.origin.y,dengjiW,18);
            }
            

        }
        imageBG.image = [UIImage imageNamed:@"my_info_cell_background_image"];
        UIImageView * downImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, height/3*2+5, UIScreenWidth,height/3-5)];
        downImage.userInteractionEnabled = YES;
        downImage.backgroundColor = RGBACOLOR(17,25,27,0.5);
        NSArray * array = @[@"common_money_icon",@"common_chat_icon",@"等级-1(1)",@"common_focus_icon",@"common_email_icon"];
        NSArray * names = @[@"金币",@"话题",@"等级",@"关注",@"消息"];
        for (int i = 0; i< 5; i++) {
            UIImageView * image0 = [[UIImageView alloc] initWithFrame:CGRectMake(30+i*((UIScreenWidth - 30*7)/4+30), 10, 20, 20)];
            image0.image = [UIImage imageNamed:array[i]];
            [downImage addSubview:image0];
            UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
            lable.center = CGPointMake(image0.center.x, image0.center.y+30);
            if (i==3) {
                image0.frame = CGRectMake(30+i*((UIScreenWidth - 30*7)/4+30), 15, 23, 15);
                lable.center = CGPointMake(image0.center.x, image0.center.y+27);
                _redImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(20,-6,8,8)];
                if (g_LoginStatus) {
                    _redImage1.image = [UIImage imageNamed:@"common_red_point"];
                }
                [image0 addSubview:_redImage1];
                _redImage1.hidden = YES;
            }
            if (i==4) {
                image0.frame = CGRectMake(30+i*((UIScreenWidth - 30*7)/4+30), 13, 23, 17);
                _redImage = [[UIImageView alloc] initWithFrame:CGRectMake(20,-4,8,8)];
                lable.center = CGPointMake(image0.center.x, image0.center.y+28);
                if (g_LoginStatus) {
                    _redImage.image = [UIImage imageNamed:@"common_red_point"];
                }
                [image0 addSubview:_redImage];
                
            }
            
            lable.textAlignment = NSTextAlignmentCenter;
            lable.text = names[i];
            lable.textColor = [UIColor whiteColor];
            lable.font = [UIFont systemFontOfSize:12];
            [downImage addSubview:lable];
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 100+i;
            btn.frame = CGRectMake(10+i*UIScreenWidth/5, 0, UIScreenWidth/5-10, downImage.frame.size.height);
//            btn.backgroundColor = beijing;
            [downImage addSubview:btn];
        }
        if (![g_version isEqualToString:VERSION]) {
             [imageBG addSubview:downImage];
        }
       
        [self addSubview:imageBG];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}
- (void)buttonAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(downBtnAction:)]) {
        [self.delegate downBtnAction:button];
    }
}
- (void)loginAction
{
    if ( [self.delegate respondsToSelector:@selector(showLoginView)]) {
        [self.delegate showLoginView];
    }
}
- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
