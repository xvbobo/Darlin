//
//  OrderProductCell.m
//  Yongai
//
//  Created by Kevin Su on 14/11/30.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "OrderProductCell.h"

@implementation OrderProductCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.pnameLabel.textColor = BLACKTEXT;
    self.line.backgroundColor = BJCLOLR;
    self.LineH.constant = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initDataWithInfo:(CartListGoodsModel *)goodsInfo
{
    
    [self.picImageView setImageWithURL:[NSURL URLWithString:goodsInfo.img_url] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
    self.pnameLabel.text = goodsInfo.goods_name;
}
@end
