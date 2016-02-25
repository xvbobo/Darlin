//
//  ExchangeGoodsCell.m
//  Yongai
//
//  Created by myqu on 14/11/13.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "ExchangeGoodsCell.h"

@implementation ExchangeGoodsCell

- (void)awakeFromNib {
    // Initialization code
    self.goodsNameLabel0.textColor = BLACKTEXT;
    self.goodsNameLabel1.textColor = BLACKTEXT;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setgoodsInfo:(ExchangeListModel *)goods1 goods2:(ExchangeListModel *)goods2
{
    _goodsGoldLabel0.text = goods1.exchange_integral;
    _goodsNameLabel0.text = goods1.goods_name;
    [_goodsImgView0 setImageWithURL:[NSURL URLWithString:goods1.img_url] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
    
    
    if(goods2 != nil)
    {
        _goodsGoldLabel1.text = goods2.exchange_integral;
        _goodsNameLabel1.text = goods2.goods_name;
        [_goodsImgView1 setImageWithURL:[NSURL URLWithString:goods2.img_url] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
        
        _goodsBgView1.hidden = NO;
    }
    else
    {
        _goodsBgView1.hidden = YES;
    }
    
}

- (IBAction)goodsBtnClick0:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickGoodsCell:)])
        [self.delegate didClickGoodsCell:btn.tag];
}

- (IBAction)goodsBtnClick1:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickGoodsCell:)])
        [self.delegate didClickGoodsCell:btn.tag];
}

@end
