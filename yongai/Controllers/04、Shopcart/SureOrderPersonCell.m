//
//  SureOrderPersonCell.m
//  com.threeti
//
//  Created by alan on 15/11/26.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "SureOrderPersonCell.h"
#import "TTIFont.h"
@implementation SureOrderPersonCell
{
    UILabel * messageLaebl;
    UIImageView * backImageView;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createInterFace];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
         self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundColor = BJCLOLR;
    }
    return self;
}
- (void)createInterFace
{
    backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 7, UIScreenWidth, 100)];
    backImageView.backgroundColor = [UIColor whiteColor];
    backImageView.layer.borderColor = LINE.CGColor;
    backImageView.layer.borderWidth = 0.5;
    for (int i = 0; i< 4; i++) {
        UILabel * label = [[UILabel alloc] init];
        if (i==0) {
            label.frame = CGRectMake(10, 0, UIScreenWidth-20, 40);
            label.text = @"收货人地址：";
            label.font = font(15);
            label.textColor = BLACKTEXT;
            UIImageView * lineView = [[UIImageView alloc] initWithFrame:CGRectMake(10, label.frame.size.height, UIScreenWidth - 20,0.5)];
            lineView.backgroundColor = LINE;
            [backImageView addSubview:lineView];
        }else{
            label.tag = 100+i;
            label.numberOfLines = 0;
            label.textColor = TEXT;
            label.font = [UIFont systemFontOfSize:14.0];
        }
        [backImageView addSubview:label];
    }
    [self.contentView addSubview:backImageView];
    
}
- (void)updateMessageWithName:(NSString *) name andNumber:(NSString*)phoneNumber andAddress:(NSString *)address
{
    UILabel * namelabel = (UILabel*)[backImageView viewWithTag:101];
    UILabel * phoneLabel = (UILabel*)[backImageView viewWithTag:102];
    UILabel * addressLabel = (UILabel*)[backImageView viewWithTag:103];
    addressLabel.numberOfLines = 0;
    NSString * namestr = [NSString stringWithFormat:@"收货人：  %@",name];
    CGFloat nameH = [TTIFont calHeightWithText:namestr font:[UIFont systemFontOfSize:14.0] limitWidth:UIScreenWidth - 20];
    namelabel.frame = CGRectMake(10,50, UIScreenWidth-20, nameH);
    namelabel.text = namestr;
    phoneLabel.frame = CGRectMake(namelabel.frame.origin.x, namelabel.frame.origin.y+nameH+5, UIScreenWidth, 30);
    phoneLabel.text =  [NSString stringWithFormat:@"手机：  %@",phoneNumber];
    
    NSString * add = [NSString stringWithFormat:@"地址：  %@",address];
    addressLabel.text = add;
    CGFloat messageH = [TTIFont calHeightWithText:add font:[UIFont systemFontOfSize:13.0] limitWidth:UIScreenWidth -20];
    addressLabel.frame = CGRectMake(phoneLabel.frame.origin.x, phoneLabel.frame.origin.y+phoneLabel.frame.size.height, UIScreenWidth-20,messageH+10);
    backImageView.frame = CGRectMake(0, 7, UIScreenWidth, addressLabel.frame.origin.y+addressLabel.frame.size.height+10);
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
