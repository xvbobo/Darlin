//
//  OderGoodsCell.m
//  Yongai
//
//  Created by arron on 14/11/6.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "OderGoodsCell.h"

@implementation OderGoodsCell

- (void)awakeFromNib {
    // Initialization code
    self.goodsNameLabel.textColor = BLACKTEXT;
    self.goodsSpecLabel.textColor = TEXT;
    self.goodsCountLabel.textColor = BLACKTEXT;
//    self.goodsCountBtn.titleLabel.textColor = BLACKTEXT;
    self.guiGe.textColor = TEXT;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setGoodsInfo:(CartListGoodsModel *)goodsInfo
{
    _goodsInfo = goodsInfo;
 
    [_goodsImgView setImageWithURL: [NSURL URLWithString:_goodsInfo.img_url] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
    [_goodsNameLabel setText:_goodsInfo.goods_name];
    [_priceLabel setText:[NSString stringWithFormat:@"￥%@", _goodsInfo.goods_price]];
    
    [_goodsSpecLabel setText:_goodsInfo.attr_value];
    [_goodsCountLabel setText:[NSString stringWithFormat:@"×%@", _goodsInfo.goods_number]];
    if([_goodsInfo.is_zeng isEqualToString:@"0"])
        _zengTagImg.hidden = YES;
    else
        _zengTagImg.hidden = NO;
    
    if([_goodsInfo.is_down isEqualToString:@"0"])
        _dropTagImg.hidden = YES;
    else
        _dropTagImg.hidden = NO;
}

-(void)setGiftInfo:(GiftGoodsModel *)giftInfo
{
    _giftInfo = giftInfo;
    [_goodsImgView setImageWithURL: [NSURL URLWithString:_giftInfo.img_url] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
    [_goodsNameLabel setText:_giftInfo.goods_name];
    
    if(_giftInfo.price == nil)
        [_priceLabel setText:@"￥0"];
    else
        [_priceLabel setText:[NSString stringWithFormat:@"￥%@", _giftInfo.price]];
    
    [_goodsCountBtn setTitle:[NSString stringWithFormat:@"数量%@个", _giftInfo.goods_number] forState:UIControlStateNormal];
    [_goodsCountBtn setTitleColor:BLACKTEXT forState:UIControlStateNormal];
}

@end
