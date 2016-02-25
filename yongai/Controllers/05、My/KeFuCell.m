//
//  KeFuCell.m
//  com.threeti
//
//  Created by alan on 15/10/12.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "KeFuCell.h"
#import "leftView.h"
#import "RightView.h"
#import "TTIFont.h"
#import "ConvertToCommonEmoticonsHelper.h"
@implementation KeFuCell
{
    leftView * left;
    RightView * right;
    GoodsInfoModel * goodsInfo;
    NSDateFormatter * formatter;
    NSCalendar * calendar;
    NSDateComponents * compoents;
    NSString * upTime;
    BOOL hiden;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        left = [[leftView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 100)];
        right = [[RightView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth,0)];
//        self.goodsBtn =
        self.goodsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.goodsBtn.frame = CGRectMake(55,30,UIScreenWidth - 130,80);
        [self.goodsBtn addTarget:self action:@selector(shangPinAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.goodsBtn];
        goodsInfo = [[GoodsInfoModel alloc] init];
        formatter = [[ NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        //设置时区,这个对于时间的处理有时很重要
        NSTimeZone * timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [formatter setTimeZone:timeZone];
        self.backgroundColor = BJCLOLR;
       calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        compoents = [[NSDateComponents alloc] init];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)cellWithMessage:(NSDictionary *) message withIndex:(NSString *)lineNumer andTimeStr:(NSString *)inserterTime
{
    NSString * ifself = [message objectForKey:@"ifself"];
    NSString * content = [message objectForKey:@"content"];
    NSString * time;
//    if (inserterTime != nil) {
//        time = inserterTime;
//    }else{
        time = [message objectForKey:@"time"];
//    }
    NSString * timeStr = [time stringByReplacingOccurrencesOfString:@"hidden" withString:@""];
    NSArray * timeArray1 = [timeStr componentsSeparatedByString:@" "];
    NSString * time1 = timeArray1[0];
    NSString * time2 = timeArray1[1];
    NSArray * timeArray2 = [time2 componentsSeparatedByString:@":"];
    NSArray * timeArray3 = [time1 componentsSeparatedByString:@"-"];
    NSString * time3 = timeArray3[2];
    //判断是上午还是下午，如果时针大于12是下午，小于12是上午
    //获取时针的时间
    NSString * shiZhen = timeArray2[0];
    NSString * xianShiTime;
    
    if (![time rangeOfString:@"hidden"].location) {
        hiden = YES;
        right.if_time = YES;
    }else{
        hiden = NO;
        right.if_time = NO;
    }
//    NSDate * date = [formatter dateFromString:timeStr];
    //获取当前时间
    NSDate * dateNow = [NSDate date];
    NSString * nowtimeStr = [formatter stringFromDate:dateNow];
    NSArray * nowtimeArray = [nowtimeStr componentsSeparatedByString:@" "];
    NSString * nowTime1 = nowtimeArray[0];
    NSArray * nowTimeArray1 = [nowTime1 componentsSeparatedByString:@"-"];
    NSString * nowTime2 = nowTimeArray1[2];
    //获取当前时间星期几
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    compoents = [calendar components:unitFlags fromDate:dateNow];
    int  week = [compoents weekday]-2;
    NSArray * weeks = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"];
    int chazhi = nowTime2.intValue - time3.intValue;
    NSString * xingQi = @"";
    if ((week - chazhi) < 0 || (week - chazhi) > 6) {
        xingQi = time1;
    }else{
    switch (chazhi) {
        case 0://今天
            xingQi = @"";
            break;
           case 1://昨天
            xingQi = @"昨天";
            break;
            case 2:
            xingQi = [weeks objectAtIndex:week-2];
            break;
            case 3:
            xingQi = [weeks objectAtIndex:week-3];
            break;
            case 4:
            xingQi = [weeks objectAtIndex:week-4];
            break;
            case 5:
            xingQi = [weeks objectAtIndex:week-5];
            break;
            case 6:
            xingQi = [weeks objectAtIndex:week-6];
            break;
        default:
            break;
    }
    }
        if (shiZhen.intValue < 12 || shiZhen.intValue == 12) {
            xianShiTime = [NSString stringWithFormat:@"%@ 上午 %@:%@",xingQi,timeArray2[0],timeArray2[1]];
        }else if (shiZhen.intValue > 12){
            NSInteger  xiaWuHour = [timeArray2[0] integerValue]-12;
            xianShiTime = [NSString stringWithFormat:@"%@ 下午 %ld:%@",xingQi,xiaWuHour,timeArray2[1]];
        }
    CGFloat with = [TTIFont calWidthWithText:xianShiTime font:[UIFont systemFontOfSize:15] limitWidth:20]+10;
    self.clicked = NO;
    if ([ifself isEqualToString:@"0"]) {
        self.goodsBtn.enabled = NO;
        right.hidden = YES;
        left.hidden = NO;
        left.contentLable.text = content;
        [left updataHeightAndWidth:content withIfTime:hiden];
        if (hiden == YES) {
            left.timeLabel.hidden = YES;
        }else if (hiden == NO){
            left.timeLabel.hidden = NO;

        }
        left.timeLabel.text = xianShiTime;
        left.timeLabel.frame = CGRectMake((UIScreenWidth - with)/2,5, with, 20);
        [left.LeftHeadView setImageWithURL:[NSURL URLWithString:[message objectForKey:@"sys_image"]] placeholderImage:[UIImage imageNamed:Default_UserHead]];
        [self.contentView addSubview:left];
    }else{
        
        left.hidden = YES;
        right.hidden = NO;
        right.contentLable.text = [ConvertToCommonEmoticonsHelper convertToSystemEmoticons:content];
        right.hide = self.shuaXin;
        if ([content rangeOfString:@"price"].location != NSNotFound) {
            self.clicked = YES;
            self.goodsBtn.enabled = YES;
            NSArray * array = [content componentsSeparatedByString:@";"];
            NSString * goodsid = [NSString stringWithFormat:@"%@",array[0]];
            goodsInfo.goods_id = [goodsid stringByReplacingOccurrencesOfString:@"goods_id=" withString:@""];
            self.goodsBtn.tag = goodsInfo.goods_id.integerValue;
            NSString * goodsName = [NSString stringWithFormat:@"%@",array[1]];
            goodsInfo.goods_name =[goodsName stringByReplacingOccurrencesOfString:@"goods_name=" withString:@""];
             NSString * imgurl = [NSString stringWithFormat:@"%@",array[2]];
            goodsInfo.img_url = [imgurl stringByReplacingOccurrencesOfString:@"img_url=" withString:@""];
            NSString * price = [NSString stringWithFormat:@"%@",array[3]];
            goodsInfo.price = [price stringByReplacingOccurrencesOfString:@"price=" withString:@""];
            NSString * market_price = [NSString stringWithFormat:@"%@",array[4]];
            goodsInfo.market_price = [market_price stringByReplacingOccurrencesOfString:@"market_price=" withString:@""];
            [right UpDateShangPinMessage:goodsInfo withIfTime:hiden];
        }else{
            self.goodsBtn.enabled = NO;
          [right updataHeightAndWidth:content withIndex:lineNumer withIfTime:hiden];
        }
        if (hiden == YES) {
            right.timeLabel.hidden = YES;
        }else if (hiden == NO){
            
            right.timeLabel.hidden = NO;
            right.timeLabel.text = xianShiTime;
            right.timeLabel.frame = CGRectMake((UIScreenWidth - with)/2,5, with, 20);
        }
        
        [self.contentView addSubview:right];
    }

}
- (void)shangPinAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(goodsAction:)]) {
        [self.delegate goodsAction:btn];
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
