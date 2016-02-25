//
//  PostDetailHeadCell.m
//  Yongai
//
//  Created by arron on 14/11/11.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "PostDetailHeadCell.h"
#import "QFControl.h"
#define space  5
@implementation PostDetailHeadCell{
    BOOL _isFisrt;
    NSArray * biaoqian;
}
- (void)awakeFromNib {
    // Initialization code
    self.nickNameLabel.textColor = RGBACOLOR(253, 110, 60, 1);
    self.post_detail_line.backgroundColor = BJCLOLR;
    self.post_detail_lineH.constant = 0.5;
    [self setup];

}
- (void)isOrNotQianDao:(NSString *)str
{
    _qianDaoBtn = (UIButton *)[self viewWithTag:101];
    if ([str isEqualToString:@"1"]) {
        _qianDaoBtn.enabled = NO;
        [_qianDaoBtn setImage:[UIImage imageNamed:@"已签到"] forState:UIControlStateNormal];
        [_qianDaoBtn setTitle:@"已签到" forState:UIControlStateNormal];
    }else {
        _qianDaoBtn.enabled = YES;
        [_qianDaoBtn setImage:[UIImage imageNamed:@"签到"] forState:UIControlStateNormal];
        [_qianDaoBtn setTitle:@"签到" forState:UIControlStateNormal];
    }
}
-(void)setup
{
    int jianGe = (UIScreenWidth  - 25*4)/4;
    int with;
    int lableW;
    int lineW;
    if (UIScreenWidth > 320) {
        with = 15;
        lableW = 45;
        lineW = 5;
    }else{
        with = 10;
        lableW = 45;
        lineW = 1;
        
    }
    [_isJoinBtn  setImage:[UIImage imageNamed:@"circle_add_nor"] forState:UIControlStateSelected];
    [_isJoinBtn  setImage:[UIImage imageNamed:@"circle_add_sel"] forState:UIControlStateNormal];
    NSArray * imageArray = @[@"达人区",@"签到",@"领金币",@"标签"];
    for (int i = 0 ; i< 4; i++) {
        UIImageView * imageView;
        UILabel * lable;
        if (i == 1) {
            _imageQiandao = [QFControl createUIImageViewWithFrame:CGRectMake(with+i*(25+jianGe),self.contentView.frame.size.height - 30, 23, 23) imageName:imageArray[i]];
            _qiandaoLabel =[QFControl createLabelWithFrame:CGRectMake(_imageQiandao.frame.origin.x+_imageQiandao.frame.size.width+5,_imageQiandao.frame.origin.y+5,lableW, 15) text:imageArray[i]];
            _qiandaoLabel.font = [UIFont systemFontOfSize:15];
            
            _qiandaoLabel.textColor = TEXT;
            UIImageView * imageView2 = [QFControl createUIImageViewWithFrame:CGRectMake(_qiandaoLabel.frame.origin.x+_qiandaoLabel.frame.size.width+lineW,_qiandaoLabel.frame.origin.y+5, 1, 5) imageName:@"post_line"];
            _qianDaoBtn = [QFControl createButtonWithFrame:CGRectMake(_imageQiandao.frame.origin.x, _imageQiandao.frame.origin.y, _imageQiandao.frame.size.width+_qiandaoLabel.frame.size.width, _imageQiandao.frame.size.height) title:nil target:self action:@selector(buttonAction1:) tag:100+i];
            [self.contentView addSubview:imageView2];
            [self.contentView addSubview:_imageQiandao];
            [self.contentView addSubview:_qiandaoLabel];
            [self.contentView addSubview:_qianDaoBtn];
        }else if (i==2){
            imageView = [QFControl createUIImageViewWithFrame:CGRectMake(with+i*(22+jianGe),self.contentView.frame.size.height - 30, 25, 25) imageName:imageArray[i]];
            lable = [QFControl createLabelWithFrame:CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+5,imageView.frame.origin.y+5, 45, 15) text:imageArray[i]];
            lable.font = [UIFont systemFontOfSize:15];
            lable.textColor = TEXT;
            UIImageView * imageView1 = [QFControl createUIImageViewWithFrame:CGRectMake(lable.frame.origin.x+lable.frame.size.width+with-5,lable.frame.origin.y+5, 1,5) imageName:@"post_line"];
            UIButton * button = [QFControl createButtonWithFrame:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width+lable.frame.size.width, imageView.frame.size.height) title:nil target:self action:@selector(buttonAction1:) tag:100+i];
            [self.contentView addSubview:imageView];
            [self.contentView addSubview:lable];
            [self.contentView addSubview:imageView1];
            [self.contentView addSubview:button];
        }
        else{
            imageView = [QFControl createUIImageViewWithFrame:CGRectMake(with+i*(25+jianGe),self.contentView.frame.size.height - 30, 25, 25) imageName:imageArray[i]];
            lable = [QFControl createLabelWithFrame:CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+5,imageView.frame.origin.y+5, 45, 15) text:imageArray[i]];
            lable.font = [UIFont systemFontOfSize:15];
            lable.textColor = TEXT;
            UIImageView * imageView1 = [QFControl createUIImageViewWithFrame:CGRectMake(lable.frame.origin.x+lable.frame.size.width+5,lable.frame.origin.y+5, 1,5) imageName:@"post_line"];
            UIButton * button = [QFControl createButtonWithFrame:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width+lable.frame.size.width, imageView.frame.size.height) title:nil target:self action:@selector(buttonAction1:) tag:100+i];
            [self.contentView addSubview:imageView];
            [self.contentView addSubview:lable];
            [self.contentView addSubview:imageView1];
            [self.contentView addSubview:button];
            
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)buttonAction1:(UIButton *)btn
{
    if (btn.tag == 100) {
        [self showChartList];
    }else if (btn.tag == 101)
    {
        [self signinBtnClick:btn];
    }else if (btn.tag == 102)
    {
        [self showEssenceArea];
    }else{
        [self getGoldBtnClick];
    }
}
- (IBAction)headBtnClick:(id)sender {
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(showPersonalCenterView:)])
        [self.delegate showPersonalCenterView:self.tag];
}

// 关注按钮
- (IBAction)jsonBtnClick:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(joinBtnClick)])
        [self.delegate joinBtnClick];
}

// 泡友榜
- (void)showChartList {
 
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(showActionViewWithTag:)])
        [self.delegate showActionViewWithTag:0];
}

// 签到
- (void)signinBtnClick:(UIButton*)button{
    if(self.delegate && [self.delegate respondsToSelector:@selector(showActionViewWithTag:)])
        [self.delegate showActionViewWithTag:1];
}

// 金币
- (void)showEssenceArea {
    if(self.delegate && [self.delegate respondsToSelector:@selector(showActionViewWithTag:)])
        [self.delegate showActionViewWithTag:3];
}

// 标签（）
- (void)getGoldBtnClick {
    
    if ([self.delegate respondsToSelector:@selector(changeCell:)]) {
                    [self.delegate changeCell:_isFisrt];
        }
    
    _isFisrt =!_isFisrt;
    
}

@end
