//
//  InvoiceInfoCell.m
//  Yongai
//
//  Created by arron on 14/11/5.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "InvoiceInfoCell.h"

@implementation InvoiceInfoCell

- (void)awakeFromNib {
    // Initialization code
    _InvoiceTextFiled.delegate = self;
    self.faPiaoNeiRong.textColor = BLACKTEXT;
    self.faPiaoTaitou.textColor = BLACKTEXT;
    self.faPiaoXinxi.textColor = BLACKTEXT;
    self.geren.textColor = BLACKTEXT;
    self.banGong.textColor = BLACKTEXT;
    self.shangpin.textColor = BLACKTEXT;
    self.danWei.textColor = BLACKTEXT;
    self.invoiveMarginView.layer.borderWidth = 0.5;
    self.invoiveMarginView.layer.borderColor = LINE.CGColor;
    self.InvoiceTextFiled.textColor = BLACKTEXT;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)invoiceTypeBtnClick:(id)sender {
    
    if(!self.delegate)
        return;
    
    UIButton *btn = (UIButton *)sender;
    if(btn.selected == YES)
    {
        btn.selected = NO;
        if(self.delegate && [self.delegate respondsToSelector:@selector(selectInvoiceType:)])
            [self.delegate selectInvoiceType:nil];
        return;
    }
    
    NSString *type;
    if(btn == _personalBtn)
    {
        type = @"1";
        _personalBtn.selected =YES;
        _companyBtn.selected = NO;
    }
    else
    {
        type = @"2";
        _companyBtn.selected = YES;
        _personalBtn.selected = NO;
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(selectInvoiceType:)])
        [self.delegate selectInvoiceType:type];
}

- (IBAction)invoiceContentBtnClick:(id)sender
{
    if(!self.delegate)
        return;
    
    UIButton *btn = (UIButton *)sender;
    if(btn.selected == YES)
    {
        btn.selected = NO;
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(selectInvoiceContent:)])
            [self.delegate selectInvoiceContent:nil];
        
        return;
    }
    
    NSString *content;
    if(btn == _productDetailsBtn)
    {
        content = @"1";
        _productDetailsBtn.selected =YES;
        _officeBtn.selected = NO;
    }
    else
    {
        content = @"2";
        _officeBtn.selected = YES;
        _productDetailsBtn.selected = NO;
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(selectInvoiceContent:)])
        [self.delegate selectInvoiceContent:content];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(updateInvoiceText:)])
        [self.delegate updateInvoiceText:textField.text];
    
    return YES;
}
@end
