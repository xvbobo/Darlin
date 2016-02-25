//
//  ShangPinViewCell.m
//  com.threeti
//
//  Created by alan on 15/8/31.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import "ShangPinViewCell.h"

@implementation ShangPinViewCell
{
    UIView * view;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        view = [[UIView alloc] initWithFrame:CGRectMake(10, 20, UIScreenWidth-20, 260)];
        view.hidden = YES;
        view.backgroundColor = [UIColor whiteColor];
        view.layer.masksToBounds = YES;
        view.layer.borderColor = LINE.CGColor;
        view.layer.borderWidth  = 1.0;
        view.layer.cornerRadius = 2;
        UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(5,10, UIScreenWidth, 30)];
        lable.text = @"本期推荐：";
        lable.textColor = BLACKTEXT;
        lable.font = font(19);
//        lable.font = [UIFont systemFontOfSize:19];
        [view addSubview:lable];
        CGFloat With = (view.frame.size.width-10)/4;
        
        for (int i = 0; i< 4; i++) {
            UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(5+i%2*With*2, lable.frame.origin.y+lable.frame.size.height+10+i/2*(With+20), With, With)];
            image.layer.borderColor = LINE.CGColor;
            image.layer.borderWidth = 0.5;
            image.layer.masksToBounds = YES;
            image.layer.cornerRadius = 5;
            image.tag = 100+i;
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(image.frame.origin.x, image.frame.origin.y, image.frame.size.width*2, image.frame.size.height);
            btn.tag = 400+i;
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            UILabel * namelLabel = [[UILabel alloc] initWithFrame:CGRectMake(image.frame.origin.x+image.frame.size.width+2, image.frame.origin.y+10, With-4, 45)];
            namelLabel.numberOfLines = 2;
            namelLabel.tag = 200+i;
            namelLabel.font = [UIFont systemFontOfSize:15];
            namelLabel.textColor = BLACKTEXT;
            UILabel * priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(namelLabel.frame.origin.x, namelLabel.frame.origin.y+namelLabel.frame.size.height+10, With, 20)];
            priceLabel.textColor = beijing;
            priceLabel.tag = 300+i;
            priceLabel.font = [UIFont systemFontOfSize:16];
            [view addSubview:priceLabel];
            [view addSubview:namelLabel];
            [view addSubview:image];
            [view addSubview:btn];
        }
        [self.contentView addSubview:view];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)btnAction:(UIButton*)button
{
    if ( [self.delegate respondsToSelector:@selector(ShangPinViewCellButtonAction:)]) {
        [self.delegate ShangPinViewCellButtonAction:[NSString stringWithFormat:@"%ld",(long)button.tag]];
    }
}
- (void)ShangPinWithArray:(NSArray *)shangpinArr
{
//    CGFloat With = (view.frame.size.width-10)/4;
    UIImageView * imageView = (UIImageView*)[view viewWithTag:103];
    CGFloat With = (UIScreenWidth-30)/4;
    if (shangpinArr.count > 2) {
        view.hidden = NO;
        view.frame = CGRectMake(10, 20, UIScreenWidth-20,imageView.frame.origin.y+imageView.frame.size.height+10);
    }else{
        if (shangpinArr.count == 0) {
            view.hidden = YES;
        }else{
            view.hidden = NO;
           view.frame = CGRectMake(10, 20, UIScreenWidth-20, With +70);
        }
        
    }
    
    for (int i =0; i< shangpinArr.count; i++) {
        UIImageView * image = (UIImageView*)[view viewWithTag:100+i];
        UILabel * nameLabel = (UILabel*)[view viewWithTag:200+i];
        UILabel * priceLabel = (UILabel*)[view viewWithTag:300+i];
        UIButton * btn = (UIButton*)[view viewWithTag:400+i];
        GoodModelTui * model = shangpinArr[i];
        [image setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
        nameLabel.text = model.goods_name;
        priceLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
        btn.tag = model.goods_id.intValue;
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
