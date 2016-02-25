//
//  SHGoodsCell.m
//  com.threeti
//
//  Created by alan on 15/10/29.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "SHGoodsCell.h"
#define goodW 80
@implementation SHGoodsCell
{
    UIImageView * goodsImage;
    UILabel * goodsName;
    UILabel * numLabel;
    UIButton * shouHBtn;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        goodsImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, goodW, goodW)];
        goodsImage.backgroundColor = BJCLOLR;
        [self addSubview:goodsImage];
        goodsName = [[UILabel alloc] initWithFrame:CGRectMake(goodsImage.frame.origin.x+goodW+10, goodsImage.frame.origin.y, UIScreenWidth/3*2-16, 50)];
        goodsName.textColor = BLACKTEXT;
        goodsName.text = @"冈本002原装进口超薄安全0.02mm避孕套安全套";
        goodsName.numberOfLines = 2;
        goodsName.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:goodsName];
        numLabel = [[UILabel alloc] initWithFrame:CGRectMake(goodsName.frame.origin.x, goodsImage.frame.origin.y+goodsImage.frame.size.height-25, 200, 20)];
//        numLabel.text = @"数量：1";
        numLabel.textColor = TEXT;
        [self addSubview:numLabel];
        shouHBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shouHBtn.frame = CGRectMake(UIScreenWidth - 100, numLabel.frame.origin.y, 80, 25);
        [shouHBtn setTitle:@"申请售后" forState:UIControlStateNormal];
        [shouHBtn setTitleColor:TEXT forState:UIControlStateNormal];
//        shouHBtn.layer.masksToBounds = YES;
        shouHBtn.layer.borderColor = LINE.CGColor;
        shouHBtn.layer.borderWidth = 0.5;
        shouHBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [shouHBtn setBackgroundColor:[UIColor whiteColor]];
        [shouHBtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shouHBtn];
        _lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, UIScreenWidth,0.5)];
        _lineView.backgroundColor = LINE;
        [self addSubview:_lineView];
        _footerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 103, UIScreenWidth, 7)];
        _footerView.layer.borderColor = LINE.CGColor;
        _footerView.layer.borderWidth = 0.5;
        _footerView.backgroundColor = BJCLOLR;
        [self addSubview:_footerView];
        self.selectionStyle  =UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)action:(UIButton *)button
{
    if (button.selected == YES) {
        if ([self.delegate respondsToSelector:@selector(shouHouFuWu:withOrderModel:)]) {
            [self.delegate shouHouFuWu:self.listMd withOrderModel:self.OrderModel];
        }
    }else{
        NSLog(@"已经申请过售后服务");
    }
    
}
- (void)initWithModel:(CartListGoodsModel*) model
{
    [goodsImage setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
    goodsName.text = model.goods_name;
    numLabel.text = [NSString stringWithFormat:@"数量：%@",model.goods_number];
    shouHBtn.tag = model.goods_id.intValue;
    if ([model.service_status isEqualToString:@"0"]) {
        shouHBtn.selected = YES;
//        shouHBtn.enabled = YES;
        [shouHBtn setBackgroundColor:[UIColor whiteColor]];
    }else{
//        shouHBtn.enabled = NO;
        shouHBtn.selected = NO;
        [shouHBtn setBackgroundColor:RGBACOLOR(213, 204, 197, 1)];

    }
    NSLog(@"%@",model);
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
