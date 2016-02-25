//
//  SureOderCell.m
//  Yongai
//
//  Created by arron on 14/11/5.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "SureOderCell.h"

@implementation SureOderCell

- (void)awakeFromNib {
    // Initialization code
    [self setup];
    self.shouHuoAdress.textColor = BLACKTEXT;
    self.shouHuoPeople.textColor = TEXT;
    self.shouji.textColor = TEXT;
    self.dizhi.textColor = TEXT;
    self.consigneeLabel.textColor = TEXT;
    self.mobileLabel.textColor = TEXT;
    self.addressLabel.textColor = TEXT;
    self.jinBiDi.textColor = BLACKTEXT;
    self.goodsMoney.textColor = BLACKTEXT;
    self.moneyFirst.textColor = BLACKTEXT;
    self.yunMoney.textColor = BLACKTEXT;
    self.useJinBi.textColor = BLACKTEXT;
    self.canUseGoldLabel.textColor = BLACKTEXT;
    self.keYongJinBi.textColor = BLACKTEXT;
    self.goldCountTextFiled.textColor = BLACKTEXT;
    self.addressMarginView.backgroundColor = BJCLOLR;
    self.priceMarginView.backgroundColor = BJCLOLR;
    self.addAddressMarginView.backgroundColor = BJCLOLR;
    self.goldMarginView.backgroundColor= BJCLOLR;
    self.addressLabel.numberOfLines = 0;
    self.priceMarginView.layer.borderWidth = 0.5;
    self.priceMarginView.layer.borderColor = LINE.CGColor;
    self.addAddressMarginView.layer.borderWidth = 0.5;
    self.addAddressMarginView.layer.borderColor = LINE.CGColor;
    self.goldMarginView.layer.borderWidth = 0.5;
    self.goldMarginView.layer.borderColor = LINE.CGColor;
    self.order_line1.backgroundColor = BJCLOLR;
    self.order_line2.backgroundColor = BJCLOLR;
    self.order_line3.backgroundColor = BJCLOLR;
    self.order_line1H.constant = 0.5;
    self.order_line2H.constant = 0.5;
    self.order_line3H.constant = 0.5;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setup
{
    if(_goldCountTextFiled != nil)
    {
        _goldCountTextFiled.delegate =self;
        _goldCountTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    }
}

- (IBAction)minusBtnClick:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(changeGoldNum:)])
        [self.delegate changeGoldNum:_goldCountTextFiled.text.intValue -1];
}

- (IBAction)addBtnClick:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(changeGoldNum:)])
        [self.delegate changeGoldNum:_goldCountTextFiled.text.intValue +1];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(changeGoldNum:)])
        [self.delegate changeGoldNum:_goldCountTextFiled.text.intValue];
    return YES;
}
@end
