//
//  MyTopicDetailTopView.m
//  Yongai
//
//  Created by wangfang on 14/11/14.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MyTopicDetailTopView.h"
#import "NSDate+Utils.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "TTIFont.h"
#define space 18
#import "QFControl.h"
//#define PicImgHeight  86.0 // 默认图片的高度

@implementation MyTopicDetailTopView
{
    UIImageView * imageUp0;//性别
    UIImageView * labelUp;//积分
    UIImageView * imageUp2;//等级
    UIImageView * imageUp3;//楼主
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(void)setPostInfo:(PostListModel *)postInfo
{
    UILabel * dengjiLabel = [[UILabel alloc] init];
    dengjiLabel.backgroundColor =expBJ;
    dengjiLabel.layer.masksToBounds = YES;
    dengjiLabel.layer.cornerRadius = 2;
    dengjiLabel.textAlignment = NSTextAlignmentCenter;
    dengjiLabel.text = [NSString stringWithFormat:@"LV.%@",postInfo.exp_rank];
    dengjiLabel.textColor = [UIColor whiteColor];
    dengjiLabel.font = [UIFont systemFontOfSize:12];
    CGFloat dengjiW = [TTIFont calWidthWithText:dengjiLabel.text font:[UIFont systemFontOfSize:12] limitWidth:20]+5;
    
    NSString * imageStr;
    if ([postInfo.sex isEqualToString:@"1"])
    {
         imageStr = @"post_detail_male";
    }else{
        imageStr = @"post_detail_female";
    }
    imageUp0 = [QFControl createUIImageViewWithFrame:CGRectMake(0, 5, 18, 18) imageName:imageStr];
    [self.UpView addSubview:imageUp0];
    if ([postInfo.user_rank isEqualToString:@"2"]) {
        imageUp2 = [QFControl createUIImageViewWithFrame:CGRectMake(imageUp0.frame.origin.x+imageUp0.frame.size.width+2, 5, 18, 18) imageName:@"post_detail_hguang"];
        imageUp3 = [QFControl createUIImageViewWithFrame:CGRectMake(imageUp2.frame.origin.x+imageUp2.frame.size.width+2, 5, 18, 18) imageName:@"楼主-1"];
       
        [self.UpView addSubview:imageUp2];
    }else{
       imageUp3 = [QFControl createUIImageViewWithFrame:CGRectMake(imageUp0.frame.origin.x+imageUp0.frame.size.width+2, 5, 18, 18) imageName:@"楼主-1"];
    }
    
     [self.UpView addSubview:imageUp3];
    dengjiLabel.frame = CGRectMake(imageUp3.frame.origin.x+imageUp3.frame.size.width+2, 5, dengjiW, 18);
    [self.UpView addSubview:dengjiLabel];
    
    
    UIButton * sendBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn addTarget:self action:@selector(sendBtnAvtion) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:sendBtn];
    NSLayoutConstraint * constraint = [NSLayoutConstraint constraintWithItem:sendBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10];
    [self addConstraint:constraint];
    constraint  = [NSLayoutConstraint constraintWithItem:sendBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:5];
    [self addConstraint:constraint];
    constraint  = [NSLayoutConstraint constraintWithItem:sendBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100];
    [self addConstraint:constraint];
    constraint  = [NSLayoutConstraint constraintWithItem:sendBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40];
    [self addConstraint:constraint];
    self.sendMessageBtn.userInteractionEnabled = NO;
    //昵称颜色和大小
    self.nickNameLabel.textColor = TEXTCOLOR;
    self.nickNameLabel.font = font(15);
    //主题颜色和大小
    self.titleLabel.textColor = TEXTCOLOR;
    self.titleLabel.font = font(18.5);
    //内容颜色和大小
    self.contentLabel.textColor = RGBACOLOR(108, 97, 85, 1);
    self.contentLabel.font = [UIFont systemFontOfSize:17];
    //楼主
    self.louZhuH.constant = 18.5;
    self.louZhuW.constant = 18.5;
    
    if (self.count < 7) {
        self.dashangViewH.constant = 200;
    }else{
        self.dashangViewH.constant = 250;
    }
    //时间颜色和大小
    self.numbeLabel.textColor = beijing;
    self.numbeLabel.font = [UIFont systemFontOfSize:15];
    self.timeLabel.textColor = RGBACOLOR(160, 154, 149, 1);
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.reportStatusLabel.textColor = RGBACOLOR(253, 110, 60, 1);
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.cornerRadius = _headViewW.constant/2;
//    [self.reportBtn setImage:[UIImage imageNamed:@"举报92"]forState:UIControlStateNormal];
    _viewHeight = 75;
    
    _postInfo = postInfo;
    
    [_headImgView setImageWithURL:[NSURL URLWithString:_postInfo.user_photo] placeholderImage:[UIImage imageNamed:Default_UserHead]];
    _nickNameLabel.text = _postInfo.nickname;
    
    if([_postInfo.sex isEqualToString:@"1"])
        _genderImgView.image = [UIImage imageNamed:@"post_detail_male"];
    else
        _genderImgView.image = [UIImage imageNamed:@"post_detail_female"];
    
    if([_postInfo.user_rank isEqualToString:@"2"])
    {
        _rankImgView.hidden = NO;
        _louzhuLeft.constant = 2;
    }
    else{
        _rankImgView.hidden = YES;
        _louzhuLeft.constant = -space;
    }
    
    if(_postInfo.subject.length != 0)
    {
        CGFloat height1 = [TTIFont calHeightWithText:postInfo.subject font:font(17) limitWidth:UIScreenWidth-20];
        _titleLabelHeight.constant = height1+20;
        _timeLabel.text = @"";
//        _viewHeight = _viewHeight +_titleLabelHeight.constant +25;
    }
    else
        _titleLabel.text = _postInfo.subject;
    
    if(_postInfo.message.length  !=0)
    {
        _contentLabel.text = [ConvertToCommonEmoticonsHelper convertToSystemEmoticons:_postInfo.message];
        self.contentLabel.lineBreakMode=UILineBreakModeWordWrap;
        self.contentLabel.numberOfLines=0;
        // 设置字体间每行的间距
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 4.0f;// 行间距
        NSDictionary *ats = @{
                              NSParagraphStyleAttributeName : paragraphStyle,
                              };
        self.contentLabel.attributedText = [[NSAttributedString alloc] initWithString:_contentLabel.text attributes:ats];
        _contentLabelHeight.constant = [self.contentLabel sizeThatFits:CGSizeMake(UIScreenWidth-20, MAXFLOAT)].height;
//        _viewHeight = _viewHeight + _contentLabelHeight.constant +20;
    }
    else{
        _contentLabelHeight.constant = 0;
        _contentLabel.text = _postInfo.message;
    }
    
    
//    _timeLabel.text = [NSDate dateFormTimestampStringByFormatter:@"yyyy-MM-dd HH:mm" timeStamp:_postInfo.addtime];
    
    
    // 约束间隔设置
    if(postInfo.attachment.count > 0 && ((ImgInfoModel *)[postInfo.attachment objectAtIndex:0]).url.length != 0)
    {
        ImgInfoModel *image1 = [postInfo.attachment objectAtIndex:0];
        _picImgViewBottom1.constant = 10;
        
        [_picImgView1 setImageWithURL:[NSURL URLWithString:image1.url] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
        
        _picImgViewHeight1.constant = [self  getFitHeightWithImageInfoModel:image1];
//        _viewHeight = _viewHeight + _picImgViewHeight1.constant + _picImgViewBottom1.constant;
    }
    else
    {
        _picImgViewBottom1.constant = 0;
        _picImgViewHeight1.constant = 0;
        _picImgView1.image = nil;
    }
    
    
    if(postInfo.attachment.count > 1 && ((ImgInfoModel *)[postInfo.attachment objectAtIndex:1]).url.length != 0)
    {
        ImgInfoModel *image2 = [postInfo.attachment objectAtIndex:1];
        _picImgViewBottom2.constant = 10;
        
        [_picImgView2 setImageWithURL:[NSURL URLWithString:image2.url] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
        
        _picImgViewHeight2.constant = [self  getFitHeightWithImageInfoModel:image2];
//        _viewHeight = _viewHeight + _picImgViewHeight2.constant  + _picImgViewBottom2.constant;
    }
    else
    {
        _picImgViewBottom2.constant = 0;
        _picImgViewHeight2.constant = 0;
        _picImgView2.image = nil;
    }
    
    
    if(postInfo.attachment.count > 2 && ((ImgInfoModel *)[postInfo.attachment objectAtIndex:2]).url.length != 0)
    {
        ImgInfoModel *image3 = [postInfo.attachment objectAtIndex:2];
        
        _picImgViewBottom3.constant = 10;
        
        [_picImgView3 setImageWithURL:[NSURL URLWithString:image3.url] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
        _picImgViewHeight3.constant = [self  getFitHeightWithImageInfoModel:image3];
//        _viewHeight = _viewHeight + _picImgViewHeight3.constant + _picImgViewBottom3.constant;
    }
    else
    {
        _picImgViewBottom3.constant = 0;
        _picImgViewHeight3.constant = 0;
        _picImgView3.image = nil;
    }
    
    
    if(postInfo.attachment.count > 3 && ((ImgInfoModel *)[postInfo.attachment objectAtIndex:3]).url.length != 0)
    {
        ImgInfoModel *image4 = [postInfo.attachment objectAtIndex:3];
        
        _picImgViewBottom4.constant = 10;
        
        [_picImgView4 setImageWithURL:[NSURL URLWithString:image4.url] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
        _picImgViewHeight4.constant = [self  getFitHeightWithImageInfoModel:image4];

//        _viewHeight = _viewHeight + _picImgViewHeight4.constant + _picImgViewBottom4.constant;
    }
    else
    {
        _picImgViewBottom4.constant = 0;
        _picImgViewHeight4.constant = 0;
        _picImgView4.image = nil;
    }
    
    if(postInfo.attachment.count > 4 && ((ImgInfoModel *)[postInfo.attachment objectAtIndex:4]).url.length != 0)
    {
        ImgInfoModel *image5 = [postInfo.attachment objectAtIndex:4];
        
        _picImgViewBottom5.constant = 10;
        
        [_picImgView5 setImageWithURL:[NSURL URLWithString:image5.url] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
        _picImgViewHeight5.constant = [self  getFitHeightWithImageInfoModel:image5];
//        _viewHeight = _viewHeight + _picImgViewHeight5.constant + _picImgViewBottom5.constant;
    }
    else
    {
        _picImgViewBottom5.constant = 0;
        _picImgViewHeight5.constant = 0;
        _picImgView5.image = nil;
    }
    
    
    if(postInfo.attachment.count > 5 && ((ImgInfoModel *)[postInfo.attachment objectAtIndex:5]).url.length != 0)
    {
        ImgInfoModel *image6 = [postInfo.attachment objectAtIndex:5];
        
        _picImgViewBottom6.constant = 10;
        
        [_picImgView6 setImageWithURL:[NSURL URLWithString:image6.url] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
        
        _picImgViewHeight6.constant = [self  getFitHeightWithImageInfoModel:image6];
//        _viewHeight = _viewHeight + _picImgViewHeight6.constant + _picImgViewBottom6.constant;
    }
    else
    {
        _picImgViewBottom6.constant = 0;
        _picImgViewHeight6.constant = 0;
        _picImgView6.image = nil;
    }
    
    
    if(postInfo.attachment.count > 6 && ((ImgInfoModel *)[postInfo.attachment objectAtIndex:6]).url.length != 0)
    {
        ImgInfoModel *image7 = [postInfo.attachment objectAtIndex:6];
        
        _picImgViewBottom7.constant = 10;
        
        [_picImgView7 setImageWithURL:[NSURL URLWithString:image7.url] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
        
        _picImgViewHeight7.constant = [self  getFitHeightWithImageInfoModel:image7];
//        _viewHeight = _viewHeight + _picImgViewHeight7.constant + _picImgViewBottom7.constant;
    }
    else
    {
        _picImgViewBottom7.constant = 0;
        _picImgViewHeight7.constant = 0;
        _picImgView7.image = nil;
    }
    
    if(postInfo.attachment.count > 7 && ((ImgInfoModel *)[postInfo.attachment objectAtIndex:7]).url.length != 0)
    {
        ImgInfoModel *image8 = [postInfo.attachment objectAtIndex:7];
        
        _picImgViewBottom8.constant = 15;
        
        [_picImgView8 setImageWithURL:[NSURL URLWithString:image8.url] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
        
        _picImgViewHeight8.constant = [self  getFitHeightWithImageInfoModel:image8];
//        _viewHeight = _viewHeight + _picImgViewHeight8.constant + _picImgViewBottom8.constant;
    }
    else
    {
        _picImgViewBottom8.constant = 0;
        _picImgViewHeight8.constant = 0;
        _picImgView8.image = nil;
    }
    
    }

-(CGFloat)getFitHeightWithImageInfoModel:(ImgInfoModel *)info
{
    CGFloat width = UIScreenWidth -20;
    CGFloat height = 0;
         height = (info.height.floatValue * width )/info.width.floatValue;
    
    return  height;
}
- (void)sendBtnAvtion
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(reportTopicAction)])
        [self.delegate reportTopicAction];
}
//举报
- (IBAction)reportBtnAction:(id)sender {
//    if(self.delegate && [self.delegate respondsToSelector:@selector(reportTopicAction)])
//        [self.delegate reportTopicAction];
}
@end
