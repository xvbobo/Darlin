//
//  ShoppingCartCell.m
//  Yongai
//
//  Created by arron on 14/11/2.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "ShoppingCartCell.h"

@implementation ShoppingCartCell

- (void)awakeFromNib {
    // Initialization code
    _marginView.backgroundColor = BJCLOLR;
    _number.textColor = BLACKTEXT;
//    _goodCountBtn.titleLabel.textColor = BLACKTEXT;
    _goodPriceLabel.textColor = beijing;
    _goodsNameLabel.textColor = BLACKTEXT;
    _goodsPropertiesLabel.textColor = BLACKTEXT;
    _goodsStateLabel.textColor = BLACKTEXT;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 点击加减商品数量
- (IBAction)doAddOrPlusCount:(UIButton *)sender
{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(updateGoodsCountWithRow:goodsCount:)])
    {
        [self.delegate updateGoodsCountWithRow:self.tag goodsCount:self.goodCountBtn.titleLabel.text];
    }
}

- (IBAction)doSelectCurrentCell:(UIButton *)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(selectGoodsCell:status:)])
    {
        [self.delegate selectGoodsCell:self.tag status:btn.selected];
    }
}

-(void)setGoodsInfo:(CartListGoodsModel *)goodsInfo
{
    _goodsInfo = goodsInfo;
    
    [_goodsImageView setImageWithURL: [NSURL URLWithString:_goodsInfo.img_url] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
    _goodsNameLabel.text = _goodsInfo.goods_name;
    _goodsPropertiesLabel.text = _goodsInfo.attr_value;
    [_goodCountBtn setTitle:_goodsInfo.goods_number forState:UIControlStateNormal];
    [_goodCountBtn setTitleColor:BLACKTEXT forState:UIControlStateNormal];
    _goodPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", _goodsInfo.goods_price.floatValue];
    
    if([_goodsInfo.bSelect isEqualToString:@"1"])
        _cartSelBtn.selected = YES;
    else
        _cartSelBtn.selected = NO;
    
    _goodsStateLabel.text = _goodsInfo.goods_status;
    
    if([goodsInfo.is_zeng intValue] == 1){
        
        self.iconZengView.hidden = NO;
    }
    else{
        self.iconZengView.hidden = YES;
        _zengW.constant = 0;
        _jiangLeft.constant = 0;
    }
    
    if([goodsInfo.is_down intValue] == 1){
        
        self.iconJiangView.hidden = NO;
    }
    else
        self.iconJiangView.hidden = YES;
}
@end
