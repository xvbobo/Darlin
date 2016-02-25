//
//  MyCollectCell.m
//  Yongai
//
//  Created by myqu on 14/11/7.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MyCollectCell.h"

@implementation MyCollectCell

- (void)awakeFromNib {
    // Initialization code
    [self setup];
    self.nameLabel.textColor = BLACKTEXT;
    self.marketPriceLabel.textColor = BLACKTEXT;
    self.shiChangPrice.textColor = TEXT;
    self.priceLabel.textColor = beijing;
}

-(void)setup
{
    _isZengTagImgView.hidden = YES;
    _isDownTagImgView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setGoodsInfo:(GoodModel *)goodsInfo
{
    _goodsInfo = goodsInfo;
    
    [_goodsImgView setImageWithURL:[NSURL URLWithString:_goodsInfo.image_url] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
    _nameLabel.text = _goodsInfo.name;
    _priceLabel.text = [NSString stringWithFormat:@"￥%.2f", _goodsInfo.shop_price.floatValue];
    _marketPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",_goodsInfo.market_price.floatValue];
    
}
@end
