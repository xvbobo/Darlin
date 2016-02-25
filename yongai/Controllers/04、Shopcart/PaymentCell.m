//
//  PaymentCell.m
//  Yongai
//
//  Created by myqu on 14/12/2.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "PaymentCell.h"

@implementation PaymentCell

- (void)awakeFromNib {
    // Initialization code
//    self.orderActionBtn.backgroundColor = beijing;
    self.dingDanNum.textColor = BLACKTEXT;
    self.dingDanStatus.textColor = BLACKTEXT;
    self.yunMoney.textColor = BLACKTEXT;
    self.invoice.textColor = BLACKTEXT;
    self.dingMoney.textColor = BLACKTEXT;
    self.shangMessage.textColor = BLACKTEXT;
    self.shangMoney.textColor = BLACKTEXT;
    self.jinDi.textColor = BLACKTEXT;
    self.xianKuan.textColor = BLACKTEXT;
    self.zhiFuMethod.textColor = BLACKTEXT;
    self.peiSongMethod.textColor = BLACKTEXT;
    self.goodsCountLabel.textColor = TEXT;
    self.goodsNameLabel.textColor = BLACKTEXT;
    self.consigneeLabel.textColor = BLACKTEXT;
    self.mobileLabel.textColor = BLACKTEXT;
    self.addressLabel.textColor = BLACKTEXT;
    self.payWayLabel.textColor = TEXT;
    self.deliveryWayLabel.textColor = BLACKTEXT;
    self.goodsSpecLabel.textColor = BLACKTEXT;
    self.invoiceLable.textColor = BLACKTEXT;
    self.orderNoLabel.textColor = BLACKTEXT;
    self.yunDanHao.hidden = YES;
    self.checkDetail.layer.masksToBounds = YES;
    self.checkDetail.layer.cornerRadius = 5;
    self.checkDetail.backgroundColor = beijing;
    self.addressLabel.font = [UIFont systemFontOfSize:15];
    self.lineW.constant = UIScreenWidth*2;
    self.linrH.constant = 0.5;
    self.imageLine.backgroundColor = BJCLOLR;
    self.pay_line.backgroundColor = LINE;
    self.pay_lineH.constant = 0.5;
    self.order_money_line.backgroundColor = LINE;
    self.order_money_lineH.constant = 0.5;
    [self.checkDetail setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


// 商品信息cell
-(void)setGoodsInfo:(CartListGoodsModel *)goodsInfo
{
    _goodsInfo = goodsInfo;
    [_goodsImgView setImageWithURL:[NSURL URLWithString:_goodsInfo.img_url] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
    _goodsNameLabel.text = _goodsInfo.goods_name;
    _goodsCountLabel.text =[NSString stringWithFormat:@"数量  %@", _goodsInfo.goods_number];
    
    _goodsSpecLabel.text = _goodsInfo.attr_value;
}
- (void)createdWuliuDetail:(NSString*)yundanNumber
{
    
}


@end
