//
//  PostMenuDetailCell.m
//  Yongai
//
//  Created by arron on 14/11/11.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "PostMenuDetailCell.h"
#import "NSDate+Utils.h"
#import "ConvertToCommonEmoticonsHelper.h"
#define space 16
@implementation PostMenuDetailCell{
     UILabel * lable;
    UIImageView * image1;
    UIImageView * image2;
    UIImageView * image3;
}

- (void)awakeFromNib {
    // Initialization code
    self.label = [[UILabel alloc ] init];
    self.label.font = [UIFont systemFontOfSize:16];
    self.label.numberOfLines = 1;
    UIImageView * imageView;
    if (imageView == nil) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, UIScreenWidth, 0.5)];
        imageView.backgroundColor = LINE;
        [self.zhiDingLine1 addSubview:imageView];
        [self.zhiDingLine2 addSubview:imageView];
        [self.detailLine1 addSubview:imageView];
        [self.detailLine2 addSubview:imageView];
    }
   
//    if (lable == nil ) {
//        lable = [[UILabel alloc] initWithFrame:CGRectMake(UIScreenWidth-15,15,15, 60)];
//        lable.layer.masksToBounds = YES;
//        lable.layer.cornerRadius= 3;
//        lable.textAlignment = NSTextAlignmentCenter;
//        lable.font = [UIFont systemFontOfSize:12];
//        lable.textColor = [UIColor whiteColor];
//    }
//    lable.backgroundColor = beijing;
//    lable.text = @"女性回复";
//    lable.numberOfLines = 4;
//    [self.contentView addSubview:lable];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark --- 帖子列表的cell
-(void)setListInfo:(PostListModel *)listInfo
{
       _listInfo = listInfo;
       if (_listInfo.attachment.count == 0) {
        self.headImgView.hidden = YES;
        self.imageBackView.hidden = YES;
        // 15
        self.jingLeft.constant = 13;
    }else{
        self.jingLeft.constant = 31;
        self.imageBackView.hidden = NO;
        self.headImgView.hidden = NO;
    }
    self.nickNameLabel.text = _listInfo.nickname; //昵称
    self.nickNameLabel.textColor = [UIColor colorWithRed:160/255.0 green:154/255.0 blue:149/255.0 alpha:1];
    self.nickNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
   self.label.text = _listInfo.message;
    // 直接显示服务器返回的时间间隔
    [self.addTimeLabel setTitle:_listInfo.replyTime forState:UIControlStateNormal]; //发帖时间
    
    self.replyCountLabel.text = _listInfo.reply_num; //回复数
    self.replyCountLabel.textColor = RGBACOLOR(253, 110, 60, 1);
    
    if([_listInfo.is_jing isEqualToString:@"1"]) // 精状态
    {
        self.statusBtn1.hidden = NO;
        _jingImgWidth.constant = space;
        _jingImgH.constant = space;
    }
    else
    {
        self.statusBtn1.hidden = YES;
        _jingImgWidth.constant = 0;
    }
    
    if([_listInfo.is_hot isEqualToString:@"1"])  // 热状态
    {
        self.statusBtn2.hidden = NO;
         _hotImgWidth.constant = space;
        _hotImgH.constant = space;
    }
    else
    {
        self.statusBtn2.hidden = YES;
        _hotImgWidth.constant = 0;
    }
    
    if([_listInfo.is_new isEqualToString:@"1"])  // 新状态
    {
        self.statusBtn3.hidden = NO;
        _xinImgWidth.constant = space;
        _xinImgH.constant = space;
    }
    else
    {
        self.statusBtn3.hidden = YES;
        _xinImgWidth.constant = 0;
    }
    
    if(_listInfo.subject != nil)
    {
        self.subjectLabel.text = [ConvertToCommonEmoticonsHelper convertToSystemEmoticons:_listInfo.subject]; //主题
        self.subjectLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        self.subjectLabel.textColor = [UIColor colorWithRed:108/255.0 green:97/255.0 blue:85/255.0 alpha:1];
    }
    else
        self.subjectLabel.text = @"";
    
    if(_listInfo.message.length != 0)//内容
    {
        self.messageLabel.text = @"";
    }
    else
    {
        self.messageLabel.text = @"";
       
    }
    
    
}
- (void)createimageWithArray:(NSArray *)imageArr
{
    int imageW = (UIScreenWidth - 20-30)/3;
    self.imageViewH.constant = imageW;
    for (int i =0; i< imageArr.count; i++) {
        
        ImgInfoModel * dict = imageArr[i];
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(15+i*(imageW+5),0, imageW, imageW)];
        image.backgroundColor = BJCLOLR;
        [image setImageWithURL:[NSURL URLWithString:dict.url] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
        [self.imageBackView addSubview:image];
}

   
}
-(NSString*)getContentHeight
{
    
    CGSize labSize = [self.label.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.label.font,NSFontAttributeName, nil]];
    NSString *content = _listInfo.message;
    float messageLabelW = _messageLabel.frame.size.width;
    float a = labSize.width/messageLabelW;
    CGSize size;
    if (MainView_Width > 320) {
        if (a  > 1.2) {
            size = CGSizeMake(_messageLabel.frame.size.width,21 * 3);
        }else{
            size = CGSizeMake(_messageLabel.frame.size.width,21 * 1);
        }

    }else{
        size = CGSizeMake(_messageLabel.frame.size.width,21 * 3);
    }
    
    UIFont *font = _messageLabel.font;
    CGFloat defaultHeight = 255;
    if([content length])
    {
        CGFloat contentHeight = 0;
        if ([content respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
        {
            NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:content attributes:@{ NSFontAttributeName:font }];
            CGRect rect = [attributedText boundingRectWithSize:(CGSize){size.width, size.height} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            contentHeight = ceilf(rect.size.height);
        } else {
            contentHeight = [content sizeWithFont:font constrainedToSize:CGSizeMake(size.width, size.height) lineBreakMode:NSLineBreakByWordWrapping].height;
        }
        
        defaultHeight = defaultHeight - 20 + contentHeight;
    }
    else
    {
        defaultHeight = defaultHeight - 30;
    }
    
    if(_listInfo.attachment.count == 0)
    {
        defaultHeight = defaultHeight - 100;
    }else{
        defaultHeight = defaultHeight + 100;
    }
    
    NSString *height = [NSString stringWithFormat:@"%f", defaultHeight];
    return height;
}

#pragma mark --- 选择标签的cell事件

- (IBAction)allBtnClick:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(postMenuBtnAction:)])
        [self.delegate postMenuBtnAction:0];
}
- (IBAction)godBtnClick:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(postMenuBtnAction:)])
        [self.delegate postMenuBtnAction:1];
}
- (IBAction)goddessBtnClick:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(postMenuBtnAction:)])
        [self.delegate postMenuBtnAction:2];
}
- (IBAction)partyBtnClick:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(postMenuBtnAction:)])
        [self.delegate postMenuBtnAction:3];
}

#pragma mark --- 帖子详情cell事件

- (IBAction)headBtnClick:(id)sender {
       if(self.delegate && [self.delegate respondsToSelector:@selector(showOtherCenterView:)])
        [self.delegate showOtherCenterView:_listInfo.user_id];
}

@end
