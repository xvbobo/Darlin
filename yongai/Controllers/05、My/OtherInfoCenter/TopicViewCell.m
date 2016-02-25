//
//  TopicViewCell.m
//  Yongai
//
//  Created by myqu on 14/11/13.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "TopicViewCell.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "TTIFont.h"
@implementation TopicViewCell
{
    UILabel * timeLabel;
    NSLayoutConstraint * constraint1;
     NSLayoutConstraint * constraint;
}

- (void)awakeFromNib {
    // Initialization code
//    self.yuanImage.layer.masksToBounds = YES;
//   _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    _cancelBtn.translatesAutoresizingMaskIntoConstraints = NO;
//    [self addSubview:_cancelBtn];
//    constraint  = [NSLayoutConstraint constraintWithItem:_cancelBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:55];
//    [self addConstraint:constraint];
//    constraint  = [NSLayoutConstraint constraintWithItem:_cancelBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:80];
//    [self addConstraint:constraint];
//    constraint  = [NSLayoutConstraint constraintWithItem:_cancelBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20];
//    [self addConstraint:constraint];
    _imageV = [[UIImageView alloc] init];
    _imageV.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_imageV];
    constraint1 = [NSLayoutConstraint constraintWithItem:_imageV attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:10];
    [self addConstraint:constraint1];
    constraint1  = [NSLayoutConstraint constraintWithItem:_imageV attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:55];
    [self addConstraint:constraint1];
    constraint1  = [NSLayoutConstraint constraintWithItem:_imageV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20];
    [self addConstraint:constraint1];
    constraint1  = [NSLayoutConstraint constraintWithItem:_imageV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20];
    [self addConstraint:constraint1];


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)hideImgBgView:(BOOL)bHide
{
    if(bHide == YES)
        self.imgBgViewHeightConstraint.constant = 0;
    else
        self.imgBgViewHeightConstraint.constant = 90;
}

-(void)setPostInfo:(PostListModel *)postInfo
{
        _postInfo = postInfo;
    CGFloat height = [TTIFont calHeightWithText:[ConvertToCommonEmoticonsHelper convertToSystemEmoticons:_postInfo.message] font:[UIFont systemFontOfSize:14.0] limitWidth:UIScreenWidth-80];
    NSLog(@"%f",height);
//    constraint = [NSLayoutConstraint constraintWithItem:_cancelBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-(30-height+20)];
//    [self addConstraint:constraint];
    NSString * strTime = [NSDate dateFormTimestampStringByFormatter:@"HH:mm" timeStamp:_postInfo.addtime];
    self.timeLabel.text = strTime;
    self.timeLabel.font = [UIFont systemFontOfSize:15.0];
    self.timeLabel.textColor =  TEXT;
    [_cancelBtn setTitle:@"删除"forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:beijing forState:UIControlStateNormal];    _cancelBtn.tag = postInfo.tid.intValue;
//    _cancelBtn.backgroundColor = beijing;
//    _cancelBtn.layer.masksToBounds = YES;
//    _cancelBtn.layer.cornerRadius = 5;
    _dateLabel.text = [NSDate dateFormTimestampStringByFormatter:@"MM/dd" timeStamp:_postInfo.addtime];
    _titleLabelLeft.constant = 25;
    _titleLabel.text = [ConvertToCommonEmoticonsHelper convertToSystemEmoticons:_postInfo.subject];
    _titleLabel.textColor = RGBACOLOR(108, 97, 85, 1);
//    NSString * stringDetail = [[_postInfo.message stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString * stringDetail = [_postInfo.message  stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if(_postInfo.message.length != 0)
        _contentLabel.text =[ConvertToCommonEmoticonsHelper convertToSystemEmoticons:stringDetail];
    _contentLabel.textColor = RGBACOLOR(108, 97, 85, 1);
    _replyCountLabel.text = _postInfo.reply_num;
    if (![_cellName isEqualToString:@"HisTopic"]) {
        if ([_postInfo.is_jing isEqualToString:@"1"]||[postInfo.is_hot isEqualToString:@"1"]||[_postInfo.is_new isEqualToString:@"1"]) {
            _imageV.hidden = NO;
            if ([_postInfo.is_jing isEqualToString:@"1"]) {
                _imageV.image = [UIImage imageNamed:@"post_detail_jticon"];
            }
            if ([_postInfo.is_hot isEqualToString:@"1"]) {
                _imageV.image = [UIImage imageNamed:@"post_detail_rtzIcon"];
            }
            if ([_postInfo.is_new isEqualToString:@"1"]) {
                _imageV.image = [UIImage imageNamed:@"post_detail_newcon"];
            }
        }else{
            _titleLabelLeft.constant = 8;
            _imageV.hidden = YES;
        }
    }else{
        _imageV.hidden = YES;
        _titleLabelLeft.constant = 8;
        
    }
    if([_postInfo.is_pic isEqualToString:@"0"])
        [self hideImgBgView:YES];
    else
    {
        if (_postInfo.attachment.count == 0) {
           
            [self hideImgBgView:YES];
            return;
        }
        else{
        [self hideImgBgView:NO];
//          _cancelBtn.frame = CGRectMake(self.imgView0.frame.origin.x, self.imgView0.frame.origin.y+self.imgView0.frame.size.height+20, 200, 40);
        }
        
        
        if(_postInfo.attachment.count >0)
        {
            _imgView0.hidden = NO;
            if (_postInfo.attachment.count < 2)
            {
                _imgView2.hidden = YES;
                _imgView1.hidden = YES;
            }
            _imgView2.hidden = YES;
            ImgInfoModel *info = [_postInfo.attachment objectAtIndex:0];
            [_imgView0 setImageWithURL:[NSURL URLWithString:info.url] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
        }
        
        if(_postInfo.attachment.count >1)
        {
            _imgView1.hidden = NO;
            ImgInfoModel *info = [_postInfo.attachment objectAtIndex:1];
            [_imgView1 setImageWithURL:[NSURL URLWithString:info.url] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
        }

        
        if(_postInfo.attachment.count >2)
        {   _imgView2.hidden = NO;
            ImgInfoModel *info = [_postInfo.attachment objectAtIndex:2];
            [_imgView2 setImageWithURL:[NSURL URLWithString:info.url] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
        }
        
    }
}
- (void)initWith:(CGFloat)Height
{
//    _cancelBtn.frame = CGRectMake(50,Height , 80, 40);
//     if(_postInfo.attachment.count >0)
//     {
//        _cancelBtn.frame = CGRectMake(50,Height , 80, 40);
//     }else{
//         _cancelBtn.frame = CGRectMake(50,Height - 40, 80, 40);
//     }
    
}
@end
