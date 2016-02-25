//
//  MCProductPromotionCell.m
//  Yongai
//
//  Created by Kevin Su on 14-11-10.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MCProductPromotionCell.h"

@implementation MCProductPromotionCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        UIImageView * lineUp = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth,0.5)];
//        lineUp.backgroundColor = LINE;
//        [self.contentView addSubview:lineUp];
       
        UILabel * cuxiao = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 40, 20)];
        cuxiao.text = @"促销";
        cuxiao.font = [UIFont systemFontOfSize:14];
        cuxiao.textColor = TEXT;
        [self.contentView addSubview:cuxiao];
        NSArray * namearr = @[@"赠品",@"直降",@"运费",@"秒杀"];
        _pic1 = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenWidth - 20, 14, 8, 15)];
        _pic1.image = [UIImage imageNamed:@"common_cell_right_point"];
        [self.contentView addSubview:_pic1];
        for (int i = 0; i< 4; i++) {
             _imagePic = [[UIImageView alloc] initWithFrame:CGRectMake(cuxiao.frame.origin.x+45, 14+i*30, 40, 18)];
            _imagePic.tag = 100+i;
            _imagePic.backgroundColor = beijing;
            _imagePic.layer.masksToBounds = YES;
            _imagePic.layer.cornerRadius = 3;
            UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 18)];
            lable.text = namearr[i];
            lable.textColor = [UIColor whiteColor];
            lable.font = [UIFont systemFontOfSize:13];
            lable.textAlignment = NSTextAlignmentCenter;
            [_imagePic addSubview:lable];
//            if (i==3) {
                [self.contentView addSubview:_imagePic];
//            }
            
           _xLabel = [[UILabel alloc] initWithFrame:CGRectMake(_imagePic.frame.origin.x+45, _imagePic.frame.origin.y, 200, 20)];
            _xLabel.font = [UIFont systemFontOfSize:13];
            _xLabel.textColor = BLACKTEXT;
            _xLabel.tag = 200+i;
//            if (i == 3) {
//                _lineDown = [[UIImageView alloc] initWithFrame:CGRectMake(10,12+i*30+30, UIScreenWidth,0.5)];
//                _lineDown.backgroundColor = LINE;
//                [self.contentView addSubview:_lineDown];
//            }
            [self.contentView addSubview:_xLabel];
        }
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initWithGoodsInfo:(GoodsInfoModel *)goodsInfo withEndTime:(NSString *)endtime
{
    UIImageView  * zeng = (UIImageView*)[self viewWithTag:100];
    UIImageView  * jiang = (UIImageView*)[self viewWithTag:101];
    UIImageView * yun = (UIImageView *)[self viewWithTag:102];
    UILabel * zengLabel = (UILabel *)[self viewWithTag:200];
    UIImageView * miao = (UIImageView *)[self viewWithTag:103];
    NSString * str = @"点击查看";
    NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc ] initWithString:@"下单即送赠品,点击查看"];
    NSRange redRange = NSMakeRange([@"下单即送赠品," length], [str length]);
    [string1 addAttribute:NSForegroundColorAttributeName value:beijing range:redRange];
    [zengLabel setAttributedText:string1];
    UILabel * jiangLabel = (UILabel *)[self viewWithTag:201];
    UILabel * yunLabel = (UILabel *)[self viewWithTag:202];
    UILabel * miaoLabel = (UILabel *)[self viewWithTag:203];
    yunLabel.text = _yunFeiStr;
    if([goodsInfo.is_zeng intValue] == 1){
        
        zeng.hidden =NO;
        zengLabel.hidden = NO;
    }else{
        zeng.hidden = YES;
        zengLabel.hidden = YES;
        _pic1.hidden = YES;
        yun.frame = jiang.frame;
        yunLabel.frame =jiangLabel.frame;
//        _lineDown.frame = CGRectMake(10,yun.frame.origin.y+yun.frame.size.height+10, UIScreenWidth, 0.5);
        jiang.frame = zeng.frame;
        jiangLabel.frame = zengLabel.frame;
    }
    
    if([goodsInfo.is_down intValue] == 1){
        jiang.hidden = NO;
        jiangLabel.hidden = NO;
        NSString * str = goodsInfo.promotion_count;
        NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc ] initWithString:[NSString stringWithFormat:@"已直降%@元", goodsInfo.promotion_count]];
        NSRange redRange = NSMakeRange(3, [str length]);
        [string1 addAttribute:NSForegroundColorAttributeName value:beijing range:redRange];
        [jiangLabel setAttributedText:string1];
    }else{
        jiang.hidden = YES;
        jiangLabel.hidden = YES;
        yun.frame = jiang.frame;
        yunLabel.frame =jiangLabel.frame;
//        _lineDown.frame = CGRectMake(10,yun.frame.origin.y+yun.frame.size.height+10, UIScreenWidth, 0.5);
    }
    if (endtime.intValue == -1) {
        miao.hidden = YES;
        miaoLabel.hidden = YES;
    }else
    {
        if (goodsInfo.discount) {
            miaoLabel.frame = CGRectMake(yunLabel.frame.origin.x,yunLabel.frame.origin.y+yunLabel.frame.size.height+8, UIScreenWidth,20);
            NSString * str = [NSString stringWithFormat:@"%@折",goodsInfo.discount];
            NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc ] initWithString:[NSString stringWithFormat:@"%@限时抢", str]];
            NSRange redRange = NSMakeRange(0, [str length]);
            [string1 addAttribute:NSForegroundColorAttributeName value:beijing range:redRange];
            [miaoLabel setAttributedText:string1];
            miao.frame = CGRectMake(yun.frame.origin.x,yun.frame.origin.y+yun.frame.size.height+10, 40,18);
//            _lineDown.frame = CGRectMake(10,miao.frame.origin.y+miao.frame.size.height+10, UIScreenWidth, 0.5);
        }
        
    }
    if ([goodsInfo.is_down intValue] == 0 && [goodsInfo.is_zeng intValue] == 0 && endtime.intValue == -1) {
        yun.frame = zeng.frame;
        yunLabel.frame =zengLabel.frame;
//        _lineDown.frame = CGRectMake(10,yun.frame.origin.y+yun.frame.size.height+10, UIScreenWidth, 0.5);
    }
   
    
}


@end
