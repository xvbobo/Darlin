//
//  MyTopicDetailViewCell.m
//  Yongai
//
//  Created by myqu on 14/12/12.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MyTopicDetailViewCell.h"
#import "NSDate+Utils.h"
#import "QFControl.h"
#import "TTIFont.h"
#define ContentFont_14 [UIFont systemFontOfSize:15]
#define ContentFont_15 [UIFont systemFontOfSize:16]
#define Cell_Height   275
#define Cell_replyViewHeight   83   // 回复头信息［不包括图片和回复的回复内容］
#define LouZhuSpace 30
@implementation MyTopicDetailViewCell
{
    UIImageView * imageViewUp;
    UIImageView * imageViewDown;
    UILabel * labelUp;//昵称
    UIImageView * imageUp0;//性别
    UIImageView * imageUp1;//积分
    UIImageView * imageUp2;//等级
    UIImageView * imageUp3;//楼主
    UILabel * labelDown;//昵称
    UIImageView * imageDown0;//性别
    UIImageView * imageDown1;//积分
    UIImageView * imageDown2;//等级
    UIImageView * imageDown3;//楼主
    UILabel * expLabelUp;
    UILabel * expLabelDown;
    
}
- (void)awakeFromNib {
    // Initialization code
    //楼主

    self.imageViewYe.backgroundColor = RGBACOLOR(246, 244, 239, 1);
    imageViewUp = [[UIImageView alloc] initWithFrame:CGRectMake(55, 14, UIScreenWidth-55-10, 15)];
    _shaFaLabelUp = [[UILabel alloc] initWithFrame:CGRectMake(imageViewUp.frame.size.width-50, 0, 50, 15)];
    _shaFaLabelUp.textColor = BLACKTEXT;
    _shaFaLabelUp.text = @"沙发";
    _shaFaLabelUp.textAlignment = NSTextAlignmentRight;
    _shaFaLabelUp.font = [UIFont systemFontOfSize:13];
    [imageViewUp addSubview:_shaFaLabelUp];
    imageViewDown =[[UIImageView alloc] initWithFrame:CGRectMake(55, 14, UIScreenWidth-20-55-10, 15)];
    _shaFaLabelDown = [[UILabel alloc] initWithFrame:CGRectMake(imageViewDown.frame.size.width-50, 0, 50, 15)];
    _shaFaLabelDown.textColor = BLACKTEXT;
//    _shaFaLabelDown.text = @"沙发";
    expLabelUp = [[UILabel alloc] init];
    expLabelUp.backgroundColor = expBJ;
    expLabelUp.layer.masksToBounds = YES;
    expLabelUp.layer.cornerRadius = 2;
    expLabelUp.textColor = [UIColor whiteColor];
    expLabelUp.textAlignment = NSTextAlignmentCenter;
    expLabelUp.font = [UIFont systemFontOfSize:10];
    expLabelDown = [[UILabel alloc] init];
    expLabelDown.textColor = [UIColor whiteColor];
    expLabelDown.backgroundColor = expBJ;
    expLabelDown.layer.masksToBounds = YES;
    expLabelDown.layer.cornerRadius = 2;
    expLabelDown.textAlignment = NSTextAlignmentCenter;
    expLabelDown.font = [UIFont systemFontOfSize:10];
    _shaFaLabelDown.textAlignment = NSTextAlignmentRight;
    _shaFaLabelDown.font = [UIFont systemFontOfSize:12];
    [imageViewDown addSubview:_shaFaLabelDown];
    [self.replyBgView addSubview:imageViewDown];
    [self.commentBgView addSubview:imageViewUp];
    labelUp = [[UILabel alloc] init];
    labelDown = [[UILabel alloc] init];
    [imageViewDown addSubview:labelDown];
    [imageViewUp addSubview:labelUp];
    imageUp0 = [[UIImageView alloc] init];
    imageUp1 = [[UIImageView alloc] init];
    imageUp2 = [[UIImageView alloc] init];
    imageUp2.image = [UIImage imageNamed:@"post_detail_hguang"];
    imageUp3 = [[UIImageView alloc] init];
    imageUp3.image = [UIImage imageNamed:@"楼主-1"];
    imageDown0 = [[UIImageView alloc] init];
    imageDown1 = [[UIImageView alloc] init];
    imageDown1.image = [UIImage imageNamed:@"等级-1"];
    imageDown2 = [[UIImageView alloc] init];
    imageDown2.image = [UIImage imageNamed:@"post_detail_hguang"];
    imageDown3 = [[UIImageView alloc] init];
    imageDown3.image = [UIImage imageNamed:@"楼主-1"];
    [imageViewUp addSubview:imageUp0];
    [imageViewUp addSubview:imageUp1];
    [imageViewUp addSubview:imageUp2];
    [imageViewUp addSubview:imageUp3];
    [imageViewUp addSubview:expLabelUp];
    [imageViewDown addSubview:imageDown0];
    [imageViewDown addSubview:imageDown1];
    [imageViewDown addSubview:imageDown2];
    [imageViewDown addSubview:imageDown3];
    [imageViewDown addSubview:expLabelDown];
    self.xiaLabelTop.constant = 50;
    self.upLouZhuH.constant = 15.5;
    self.upLouZhuW.constant = 15.5;
    self.downLouZhuH.constant = 15.5;
    self.downLouZhuW.constant = 15.5;
    self.userContentLabel.numberOfLines = 0;
    self.huiFuBtnRight.constant = 4;
//    self.timeLable.textAlignment = NSTextAlignmentRight;
    self.line1.backgroundColor = LINE;
    self.line2.backgroundColor = BJCLOLR;
    self.line2.layer.borderColor = LINE.CGColor;
    self.line2.layer.borderWidth = 0.5;
    self.lin1H.constant = 0.5;
    [self.huiFuBtn setTitle:@"回复" forState:UIControlStateNormal];
    UIEdgeInsets titleInset = {5,10,5,0};
    [self.huiFuBtn setTitleEdgeInsets:titleInset];
    self.huiFuBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.huiFuBtn setTitleColor:beijing forState:UIControlStateNormal];
    
    [self.huiFuBtn setImage:[UIImage imageNamed:@"post_detail_pl"] forState:UIControlStateNormal
     ];
    UIEdgeInsets imageInset  = {5,5,5,self.huiFuBtn.titleLabel.bounds.size.width};
    [self.huiFuBtn setImageEdgeInsets:imageInset];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setInfo:(PostDetailModel *)info
{
    _info = info;
        /**
     *  评论内容
     */
    ///新添加
    labelUp.font = font(14.5);
    labelUp.textColor = TEXTCOLOR;
    self.userContentLabel.textColor = RGBACOLOR(108, 97, 85, 1);
    self.userContentLabel.font = [UIFont systemFontOfSize:16];
    self.replyContentLabel.numberOfLines = 0;
    self.replyContentLabel.textColor = RGBACOLOR(108, 97, 85, 1);
    self.timeLable.textColor = TEXT;
    self.replyTimeDown.textColor = TEXT;
    self.replyTimeDown.font = [UIFont systemFontOfSize:10];
    self.userHeadImgView.layer.masksToBounds = YES;
    self.replyHeadImgView.layer.masksToBounds = YES;
    self.userHeadImgView.layer.cornerRadius = _userHeadViewW.constant/2;
    _huiFuHeadViewW.constant = ReplyHeadImgViewHeight;
    self.replyHeadImgView.layer.cornerRadius = _huiFuHeadViewW.constant/2;
    [_userHeadImgView setImageWithURL:[NSURL URLWithString:_info.user_photo] placeholderImage:[UIImage imageNamed:Default_UserHead]];
    labelUp.text = _info.nickname;
    CGFloat lableUpW = [TTIFont calWidthWithText:_info.nickname font:font(14.5) limitWidth:15];
//    labelUp.backgroundColor = BJCLOLR;
    labelUp.frame = CGRectMake(0, 0, lableUpW, 15);
    expLabelUp.text = [NSString stringWithFormat:@"LV.%@",info.exp_rank];
    CGFloat expLabelUpW = [TTIFont calWidthWithText: expLabelUp.text font:[UIFont systemFontOfSize:12] limitWidth:15];
//    expLabelUp.frame = CGRectMake(lableUpW+2, 0, expLabelUpW, 15);
     imageUp1.frame = CGRectMake(lableUpW+2, labelUp.frame.origin.y, 15, 15);
    if([_info.sex isEqualToString:@"1"])
        imageUp1.image = [UIImage imageNamed:@"post_detail_male"];
    else{
        imageUp1.image = [UIImage imageNamed:@"post_detail_female"];
    }
    
    if([_info.user_rank isEqualToString:@"2"])
    {
        imageUp2.hidden = NO;
        imageUp2.frame = CGRectMake(imageUp1.frame.origin.x+imageUp1.frame.size.width+2, imageUp1.frame.origin.y, 15, 15);
    }
    else{
        imageUp2.hidden = YES;
        imageUp2.frame = imageUp1.frame;
    
    }
    if ([self.user_id isEqualToString:_info.user_id]) {
        imageUp3.hidden = NO;
        if (imageUp2.hidden == YES) {
            imageUp3.frame = CGRectMake(imageUp1.frame.origin.x+imageUp1.frame.size.width+2, imageUp1.frame.origin.y, 15, 15);
        }else{
            imageUp3.frame =CGRectMake(imageUp2.frame.origin.x+imageUp2.frame.size.width+2, imageUp2.frame.origin.y, 15, 15);
        }
        expLabelUp.frame = CGRectMake(imageUp3.frame.origin.x+imageUp3.frame.size.width+2, imageUp3.frame.origin.y, expLabelUpW, 16);
       
    }else
    {
        imageUp3.hidden = YES;
        expLabelUp.frame = CGRectMake(imageUp2.frame.origin.x+imageUp2.frame.size.width+2, imageUp2.frame.origin.y, expLabelUpW, 16);
    }

    self.timeLable.text = _info.addtime;
    if (_info.message.length != 0)
    {
        
        _userContentLabel.text =[ConvertToCommonEmoticonsHelper convertToSystemEmoticons:_info.message];
        _userContentLabel.font = [UIFont systemFontOfSize:16];
        _userContentLabelHeight.constant = [TTIFont calHeightWithText:_userContentLabel.text font:[UIFont systemFontOfSize:16] limitWidth:UIScreenWidth - 20];
        self.replyViewHeight.constant = _userContentLabelHeight.constant + Cell_replyViewHeight - UserContentLabelHeight;
    }
    else
    {
        _userContentLabel.text = _info.message;
        _userContentLabelHeight.constant = 0;
        
        self.replyViewHeight.constant = Cell_replyViewHeight - UserContentLabelHeight;
    }
    
    if(_info.attachment.count != 0 )
    {
        ImgInfoModel  *imageInfo = [_info.attachment objectAtIndex:0];
        [_picImgView setImageWithURL:[NSURL URLWithString:imageInfo.url] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
        _picImgViewHeight.constant = [self getFitHeightWithImageInfoModel:imageInfo];
    }
    else
    {
        _picImgView.image = nil;
        _picImgViewHeight.constant = 0;
    }
    
    /**
     *  被回复的内容
     */
    if(_info.subPost != nil)
    {
        
        _replyBgView.hidden = NO;

        [_replyHeadImgView setImageWithURL:[NSURL URLWithString:_info.subPost.user_photo] placeholderImage:[UIImage imageNamed:Default_UserHead]];
        labelDown.text = _info.subPost.nickname;
        CGFloat lableUpW = [TTIFont calWidthWithText:_info.subPost.nickname font:font(14.5) limitWidth:15];
        labelDown.frame = CGRectMake(0, 0, lableUpW, 15);
        labelDown.font = [UIFont systemFontOfSize:14];
        labelDown.textColor = TEXTCOLOR;
        expLabelDown.text = [NSString stringWithFormat:@"LV.%@",_info.subPost.exp_rank];
        CGFloat expLabelDW = [TTIFont calWidthWithText: expLabelDown.text font:[UIFont systemFontOfSize:12] limitWidth:15];
        expLabelDown.frame = CGRectMake(labelDown.frame.origin.x+lableUpW+2, 0, expLabelDW, 15);
        imageDown1.frame = CGRectMake(expLabelDown.frame.origin.x+expLabelDown.frame.size.width+2, expLabelDown.frame.origin.y, 15, 15);
        if([_info.subPost.sex isEqualToString:@"1"])
        {
            imageDown1.image = [UIImage imageNamed:@"post_detail_male"];
        
        }
        else{
            imageDown1.image = [UIImage imageNamed:@"post_detail_female"];
           
        }
        
        for (NSDictionary * dict in self.subDictArray) {
            if ([_info.subPost.pid isEqualToString:dict.allKeys[0]]) {
                self.shaFaLabelDown.text = [dict objectForKey:_info.subPost.pid];
            }
        }
        if([_info.subPost.user_rank isEqualToString:@"2"])
        {
            imageDown2.hidden = NO;
            imageDown2.frame = CGRectMake(imageDown1.frame.origin.x+imageDown1.frame.size.width+2, imageDown1.frame.origin.y, 15, 15);

        }
        else{
            imageDown2.hidden = YES;
        }
        //隐藏楼主
        if ([self.user_id isEqualToString:_info.subPost.user_id]) {
            imageDown3.hidden = NO;
            if (imageDown2.hidden == YES) {
                imageDown3.frame = CGRectMake(imageDown1.frame.origin.x+imageDown1.frame.size.width+2, imageDown1.frame.origin.y, 15, 15);
            }else{
                imageDown3.frame =CGRectMake(imageDown2.frame.origin.x+imageDown2.frame.size.width+2, imageDown2.frame.origin.y, 15, 15);
            }

        }else
        {
            imageDown3.hidden = YES;
        }


        // 姓名距离上方的间距 11  姓名高度 17
//        _xiaLabelTop.constant = 63;
        _replyNameLabelTop.constant = ReplyNameLabelTop;
        _replyNameLabelHeight.constant = ReplyNameLabelHeight;
                self.replyTimeDown.text = _info.subPost.addtime;

        if(_info.subPost.message.length != 0)
        {

//            NSString * str = [_info.subPost.message stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            _replyContentLabel.text =[ConvertToCommonEmoticonsHelper convertToSystemEmoticons:_info.subPost.message];
            _huifuLableHeiht.constant = [TTIFont calHeightWithText:_info.subPost.message font:[UIFont systemFontOfSize:14] limitWidth:UIScreenWidth - 40];
            _huiFuBigViewHeight.constant = _huifuLableHeiht.constant+_replyHeadImgViewHeight.constant+30;

        }
        else
        {
            _replyContentLabel.text =@"";
            _replyContentLabel.hidden = YES;
        }
        
        _replyBgImgView.image = [UIImage imageNamed:@"MyTopicDetailTwoViewCell_background"];
//        _replyBgImgView.hidden = NO;
        // 回复内容距离上下的间距 10 10
        _replyBgViewBottom.constant = ReplyBgViewBottom;
        
        // 头像距离上下的间距 15
        _replyHeadViewTop.constant = ReplyHeadViewTop;
        _replyHeadImgViewHeight.constant = ReplyHeadImgViewHeight;
        
        // 回复内容距离上下的间距  10-10
        _replyContentBottom.constant = ReplyContentBottom;
        //时间高度  17
        _replyTimeBtnHeight.constant = ReplyTimeBtnHeight;
        
        // 回复人的性别 高度 13
        _replyGenderImgViewHeight.constant = ReplyGenderImgViewHeight;
        
    }
    else
    {
       
        _replyBgView.hidden = YES;
        // 回复内容距离上下的间距 10 10
        _replyBgViewBottom.constant = 0;
        
        // 姓名距离上方的间距 11  姓名高度 17
        _replyNameLabelTop = 0;
        _replyNameLabelHeight = 0;
        
        // 头像距离上下的间距 15
        _replyHeadViewTop.constant = 0;
        _replyHeadImgViewHeight.constant = 0;
        
        // 回复内容距离上下的间距  10-10
        _replyContentBottom.constant = 0;
        _huifuLableHeiht.constant = 0;
        //时间高度  17
        _replyTimeBtnHeight.constant = 0;
        // 回复人的性别 高度 13
        _replyGenderImgViewHeight.constant = 0;
    }
}


-(CGFloat)getFitHeightWithImageInfoModel:(ImgInfoModel *)info
{
    CGFloat width = UIScreenWidth-20 ;
    CGFloat height = 0;
    height = (info.height.floatValue/info.width.floatValue)*width;
    return  height;
}
-(NSString *)getCellHeightByInfo
{
    CGFloat cellHeight = 0;
    CGSize contentSize = CGSizeMake(UIScreenWidth -20, MAXFLOAT);
    PostDetailModel *info = _info;
    
    // 标题所占高度
    CGSize  titleSize;
    titleSize.height =  [TTIFont calHeightWithText:_info.message font:[UIFont systemFontOfSize:16] limitWidth:UIScreenWidth-20];
    
    CGSize replySize = CGSizeZero;
    if(info.subPost != nil)
    {
        // 标题所占高度
        NSString *name = info.subPost.nickname;
        CGSize  nameSize = CGSizeZero;
        if([name length]) {
            
            if ([name respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
                NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:name attributes:@{ NSFontAttributeName:ContentFont_15 }];
                CGRect rect = [attributedText boundingRectWithSize:(CGSize){contentSize.width-20, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
                nameSize = rect.size;
            } else {
                nameSize = [name sizeWithFont:ContentFont_14 constrainedToSize:CGSizeMake(contentSize.width - 20 , CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
            }
        }
        
        
        // 内容所占的高度
        NSString *content = info.subPost.message;
        CGSize  replyMsgSize = CGSizeZero;
        if([content length]) {
            replyMsgSize.height = [TTIFont calHeightWithText:content font:[UIFont systemFontOfSize:14] limitWidth:UIScreenWidth-40];
        }else
        {
            replyMsgSize.height = 0;
        }
        replySize.height = nameSize.height + replyMsgSize.height - ReplyNameLabelHeight- ReplyContentDefaultHeight;
    }
    else
    {
        replySize.height = -ReplyBgViewDefaultHeight+25;
    }
    
    
    if(info.attachment.count == 0)
        cellHeight=Cell_Height + titleSize.height  - UserContentLabelHeight + replySize.height - PicImgViewHeight;
    else
    {
        cellHeight = Cell_Height + titleSize.height  - UserContentLabelHeight + replySize.height + _picImgViewHeight.constant -PicImgViewHeight;
    }
    return [NSString stringWithFormat:@"%f", cellHeight];
}

@end
