//
//  PostsCell.m
//  Yongai
//
//  Created by myqu on 14/11/10.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "PostsCell.h"
#import "NSDate+Utils.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "TTIFont.h"
#define with 17
@implementation PostsCell {
    UIImageView * backView;
    UILabel * numLabel;//回复数
    UILabel * timeLabel;//发帖时间
    UILabel * nameLabel;//昵称
    UILabel * Titlelabel;//主题
    CGFloat titleW;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        backView = [[UIImageView alloc ] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 75)];
        backView.backgroundColor = [UIColor whiteColor];
        UIImageView * line1 = [[UIImageView alloc ] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 1)];
        line1.image = [UIImage imageNamed:@"common_line"];
        UIImageView * line2 = [[UIImageView alloc ] initWithFrame:CGRectMake(0,backView.frame.size.height, UIScreenWidth, 1)];
        line2.image = [UIImage imageNamed:@"common_line"];;
        [backView addSubview:line1];
        [backView addSubview:line2];
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
    titleW = UIScreenWidth-image1.frame.origin.x-image1.frame.size.width-60;
    Titlelabel = [[UILabel alloc ] init ];
    Titlelabel.textColor = RGBACOLOR(108, 97, 85, 1);
    Titlelabel.font = font(15);
    //头像
    UIImageView * image2 = [[UIImageView alloc ] initWithFrame:CGRectMake(10, image1.frame.origin.y+image1.frame.size.height+20, with, with)];
    image2.image = [UIImage imageNamed:@"人像-1"];
    [backView addSubview:image2];
    //名字
    nameLabel = [[UILabel alloc ] initWithFrame:CGRectMake(image2.frame.origin.x+image2.frame.size.width, image2.frame.origin.y, 100, with)];
    nameLabel.font = font(12);
    nameLabel.textColor = RGBACOLOR(160, 154, 149, 1);
    [backView addSubview:nameLabel];
    [backView addSubview:Titlelabel];
    //回复数
     numLabel = [[UILabel alloc ] initWithFrame:CGRectMake(UIScreenWidth - 25, image2.frame.origin.y, 100, with)];
    numLabel.font = [UIFont systemFontOfSize:13];
    [backView addSubview:numLabel];
    UIImageView * image3 = [[UIImageView alloc ] initWithFrame:CGRectMake(numLabel.frame.origin.x - 20, image2.frame.origin.y, with, with)];
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

-(void)setPostInfo:(PostListModel *)postInfo
{
    UIImageView * imageHua = (UIImageView *)[backView viewWithTag:100];
    UIImageView * jinImag = (UIImageView *)[backView viewWithTag:101];
    //    CGRect rect0 = jinImag.frame;
    UIImageView * hotImag = (UIImageView*)[backView viewWithTag:102];
    //    CGRect rect1 = hotImag.frame;
    UIImageView * newImag = (UIImageView*)[backView viewWithTag:103];
    if(![postInfo isKindOfClass:[PostListModel class]])
        return;
    
    _postInfo = postInfo;
    nameLabel.text = _postInfo.nickname; //昵称
    timeLabel.text = _postInfo.replyTime; //发帖时间
    numLabel.text = _postInfo.reply_num; //回复数
    numLabel.textColor = RGBACOLOR(253, 110, 60, 1);
    Titlelabel.text = [ConvertToCommonEmoticonsHelper convertToSystemEmoticons:_postInfo.subject]; //主题
    if (_postInfo.is_new == nil) {
        _postInfo.is_new = @"0";
    }else
    {
        NSLog(@"%@",_postInfo.is_new);
    }
    
    if ([_postInfo.is_pic isEqualToString:@"1"]) {
        imageHua.hidden = NO;
    }else{
        imageHua.hidden = YES;
        jinImag.frame = imageHua.frame;
        hotImag.frame = CGRectMake(jinImag.frame.origin.x+with+3, jinImag.frame.origin.y, with, with);
        newImag.frame = CGRectMake(hotImag.frame.origin.x+with+3, hotImag.frame.origin.y, with, with);
        Titlelabel.frame = CGRectMake(newImag.frame.origin.x+with+3, newImag.frame.origin.y,UIScreenWidth- newImag.frame.origin.x-newImag.frame.size.width, with);
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
        Titlelabel.frame = CGRectMake(newImag.frame.origin.x+with+3, newImag.frame.origin.y,UIScreenWidth- newImag.frame.origin.x-newImag.frame.size.width, with);
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
        Titlelabel.frame = CGRectMake(newImag.frame.origin.x+with+3, newImag.frame.origin.y, UIScreenWidth- newImag.frame.origin.x-newImag.frame.size.width, with);
    }
    if([_postInfo.is_new isEqualToString:@"1"])  // 新状态
    {
        newImag.hidden = NO;
        Titlelabel.frame = CGRectMake(newImag.frame.origin.x+with+3, newImag.frame.origin.y, UIScreenWidth- newImag.frame.origin.x-newImag.frame.size.width, with);
        
    }
    else
    {
        newImag.hidden = YES;
        Titlelabel.frame = CGRectMake(hotImag.frame.origin.x+with+3, newImag.frame.origin.y, UIScreenWidth- newImag.frame.origin.x-newImag.frame.size.width, with);
        
    }
    if ([_postInfo.is_jing isEqualToString:@"0"]&&[_postInfo.is_new isEqualToString:@"0"]&&[_postInfo.is_hot isEqualToString:@"0"]) {
        Titlelabel.frame = CGRectMake(imageHua.frame.origin.x+with+3, newImag.frame.origin.y, UIScreenWidth- newImag.frame.origin.x-newImag.frame.size.width, with);
        
    }else{
        NSLog(@"%@",timeLabel.text);
    }
    if ([_postInfo.is_jing isEqualToString:@"0"]&&[_postInfo.is_new isEqualToString:@"0"]&&[_postInfo.is_hot isEqualToString:@"0"]&&[_postInfo.is_pic isEqualToString:@"0"]) {
        Titlelabel.frame = CGRectMake(10, newImag.frame.origin.y, UIScreenWidth- newImag.frame.origin.x-newImag.frame.size.width, with);
    }else {
       NSLog(@"%@",timeLabel.text);
    }


}


@end
