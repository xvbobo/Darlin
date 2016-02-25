//
//  FlashSaleCell.m
//  Yongai
//
//  Created by Kevin Su on 14/11/19.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "FlashSaleCell.h"
#import "QFControl.h"
#import "CommonHelper.h"
#import "TTIFont.h"
@implementation FlashSaleCell{
    int timeCount;
    int shijiandao;
    NSMutableArray * timeArr;
    NSArray * TMArr;
    NSArray * newArr;
    BOOL _isFirst;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        shijiandao = 0;
        _isFirst = YES;
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 60, 30)];
        label.textColor = RGBACOLOR(231, 71, 55, 1);
        label.text = @"秒杀";
        label.font = font(20);
        [self.contentView addSubview:label];
        UILabel * shijian = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x+label.frame.size.width, 5, 100, 30)];
        shijian.text = @"距离本期结束";
        shijian.font = [UIFont systemFontOfSize:15];
        shijian.textColor = BLACKTEXT;
        [self.contentView addSubview:shijian];
        for (int i= 0; i< 3; i++) {
            self.labelTime = [[UILabel alloc] initWithFrame:CGRectMake(shijian.frame.origin.x+shijian.frame.size.width+i*30,5,25, 30)];
            self.labelTime.tag = 100+i;
            self.labelTime.backgroundColor = RGBACOLOR(56, 60, 60, 1);
            self.labelTime.textColor = [UIColor whiteColor];
            self.labelTime.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:self.labelTime];
            if (i != 2) {
                UILabel * maoHao = [[UILabel alloc] initWithFrame:CGRectMake(self.labelTime.frame.origin.x+self.labelTime.frame.size.width-1,5,10,30)];
                maoHao.text=@":";
                maoHao.font = font(17);
                maoHao.textColor =  RGBACOLOR(56, 60, 60, 1);
                [self.contentView addSubview:maoHao];
            }
            int a = (UIScreenWidth - 30)/3-10;
            UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(20+i*(a+15),50, a-10, a-10)];
//            image.backgroundColor = BJCLOLR;
            image.userInteractionEnabled = YES;
            image.tag = 1000+i;
            [self.contentView addSubview:image];
            
            if (i!=2) {
                UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(image.frame.origin.x+image.frame.size.width+10, image.frame.origin.y+20,0.5, image.frame.size.height/2)];
                if (i==1) {
                    line.frame =CGRectMake(image.frame.origin.x+image.frame.size.width+10, image.frame.origin.y+20,0.5, image.frame.size.height/2);
                }
                line.backgroundColor = RGBACOLOR(224, 215, 207,0.6);
                [self.contentView addSubview:line];
            }
            
            
            UILabel * lable1 = [[UILabel alloc] init];
            lable1.tag = 200+i;
            lable1.textColor = BLACKTEXT;
            lable1.font = [UIFont systemFontOfSize:14];
            lable1.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:lable1];
            UILabel * lable2= [[UILabel alloc] init];
            lable2.tag = 300+i;
            lable2.layer.masksToBounds = YES;
            lable2.layer.cornerRadius = 10;
            lable2.backgroundColor = RGBACOLOR(242, 87, 87, 1);
            lable2.textColor = [UIColor whiteColor];
            lable2.textAlignment = NSTextAlignmentCenter;
            lable2.font = [UIFont systemFontOfSize:12];
            [self.contentView addSubview:lable2];
            
        }

       
    }
    return self;
}
- (void)imageClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(imageClick:)]) {
        [self.delegate imageClick:[NSString stringWithFormat:@"%ld",(long)button.tag]];
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

- (void)initWithArray:(NSArray *)array
{
    UIImageView * image1 = (UIImageView*)[self viewWithTag:1000];
     UIImageView * image2 = (UIImageView*)[self viewWithTag:1001];
     UIImageView * image3 = (UIImageView*)[self viewWithTag:1002];
    UILabel * priceLable1 = (UILabel*)[self viewWithTag:200];
    UILabel * priceLable2 = (UILabel*)[self viewWithTag:201];
    UILabel * priceLable3 = (UILabel*)[self viewWithTag:202];
    UILabel * dicountLable1 = (UILabel*)[self viewWithTag:300];
    UILabel * dicountLable2 = (UILabel*)[self viewWithTag:301];
    UILabel * dicountLable3 = (UILabel*)[self viewWithTag:302];
    NSMutableArray * numberArr = [[NSMutableArray alloc] init];
    newArr = [[NSMutableArray alloc] init];
     timeArr = [[NSMutableArray alloc] init];
    for (int i= 0; i< array.count; i++) {
        NSDictionary * dict = [array objectAtIndex:i];
        NSString * number = [dict objectForKey:@"amount"];
        int f = number.intValue;
        [numberArr addObject:[NSNumber numberWithInt:f]];
        NSString * time = dict[@"count_down_time"];
        [timeArr addObject:[NSNumber numberWithInt:time.intValue]];
    }
    newArr = [numberArr sortedArrayUsingSelector:@selector(compare:)];
    TMArr = [timeArr sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray * dictArr = [[NSMutableArray alloc] init];
    for (int d=0; d< array.count; d++) {
         NSDictionary * dict1 = array[d];
        [dictArr addObject:dict1];

    }
    if (_isFirst == YES) {
        //建议使用GCD
        [NSThread detachNewThreadSelector:@selector(TimeNSthread) toTarget:self withObject:nil];
        [self createNSTimer:0];
    }
    _isFirst = NO;
    
    
    int countdict;
    if (dictArr.count > 4) {
        countdict = 3;
    }else
    {
        countdict = dictArr.count;
    }
    for (int i = 0; i<countdict; i++) {
        NSDictionary * dict = [dictArr objectAtIndex:i];
         UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString * urlStr = dict[@"logo"];
        NSString * discountStr = [NSString stringWithFormat:@"%@折",dict[@"discount"]];
        int with2 = [TTIFont calWidthWithText:[NSString stringWithFormat:@"%@折",dict[@"discount"]] font:[UIFont systemFontOfSize:12] limitWidth:20]+5;
        int with1 = [TTIFont calWidthWithText:[NSString stringWithFormat:@"￥%@",dict[@"price"]] font:[UIFont systemFontOfSize:13] limitWidth:20]+5;
        if (i==0) {
             [image1 setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
            button.frame = image1.bounds;
            [image1 addSubview:button];
            priceLable1.text = [NSString stringWithFormat:@"￥%@",dict[@"price"]];
            priceLable1.frame = CGRectMake(0, 0, with1, 20);
            priceLable1.center = CGPointMake(image1.center.x, image1.center.y+image1.frame.size.height/2+10);
            dicountLable1.text = discountStr;
            dicountLable1.frame = CGRectMake(0, 0, with2, 20);
            dicountLable1.center = CGPointMake(priceLable1.center.x, priceLable1.center.y+priceLable1.frame.size.height);
        }else if (i==1){
             [image2 setImageWithURL:[NSURL URLWithString:dict[@"logo"]] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
            button.frame = image2.bounds;
            [image2 addSubview:button];
            priceLable2.text = [NSString stringWithFormat:@"￥%@",dict[@"price"]];
            priceLable2.frame = CGRectMake(0, 0, with1, 20);
            priceLable2.center = CGPointMake(image2.center.x, image2.center.y+image2.frame.size.height/2+10);
             dicountLable2.text = discountStr;
            dicountLable2.frame = CGRectMake(0, 0, with2, 20);
            dicountLable2.center = CGPointMake(priceLable2.center.x, priceLable2.center.y+priceLable2.frame.size.height);
        }else if(i == 2) {
             [image3 setImageWithURL:[NSURL URLWithString:dict[@"logo"]] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
             dicountLable3.text = discountStr;
            
            button.frame = image3.bounds;
            [image3 addSubview:button];
            priceLable3.text = [NSString stringWithFormat:@"￥%@",dict[@"price"]];
            priceLable3.frame = CGRectMake(0, 0, with1, 20);
            priceLable3.center = CGPointMake(image3.center.x, image3.center.y+image3.frame.size.height/2+10);
            dicountLable3.frame = CGRectMake(0, 0, with2, 20);
            dicountLable3.center = CGPointMake(priceLable3.center.x, priceLable3.center.y+priceLable3.frame.size.height);
        }
        NSString * tg =[dict objectForKey:@"id"];
        button.tag = tg.integerValue;
        [button addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
}
- (void)createEndTime:(NSString *)endTime
{
    timeCount = endTime.intValue;
}
- (void)TimeNSthread
{
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop]run];

    
}
- (void)createNSTimer:(int)b
{
    self.stringTime = [TMArr objectAtIndex:b];
    timeCount = self.stringTime.intValue;
    
}
- (void)timeDown
{
   
    timeCount--;
    if (timeCount == 0) {
        [self createNSTimer:shijiandao++];
    }
    int H = timeCount/3600;
    int m = (timeCount%3600)/60;
    int s = (timeCount%3600)%60;
    UILabel * label1 = (UILabel*)[self viewWithTag:100];
    label1.text = [NSString stringWithFormat:@"%02d",H];
    UILabel * label2 = (UILabel*)[self viewWithTag:101];
    label2.text = [NSString stringWithFormat:@"%02d",m];
    UILabel * label3 = (UILabel*)[self viewWithTag:102];
    label3.text = [NSString stringWithFormat:@"%02d",s];
    
}
@end
