//
//  MCProduceHViewCell.m
//  Yongai
//
//  Created by wangfang on 14/12/30.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MCProduceHViewCell.h"
#import "QFControl.h"
#import "TTIFont.h"
#import "M80AttributedLabel.h"
@implementation MCProduceHViewCell
{
    UIImageView * image;
    M80AttributedLabel * namelabel;
    UILabel * priceLable;
    UIImageView * zengView;
    UIImageView * jiangView;
    UILabel * chengLable;
    UIImageView * reImage;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        int with = 320/3;
        int nameWith = UIScreenWidth/3*2-10;
        image = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, with, with)];
        image.backgroundColor = BJCLOLR;
        reImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        [image addSubview:reImage];
        [self.contentView addSubview:image];
        namelabel = [[M80AttributedLabel alloc] initWithFrame:CGRectMake(image.frame.origin.x+with+5, image.frame.origin.y+10,nameWith, 30)];
        namelabel.numberOfLines = 2;
        namelabel.font = [UIFont systemFontOfSize:15];
        namelabel.textColor = BLACKTEXT;
        [self.contentView addSubview:namelabel];
        priceLable = [[UILabel alloc] init];
//        priceLable.frame = CGRectMake(image.frame.origin.x+image.frame.size.width+5, namelabel.frame.origin.y+30+10,100, 20);
        priceLable.font = font(17);
        priceLable.textColor = beijing;
        [self.contentView addSubview:priceLable];
        zengView = [[UIImageView alloc] init];
        zengView.image = [UIImage imageNamed:@"cart_giftsIcon"];
        zengView.hidden = YES;
        jiangView = [[UIImageView alloc] init];
        jiangView.image = [UIImage imageNamed:@"dropTag"];
        jiangView.hidden = YES;
        [self.contentView addSubview:zengView];
        [self.contentView addSubview:jiangView];
        chengLable = [[UILabel alloc] initWithFrame:CGRectMake(image.frame.origin.x+with+5, 117-30, UIScreenWidth, 20)];
        chengLable.textColor = TEXT;
        chengLable.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:chengLable];
        UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 116, UIScreenWidth, 0.5)];
        line.backgroundColor = LINE;
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithData:(NSDictionary *)dataDic{
    int with = 320/3;
    int nameWith = UIScreenWidth/3*2-10;
    [image setImageWithURL:[NSURL URLWithString:dataDic[@"img_url"]] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
    namelabel.frame = CGRectMake(image.frame.origin.x+with+5, image.frame.origin.y+10,nameWith,40);
    namelabel.backgroundColor = BJCLOLR;
    namelabel.text = dataDic[@"goods_name"];
    int priceW = [TTIFont calWidthWithText:[NSString stringWithFormat:@"￥%@", dataDic[@"price"]] font:font(17) limitWidth:20];
    priceLable.frame = CGRectMake(namelabel.frame.origin.x, namelabel.frame.origin.y+30+10, priceW+10, 20);
    zengView.frame = CGRectMake(priceLable.frame.origin.x+priceLable.frame.size.width, priceLable.frame.origin.y+7,16,16);
    
    priceLable.text = [NSString stringWithFormat:@"￥%@", dataDic[@"price"]];
    NSString * numStr = [NSString stringWithFormat:@"销量：%@",dataDic[@"salenum"]];
//    if ([numStr isEqualToString:@"销量：0"]) {
//        chengLable.text = @"没有成交记录";
//    }else{
        chengLable.text = numStr;
//    }
    if([dataDic[@"is_hot"] intValue] == 1){
        //热卖
        reImage.image = [UIImage imageNamed:@"hot_icon"];
    }
    else if([dataDic[@"is_best"]intValue] == 1 ){
        //人气
        reImage.image = [UIImage imageNamed:@"qiang_icon"];
    }
    else if([dataDic[@"is_new"]intValue] == 1){
        //最新
        reImage.image = [UIImage imageNamed:@"new_icon"];
    }
    else
        reImage.hidden = YES;
    zengView.frame = CGRectMake(priceLable.frame.origin.x+priceW+10, priceLable.frame.origin.y+2, 15, 15);
    if([dataDic[@"is_zeng"] intValue] == 1){
        //赠品
        zengView.hidden = NO;
        jiangView.frame = CGRectMake(zengView.frame.origin.x+25, zengView.frame.origin.y,15, 15);
    }else{
        zengView.hidden = YES;
        jiangView.frame = zengView.frame;
    }
    
    if([dataDic[@"is_down"] intValue]  == 1){
        //降
        jiangView.hidden = NO;
    }else{
        jiangView.hidden = YES;
    }
    
}

@end
