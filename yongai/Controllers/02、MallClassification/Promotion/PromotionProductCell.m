//
//  PromotionProductCell.m
//  Yongai
//
//  Created by Kevin Su on 14-11-12.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "PromotionProductCell.h"

@implementation PromotionProductCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.gNameLabel.textColor = BLACKTEXT;
    self.gPriceLabel.textColor = beijing;
    self.gAmountLabel.textColor = TEXT;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initDataWithDic:(NSDictionary *)dataDic{
    
    [self.gPicImageView setImageWithURL:[NSURL URLWithString:dataDic[@"img_url"]] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
    self.gPriceLabel.text = [NSString stringWithFormat:@"￥%@", dataDic[@"price"]];
    self.gAmountLabel.text = [NSString stringWithFormat:@"数量%@件", dataDic[@"goods_number"]];
    self.gNameLabel.text = dataDic[@"goods_name"];
}

@end
