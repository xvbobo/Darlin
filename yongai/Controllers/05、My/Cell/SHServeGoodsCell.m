//
//  SHServeGoodsCell.m
//  com.threeti
//
//  Created by alan on 15/10/30.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "SHServeGoodsCell.h"
#define goodW 80
#import "TTIFont.h"
@implementation SHServeGoodsCell
{
    UIImageView * goodsImage;
    UILabel * goodsName;
    UILabel * numLabel;
    UILabel * priceLabel;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView * UpLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 10)];
        UpLineView.backgroundColor = BJCLOLR;
        UpLineView.layer.borderColor = LINE.CGColor;
        UpLineView.layer.borderWidth = 0.5;
//        [self addSubview:UpLineView];
        goodsImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, goodW, goodW)];
        goodsImage.backgroundColor = BJCLOLR;
        [self addSubview:goodsImage];
        goodsName = [[UILabel alloc] initWithFrame:CGRectMake(goodsImage.frame.origin.x+goodW+10, goodsImage.frame.origin.y, UIScreenWidth/3*2-16, 50)];
        goodsName.textColor = BLACKTEXT;
        goodsName.text = @"冈本002原装进口超薄安全0.02mm避孕套安全套";
        goodsName.numberOfLines = 2;
        goodsName.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:goodsName];
        CGFloat priceLabelWith = [TTIFont calWidthWithText:@"￥0.00" font:[UIFont systemFontOfSize:13.0] limitWidth:20];
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(goodsName.frame.origin.x, goodsImage.frame.origin.y+goodsImage.frame.size.height-25, priceLabelWith, 20)];
        priceLabel.text = @"￥0.00";
        priceLabel.font = [UIFont systemFontOfSize:13.0];
        priceLabel.textColor = TEXT;
        [self addSubview:priceLabel];
        numLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.frame.origin.x+priceLabel.frame.size.width+10, priceLabel.frame.origin.y, 200, 20)];
        numLabel.text = @"数量：1";
        numLabel.font = [UIFont systemFontOfSize:13.0];
        numLabel.textColor = TEXT;
        [self addSubview:numLabel];
        self.selectionStyle  =UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)initWithModel:(CartListGoodsModel*)model
{
    goodsName.text = model.goods_name;
    [goodsImage setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
    numLabel.text = [NSString stringWithFormat:@"数量：%@",model.goods_number];
    priceLabel.text = [NSString stringWithFormat:@"￥%@",model.goods_price];
    CGFloat width = [TTIFont calWidthWithText:priceLabel.text font:[UIFont systemFontOfSize:13.0] limitWidth:20];
    priceLabel.frame = CGRectMake(goodsName.frame.origin.x, goodsImage.frame.origin.y+goodsImage.frame.size.height-25, width, 20);
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
