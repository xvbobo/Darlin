//
//  SearchProductCell.m
//  Yongai
//
//  Created by Kevin Su on 14/12/1.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "SearchProductCell.h"

@implementation SearchProductCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithData:(NSDictionary *)dataDic{
    
    [self.picView setImageWithURL:[NSURL URLWithString:dataDic[@"img_url"]] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
    self.pnameLabel.text = dataDic[@"goods_name"];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", dataDic[@"price"]];
       if([dataDic[@"is_hot"] intValue] == 1){
        //热卖
        self.connerImageView.image = [UIImage imageNamed:@"hot_icon"];
    }
    
    if([dataDic[@"is_best"]intValue] == 1 ){
        //人气
        self.connerImageView.image = [UIImage imageNamed:@"qiang_icon"];
    }
    
    if([dataDic[@"is_new"]intValue] == 1){
        //最新
        self.connerImageView.image = [UIImage imageNamed:@"new_icon"];
    }
    
    if([dataDic[@"is_zeng"] intValue] == 1){
        //赠品
        self.iconZengView.hidden = NO;
         self.iconZengW.constant = 20;
    }else
    {
        self.iconZengView.hidden = YES;
        self.iconZengW.constant = 0;
    }
    
    if([dataDic[@"is_down"] intValue] == 1){
        
        //降
        self.iconJiangView.hidden = NO;
    }else{
        self.iconJiangView.hidden = YES;
    }
}

@end
