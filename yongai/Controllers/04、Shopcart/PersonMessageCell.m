//
//  PersonMessageCell.m
//  com.threeti
//
//  Created by alan on 15/11/2.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "PersonMessageCell.h"
#import "TTIFont.h"
@implementation PersonMessageCell
{
    UILabel * personName;
    UILabel * phoneNum;
    UILabel * addressLabel;
    UIImageView * imageview;
    UIImageView * image2;
    UILabel * noAddressLabel;
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        noAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake((UIScreenWidth-100)/2,30, 100, 20)];
        noAddressLabel.text = @"暂无收货地址";
        noAddressLabel.textColor = BLACKTEXT;
        noAddressLabel.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:noAddressLabel];
        imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 30, 20, 25)];
        imageview.image = [UIImage imageNamed:@"地图"];
        [self addSubview:imageview];
        personName = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, UIScreenWidth-140, 20)];
        personName.numberOfLines = 0;
        personName.textColor = BLACKTEXT;
        personName.font = [UIFont systemFontOfSize:15.0];
//        personName.text = @"收货人：赵培";
        [self addSubview:personName];
        phoneNum = [[UILabel alloc] initWithFrame:CGRectMake(UIScreenWidth - 100,12, 90, 20)];
//        phoneNum.text = @"18221527025";
        phoneNum.textColor = BLACKTEXT;
        phoneNum.font = [UIFont systemFontOfSize:13.0];
        [self addSubview:phoneNum];
        addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, personName.frame.origin.y+personName.frame.size.height+20, UIScreenWidth-70, 20)];
//        addressLabel.text = @"收货地址：上海市 嘉定区 江桥镇 金沙江西路1555弄20号4楼";
        addressLabel.textColor = BLACKTEXT;
        addressLabel.numberOfLines = 0;
        addressLabel.font = [UIFont systemFontOfSize:13.0];
        [self addSubview:addressLabel];
        self.layer.borderColor = RGBACOLOR(254, 210, 195, 1).CGColor;
        self.layer.borderWidth = 0.5;
        self.backgroundColor = RGBACOLOR(255, 250, 243,1);
        UIImageView * image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"上横条"]];
        image1.frame = CGRectMake(0,0, UIScreenWidth,4);
        [self addSubview:image1];
        image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"下横条"]];
        
        [self addSubview:image2];
    }
    return self;
}
- (void)initWithModel:(AddressModel*) model withAdressString:(NSString *)adString
{
    if (model == nil) {
        noAddressLabel.hidden = NO;
    }else{
        noAddressLabel.hidden = YES;
        personName.text = [NSString stringWithFormat:@"收货人：%@",model.consignee];
        CGFloat PersonHeight = [TTIFont calHeightWithText:model.consignee font:[UIFont systemFontOfSize:15.0] limitWidth:UIScreenWidth/2];
        personName.frame = CGRectMake(50,15, UIScreenWidth -150, PersonHeight);
//        personName.backgroundColor = beijing;
        addressLabel.text = [NSString stringWithFormat:@"收货地址：%@ %@ %@",model.province_name,model.city_name,model.address];
        CGFloat Height = [TTIFont calHeightWithText:addressLabel.text font:[UIFont systemFontOfSize:13.0] limitWidth:UIScreenWidth - 70];
        addressLabel.frame = CGRectMake(50, personName.frame.origin.y+personName.frame.size.height+8, UIScreenWidth-70, Height);
        phoneNum.text = model.mobile;
        phoneNum.frame = CGRectMake(UIScreenWidth - 100,personName.frame.origin.y, 90, 15);
        
    }
    
}
- (void)upDateCellWith:(CGFloat)cellHeight
{
    imageview.center = CGPointMake(35/2, cellHeight/2);
    image2.frame = CGRectMake(0,cellHeight-4, UIScreenWidth,4);

}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
