//
//  AddressListCell.m
//  Yongai
//
//  Created by arron on 14/11/5.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "AddressListCell.h"
#import "TTIFont.h"
@implementation AddressListCell

- (void)awakeFromNib {
    // Initialization code
    _nameLabel.textColor= BLACKTEXT;
    _nameLabel.numberOfLines = 0;
    _phoneLabel.textColor = BLACKTEXT;
    _addressLabel.textColor = BLACKTEXT;
    _footerView.backgroundColor = BJCLOLR;
}


-(void)setAddrInfo:(AddressModel *)addrInfo
{
    _addrInfo = addrInfo;
    _nameLabel.text = _addrInfo.consignee;
    CGFloat nameHeight = [TTIFont calHeightWithText:_nameLabel.text font:[UIFont systemFontOfSize:15.0] limitWidth:UIScreenWidth - 40];
    self.nameH.constant = nameHeight;
    _addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@", _addrInfo.province_name, _addrInfo.city_name, _addrInfo.address];
    CGFloat addH = [TTIFont calHeightWithText:_addressLabel.text font:[UIFont systemFontOfSize:15.0] limitWidth:UIScreenWidth - 40];
    self.addressH.constant = addH;
    _phoneLabel.text = _addrInfo.mobile;
    
    if([_addrInfo.default_address isEqualToString:@"1"])
        _defaultAddrBtn.selected = YES;
    else
        _defaultAddrBtn.selected = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
////选中当前地址
- (IBAction)doSelectCurrentAddress:(UIButton *)sender {
    BOOL bSelect = _defaultAddrBtn.selected;
    if(bSelect == YES)
        return;
    else
    {
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(selectDefaultAddress:)])
        {
            [self.delegate selectDefaultAddress:self.tag];
        }
    }
    
}
//编辑当前地址
- (IBAction)doEditCurrentAddress:(UIButton *)sender {
    
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(editCurrentAddress:)])
    {
        [self.delegate editCurrentAddress:self.tag];
    }
}

@end
