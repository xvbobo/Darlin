//
//  TieZiLieBiaoCell.m
//  com.threeti
//
//  Created by alan on 15/7/24.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import "TieZiLieBiaoCell.h"
#import "NSDate+Utils.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "TTIFont.h"
#define with 17
@implementation TieZiLieBiaoCell
{
    UIImageView * backView;
    UILabel * numLabel;//回复数
    UILabel * timeLabel;//发帖时间
    UILabel * nameLabel;//昵称
    UILabel * Titlelabel;//主题
    CGFloat titleRight;
    UIImageView * image2;//人像
    UIImageView * image3;//回复图标
    int imageW;
    UIImageView * line2;//下线
    UIImageView * tubiaoBackView;//四个小图标
    NSInteger tag;
    CGFloat rightJianGe;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        titleRight = 15;
        rightJianGe = 10;
        imageW = (UIScreenWidth - 40)/3;
        backView = [[UIImageView alloc ] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 65+imageW)];
        backView.layer.borderColor = LINE.CGColor;
        backView.layer.borderWidth = 0.5;
        backView.backgroundColor = [UIColor whiteColor];
        tubiaoBackView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, with*4, with)];
        tubiaoBackView.backgroundColor = beijing;
//        [backView addSubview:tubiaoBackView];
        tag = 4;
        [self.contentView addSubview:backView];
        [self createInterface];
        self.backgroundColor = BJCLOLR;
    }
    return self;
}
- (void)createInterface
{
    NSArray * array = @[@"画-1",@"post_detail_jticon",@"post_detail_rtzIcon",@"post_detail_newcon"];
    for (int i =0 ; i<array.count; i++) {
        UIImageView * image0 = [[UIImageView alloc ] initWithFrame:CGRectMake(10+i*20, 13, with, with)];
        image0.image = [UIImage imageNamed:array[i]];
        image0.tag = 100+i;
        [backView addSubview:image0];
    }
    UIImageView * image1 = (UIImageView *)[self.contentView viewWithTag:103];
    //主题
    
    UIImageView * imageHua = (UIImageView *)[backView viewWithTag:100];
    UILabel * sexLabel = [[UILabel alloc]initWithFrame:CGRectMake(UIScreenWidth-15, imageHua.frame.origin.y+imageHua.frame.size.height+10, 15, 50)];
    sexLabel.layer.masksToBounds = YES;
    sexLabel.layer.cornerRadius = 3;
    sexLabel.textAlignment = NSTextAlignmentCenter;
    sexLabel.tag = 250;
    sexLabel.font = [UIFont systemFontOfSize:10];
    sexLabel.textColor = [UIColor whiteColor];
    sexLabel.numberOfLines = 4;
    [backView addSubview:sexLabel];
        for (int i = 0; i< 3; i++) {
            UIImageView * pic = [[UIImageView alloc] initWithFrame:CGRectMake(10+i*(imageW), imageHua.frame.origin.y+imageHua.frame.size.height+10, imageW-5, imageW-5)];
            pic.tag = 1000+i;
            pic.backgroundColor  = BJCLOLR;
            [backView addSubview:pic];
        }
   
    Titlelabel = [[UILabel alloc ] init ];
    Titlelabel.textColor = RGBACOLOR(108, 97, 85, 1);
    Titlelabel.font = font(15);
    //头像
    image2 = [[UIImageView alloc ] initWithFrame:CGRectMake(10, image1.frame.origin.y+image1.frame.size.height+imageW+10, with, with)];
    image2.image = [UIImage imageNamed:@"人像-1"];
    [backView addSubview:image2];
    //名字
    nameLabel = [[UILabel alloc ] initWithFrame:CGRectMake(image2.frame.origin.x+image2.frame.size.width, image2.frame.origin.y, 100, with)];
    nameLabel.font = font(12);
    nameLabel.textColor = RGBACOLOR(160, 154, 149, 1);
    [backView addSubview:nameLabel];
    [backView addSubview:Titlelabel];
    //回复数
    numLabel = [[UILabel alloc ] initWithFrame:CGRectMake(UIScreenWidth - 40, image2.frame.origin.y, 100, with)];
    numLabel.font = [UIFont systemFontOfSize:13];
    [backView addSubview:numLabel];
     image3 = [[UIImageView alloc ] initWithFrame:CGRectMake(numLabel.frame.origin.x - 20, image2.frame.origin.y, with, with)];
    image3.image = [UIImage imageNamed:@"post_detail_pl"];
    [self.contentView addSubview:image3];
    //时间
    timeLabel = [[UILabel alloc ] initWithFrame:CGRectMake(image3.frame.origin.x - image3.frame.size.width-60, image2.frame.origin.y, 60, with)];
    timeLabel.textColor = RGBACOLOR(160, 154, 149, 1);
    timeLabel.font = [UIFont systemFontOfSize:11];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [backView addSubview:timeLabel];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setImageArr:(NSArray *)imageArr
{
//    backView.frame = CGRectMake(0,5, UIScreenWidth, 70+imageW);
    
     NSLog(@"%@",imageArr);
    UIImageView * pic1 = (UIImageView*)[self viewWithTag:1000];
    UIImageView * pic2 = (UIImageView*)[self viewWithTag:1001];
    UIImageView * pic3 = (UIImageView*)[self viewWithTag:1002];
    if (imageArr.count==1) {
        pic2.hidden = YES;
        pic3.hidden = YES;
    }else if(imageArr.count == 2){
        pic3.hidden = YES;
    }else{
        pic1.hidden = NO;
        pic3.hidden = NO;
        pic2.hidden = NO;
    }
    for (int i =0 ; i< imageArr.count; i++) {
        ImgInfoModel * model = imageArr[i];
        if (i==0) {
            [pic1 setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
        }else if (i==1)
        {
            [pic2 setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
        }else{
            [pic3 setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
        }
    }
    
}
-(void)setPostInfo:(PostListModel *)postInfo
{
    tag = 4;
    UIImageView * pic1 = (UIImageView*)[self viewWithTag:1000];
    UIImageView * pic2 = (UIImageView*)[self viewWithTag:1001];
    UIImageView * pic3 = (UIImageView*)[self viewWithTag:1002];
    NSArray * array = postInfo.attachment;
    if (array.count != 0) {
        pic1.hidden = NO;
        pic2.hidden = NO;
        pic3.hidden = NO;
        backView.frame = CGRectMake(0, 0, UIScreenWidth, 65+imageW);
        image2.frame = CGRectMake(10,65+imageW-25,with,with);
        [self setImageArr:array];
    }else{
        backView.frame = CGRectMake(0, 0, UIScreenWidth,70);
        pic1.hidden = YES;
        pic2.hidden = YES;
        pic3.hidden = YES;
        image2.frame = CGRectMake(10,70-25,with,with);
    }
    nameLabel.frame = CGRectMake(image2.frame.origin.x+with+5, image2.frame.origin.y, 200, with);
    numLabel.frame=  CGRectMake(UIScreenWidth - 40, image2.frame.origin.y, 100, with);
    image3.frame = CGRectMake(numLabel.frame.origin.x - 20, image2.frame.origin.y, with, with);
    timeLabel.frame = CGRectMake(image3.frame.origin.x - image3.frame.size.width-60, image2.frame.origin.y, 60, with);
    line2.frame = CGRectMake(0,69, UIScreenWidth, 1);
    UIImageView * imageHua = (UIImageView *)[backView viewWithTag:100];
    UIImageView * jinImag = (UIImageView *)[backView viewWithTag:101];
//    CGRect rect0 = jinImag.frame;
    UIImageView * hotImag = (UIImageView*)[backView viewWithTag:102];
//    CGRect rect1 = hotImag.frame;
    UIImageView * newImag = (UIImageView*)[backView viewWithTag:103];
    UILabel * sexLabel = (UILabel*)[backView viewWithTag:250];
    if ([postInfo.sex_chose isEqualToString:@"0"]) {
        sexLabel.text = @"";
        sexLabel.backgroundColor = [UIColor whiteColor];
    }else if ([postInfo.sex_chose isEqualToString:@"1"]){
        sexLabel.text = @"男生回复";
        sexLabel.backgroundColor = MEN;
    }else{
        sexLabel.text = @"女生回复";
        sexLabel.backgroundColor = FEMEN;
    }
//    Titlelabel.frame = CGRectMake(newImag.frame.origin.x+newImag.frame.size.width, newImag.frame.origin.y+2, UIScreenWidth-newImag.frame.origin.x-newImag.frame.size.width, 13);
    if(![postInfo isKindOfClass:[PostListModel class]])
        return;
    
    _postInfo = postInfo;
    nameLabel.text = _postInfo.nickname; //昵称
    if (self.adTime == YES) {
//        NSArray *timeArray=[theDate componentsSeparatedByString:@"."];
//        theDate=[timeArray objectAtIndex:0];
////        
//        NSDateFormatter *date=[[NSDateFormatter alloc] init];
//        [date setDateFormat:@"ss"];
//        NSDate *d=[date dateFromString:_postInfo.addtime];
//        
//        NSTimeInterval late=[d timeIntervalSince1970]*1;
        
        NSDate* dat = [NSDate date];
        NSTimeInterval now=[dat timeIntervalSince1970]*1;
        NSString *timeString=@"";
        
//        NSTimeInterval cha=late-now;
        CGFloat cha = now - _postInfo.addtime.floatValue;
        if (cha/60 >1 && cha/3600<1) {
            timeString = [NSString stringWithFormat:@"%f", fabs(cha)];
            //            timeString = [timeString substringToIndex:timeString.length-7];
            timeString=[NSString stringWithFormat:@"%d分前",timeString.intValue];
            
        }
        if (cha/3600<1) {
            timeString = [NSString stringWithFormat:@"%f", fabs(cha/60)];
//            timeString = [timeString substringToIndex:timeString.length-7];
            timeString=[NSString stringWithFormat:@"%d分前",timeString.intValue];
            
        }
        if (cha/3600>1&&cha/86400<1) {
            timeString = [NSString stringWithFormat:@"%f", cha/3600];
//            timeString = [timeString substringToIndex:timeString.length-7];
            timeString=[NSString stringWithFormat:@"%d小时前", timeString.intValue];
        }
        if (cha/86400>1 && cha/2592000<1)
        {
            timeString = [NSString stringWithFormat:@"%f", cha/86400];
//            timeString = [timeString substringToIndex:timeString.length-7];
            timeString=[NSString stringWithFormat:@"%d天前", timeString.intValue];
            
        }
        if (cha/2592000>1&& cha/31104000<1) {
            timeString = [NSString stringWithFormat:@"%f", cha/2592000];
            //            timeString = [timeString substringToIndex:timeString.length-7];
            timeString=[NSString stringWithFormat:@"%d月前", timeString.intValue];
        }
        if (cha/31104000>1) {
            timeString = [NSString stringWithFormat:@"%f", cha/31104000];
            //            timeString = [timeString substringToIndex:timeString.length-7];
            timeString=[NSString stringWithFormat:@"%d年前", timeString.intValue];
        }
        timeLabel.text = timeString;//发帖时间
    }else{
      timeLabel.text = _postInfo.replyTime;//回复时间
    }
    
    numLabel.text = _postInfo.reply_num; //回复数
    numLabel.textColor = RGBACOLOR(253, 110, 60, 1);
    Titlelabel.text = [ConvertToCommonEmoticonsHelper convertToSystemEmoticons:_postInfo.subject]; //主题
    if (array.count == 0) {
        sexLabel.frame = CGRectMake(UIScreenWidth-15,10, 15, 50);
//        imageHua.hidden = YES;
//        jinImag.frame = imageHua.frame;
//        hotImag.frame = CGRectMake(jinImag.frame.origin.x+with+3, jinImag.frame.origin.y, with, with);
//        newImag.frame = CGRectMake(hotImag.frame.origin.x+with+3, hotImag.frame.origin.y, with, with);
//        Titlelabel.frame = CGRectMake(newImag.frame.origin.x+with+3, newImag.frame.origin.y,UIScreenWidth- newImag.frame.origin.x-newImag.frame.size.width, with);
        
    }else{
//        imageHua.hidden = NO;
       
    }
    if ([_postInfo.is_pic isEqualToString:@"1"]) {
        imageHua.hidden = NO;
    }else{
        imageHua.hidden = YES;
        jinImag.frame = imageHua.frame;
        hotImag.frame = CGRectMake(jinImag.frame.origin.x+with+3, jinImag.frame.origin.y, with, with);
        newImag.frame = CGRectMake(hotImag.frame.origin.x+with+3, hotImag.frame.origin.y, with, with);
        Titlelabel.frame = CGRectMake(newImag.frame.origin.x+with+3, newImag.frame.origin.y,UIScreenWidth- newImag.frame.origin.x-newImag.frame.size.width-titleRight, with);
    }
    if([_postInfo.is_jing isEqualToString:@"1"]) // 精状态
    {
        jinImag.hidden = NO;
    }
    else
    {
        jinImag.hidden = YES;
        hotImag.frame = jinImag.frame;
        newImag.frame = CGRectMake(hotImag.frame.origin.x+with+3, hotImag.frame.origin.y, with, with);
        Titlelabel.frame = CGRectMake(newImag.frame.origin.x+with+3, newImag.frame.origin.y,UIScreenWidth- newImag.frame.origin.x-newImag.frame.size.width-titleRight, with);
    }
    
    if([_postInfo.is_hot isEqualToString:@"1"])  // 热状态
    {
        hotImag.hidden = NO;
        newImag.frame = CGRectMake(hotImag.frame.origin.x+with+3, hotImag.frame.origin.y, with, with);
        
    }
    else
    {
        hotImag.hidden = YES;
        newImag.frame = hotImag.frame;
        Titlelabel.frame = CGRectMake(newImag.frame.origin.x+with+3, newImag.frame.origin.y, UIScreenWidth- newImag.frame.origin.x-newImag.frame.size.width-titleRight, with);
    }
    if([_postInfo.is_new isEqualToString:@"1"])  // 新状态
    {
        newImag.hidden = NO;
        Titlelabel.frame = CGRectMake(newImag.frame.origin.x+with+3, newImag.frame.origin.y, UIScreenWidth- newImag.frame.origin.x-newImag.frame.size.width-titleRight, with);
        
    }
    else
    {
        newImag.hidden = YES;
        Titlelabel.frame = CGRectMake(hotImag.frame.origin.x+with+3, newImag.frame.origin.y, UIScreenWidth- newImag.frame.origin.x-newImag.frame.size.width-titleRight, with);
       
    }
    if ([_postInfo.is_jing isEqualToString:@"0"]&&[_postInfo.is_new isEqualToString:@"0"]&&[_postInfo.is_hot isEqualToString:@"0"]) {
        Titlelabel.frame = CGRectMake(imageHua.frame.origin.x+with+3, newImag.frame.origin.y, UIScreenWidth- newImag.frame.origin.x-newImag.frame.size.width-titleRight, with);
    }
    if ([_postInfo.is_jing isEqualToString:@"0"]&&[_postInfo.is_new isEqualToString:@"0"]&&[_postInfo.is_hot isEqualToString:@"0"]&&[_postInfo.is_pic isEqualToString:@"0"]) {
        Titlelabel.frame = CGRectMake(10, newImag.frame.origin.y, UIScreenWidth- newImag.frame.origin.x-newImag.frame.size.width-titleRight, with);
    }


}


@end
