//
//  MiaoShaCell.m
//  com.threeti
//
//  Created by alan on 15/7/16.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import "MiaoShaCell.h"
#import "TTIFont.h"
#define red  RGBACOLOR(242, 87, 87, 1)
@implementation MiaoShaCell

- (void)awakeFromNib {
    self.imageH.constant = 110;
    self.imageW.constant = 110;
    self.pnameLabel.font = [UIFont systemFontOfSize:15];
    self.pnameLabel.numberOfLines = 2;
    self.discountLabel.backgroundColor = red;
    self.discountLabel.layer.masksToBounds = YES;
    self.discountLabel.layer.cornerRadius = 3;
    self.priceLabel.textColor = red;
    self.qiangGou.backgroundColor = red;
    self.qiangGou.layer.masksToBounds = YES;
    self.qiangGou.layer.cornerRadius = 5;
//    self.namelabelTop.constant = 0;
    self.priceLabel.font = [UIFont systemFontOfSize:14];
    self.marketPriceLabel.textColor = TEXT;
//    self.priceBottom.constant = 10;
    self.zheKouTop.constant = 60;
//    self.markpricebottom.constant = 8;
//    self.buttonBottom.constant = 15;
    if (UIScreenWidth > 320) {
//         self.imageTop.constant = 15;
        self.buttonW.constant = 75;
         self.btn.titleLabel.font = [UIFont systemFontOfSize:17];
    }else{
//        self.imageTop.constant = 25;
        self.buttonW.constant = 60;
        self.btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
    }
//    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    self.shouQinLabel.backgroundColor = RGBACOLOR(46, 46, 46, 0.7);
    self.shouQinLabel.textAlignment = NSTextAlignmentCenter;
    self.shouQinLabel.textColor = [UIColor whiteColor];
    self.shouQinLabel.text =@"已售罄";
    self.shouQinLabel.layer.masksToBounds = YES;
    self.shouQinLabel.layer.cornerRadius = (self.imageW.constant-40)/2;
//    lable.center = self.picImageView.center;
//    [self.picImageView addSubview:lable];
    [self.qiangGou setTitle:@"去抢购" forState:UIControlStateNormal];
    [self.qiangGou setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)initDataWithDictionary:(NSDictionary *)dataDic{
    NSString * str = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"amount"]];
    NSLog(@"%@",str);
    self.qiangGou.tag = [dataDic[@"goods_id"] intValue];
    if ([str isEqualToString:@"0"]) {
        [self.qiangGou setTitle:@"已抢光" forState:UIControlStateNormal];
        self.qiangGou.backgroundColor = RGBACOLOR(221, 221, 221, 1);
    }else
    {
        self.shouQinLabel.hidden = YES;
    }
    
    [self.picImageView setImageWithURL:[NSURL URLWithString:dataDic[@"img_url"]]];
    self.pnameLabel.text = dataDic[@"goods_name"];   
    self.discountLabel.text = [NSString stringWithFormat:@"%@折", dataDic[@"discount"]];
    self.discountW.constant = [TTIFont calWidthWithText:self.discountLabel.text font:[UIFont systemFontOfSize:17] limitWidth:24];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", dataDic[@"act_price"]];
    self.marketPriceLabel.text = [NSString stringWithFormat:@"%@", dataDic[@"price"]];
    self.priceW.constant =[TTIFont calWidthWithText:self.priceLabel.text font:[UIFont systemFontOfSize:15] limitWidth:24];
    self.markpriceW.constant = [TTIFont calWidthWithText:self.marketPriceLabel.text font:[UIFont systemFontOfSize:14] limitWidth:24];
}

- (IBAction)cellBtnClick:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(cellBtnClickByRow:)])
        [self.delegate cellBtnClickByRow:self.qiangGou.tag];
}

@end
