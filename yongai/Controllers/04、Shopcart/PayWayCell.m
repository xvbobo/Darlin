//
//  PayWayCell.m
//  Yongai
//
//  Created by arron on 14/11/5.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "PayWayCell.h"

@implementation PayWayCell

- (void)awakeFromNib {
    // Initialization code
    self.payWay.textColor = BLACKTEXT;
    self.huoDaoPay.textColor = BLACKTEXT;
    self.zhiFuBao.textColor = BLACKTEXT;
    self.weiXin.textColor = BLACKTEXT;
    self.order_line.backgroundColor = BJCLOLR;
    self.on_lineH.constant = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setPayment:(PaymentObject *)payment
{
    _payment = payment;
    self.codfreeLabel.text =[NSString stringWithFormat:@"满%@免运费", _payment.cod];
    self.alipayFreeLabel.text = [NSString stringWithFormat:@"满%@免运费", _payment.alipay];
     self.weiXinFreeLabel.text = [NSString stringWithFormat:@"满%@免运费", _payment.alipay];

}

- (IBAction)doChoicePayWay:(UIButton *)sender {
    UIButton *btn = (UIButton *)sender;
    // 若当前已选择改button则不处理
    if(btn.selected == YES)
        return;
    
    NSInteger index = 0;
    if(btn == self.codBtn)
    {
        self.codBtn.selected = YES;
        self.alipayBtn.selected = NO;
        index = 0;
    }
    else if (btn == self.alipayBtn)
    {
        self.codBtn.selected = NO;
        self.alipayBtn.selected = YES;
        index = 1;
    }else if (btn == self.weiXinBtn){
        self.codBtn.selected =NO;
        self.alipayBtn.selected = NO;
        self.weiXinBtn.selected = YES;
        index = 2;
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectPayWay:)])
        [self.delegate didSelectPayWay:index];
}

@end
