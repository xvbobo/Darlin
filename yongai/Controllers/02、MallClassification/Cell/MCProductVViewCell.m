//
//  MCProductVViewCell.m
//  Yongai
//
//  Created by wangfang on 14/12/30.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MCProductVViewCell.h"
#import "DataTapGestureRecognizer.h"
#import "TTIFont.h"
#import "M80AttributedLabel.h"
@implementation MCProductVViewCell
{
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        int imageW = (UIScreenWidth-30)/2;
        for (int i = 0; i< 2; i++) {
            UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(10+i*(imageW+10), 10, imageW, imageW)];
            image.userInteractionEnabled = YES;
            image.tag = 100+i;
            image.backgroundColor = [UIColor whiteColor];
            UIImageView * reImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            reImage.tag = 800+i;
            reImage.hidden = YES;
            reImage.backgroundColor = beijing;
            reImage.image = [UIImage imageNamed:@"hot_icon"];
            [image addSubview:reImage];
            UIImageView * downView = [[UIImageView alloc] initWithFrame:CGRectMake(image.frame.origin.x, image.frame.origin.y+imageW, imageW,70)];
            downView.tag = 1000+i;
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0,0, imageW, 14)];
            UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(0,label.frame.origin.y+15, imageW,14)];
            UILabel * priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, label1.frame.origin.y+label1.frame.size.height+5, imageW/3+30, 14)];
            priceLabel.text = @"￥169.0";
            priceLabel.tag = 300+i;
            priceLabel.font = [UIFont systemFontOfSize:14];
            priceLabel.textColor = beijing;
            UILabel * chengjiao = [[UILabel alloc] initWithFrame:CGRectMake(imageW/2, priceLabel.frame.origin.y, imageW/3+30,13)];
            chengjiao.text = @"已成交100笔";
            chengjiao.tag = 400+i;
//            chengjiao.textAlignment = NSTextAlignmentRight;
            chengjiao.font = [UIFont systemFontOfSize:11];
            chengjiao.textColor = TEXT;
            [downView addSubview:priceLabel];
            [downView addSubview:label];
            [downView addSubview:label1];
            [downView addSubview:chengjiao];
            downView.backgroundColor = [UIColor whiteColor];
            
            [self.contentView addSubview:downView];
            [self.contentView addSubview:image];
        }
        
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
    self.leftJiangH.constant = 18;
    self.leftJiangW.constant = 18;
    self.rightJiangH.constant = 18;
    self.rightJiangW.constant = 18;
    self.leftZengH.constant = 18;
    self.rightZengH.constant = 18;
    self.line1.backgroundColor = LINE;
    self.line2.backgroundColor = LINE;
    self.line1W.constant = 0.5;
    self.line2H.constant = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)initWithData:(NSDictionary *)dataDic{
    int imageW = (UIScreenWidth-30)/2;
    UIImageView * head = (UIImageView*)[self viewWithTag:100];
    UILabel * label2 = (UILabel*)[self viewWithTag:300];
    UILabel * label3 = (UILabel*)[self viewWithTag:400];
    UIImageView * down = (UIImageView*)[self viewWithTag:1000];
    M80AttributedLabel *Mlabel  =[[M80AttributedLabel alloc] initWithFrame:CGRectMake(10,10, imageW-20,40)];
    Mlabel.font = [UIFont systemFontOfSize:13];
    Mlabel.textColor = BLACKTEXT;
//    Mlabel.backgroundColor = beijing;
    Mlabel.numberOfLines = 0;
    [down addSubview:Mlabel];
    NSString * chengjiaoStr;
        chengjiaoStr = [NSString stringWithFormat:@"销量：%@",dataDic[@"salenum"]];
    label3.text = chengjiaoStr;
    int with2 = [TTIFont calWidthWithText:chengjiaoStr font:[UIFont systemFontOfSize:12] limitWidth:13];
    [head setImageWithURL:[NSURL URLWithString:dataDic[@"img_url"]] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
    NSString * priceStr = [NSString stringWithFormat:@"￥%@", dataDic[@"price"]];
    label2.text = priceStr;
    int with1 = [TTIFont calWidthWithText:priceStr font:[UIFont systemFontOfSize:14] limitWidth:14];
    NSString * str = dataDic[@"goods_name"];
    if ([dataDic[@"is_zeng"] intValue] == 1&&[dataDic[@"is_down"] intValue]  == 1) {
        [Mlabel appendImage:[UIImage imageNamed:@"cart_giftsIcon"] maxSize:CGSizeMake(15, 15)];
        NSString * text = [@" dropTag" stringByAppendingString:str];
        NSArray *components = [text componentsSeparatedByString:@"dropTag"];
        NSUInteger count = [components count];
        for (NSUInteger i = 0; i < count; i++)
        {
            [Mlabel appendText:[components objectAtIndex:i]];
            if (i != count - 1)
            {
                [Mlabel appendImage:[UIImage imageNamed:@"dropTag"]
                           maxSize:CGSizeMake(15, 15)
                            margin:UIEdgeInsetsZero
                         alignment:M80ImageAlignmentCenter];
            }
        }


    }else if([dataDic[@"is_zeng"] intValue] == 1||[dataDic[@"is_down"] intValue]  == 1){
        //赠品
        if ([dataDic[@"is_zeng"] intValue] == 1) {
            
            [Mlabel appendImage:[UIImage imageNamed:@"cart_giftsIcon"] maxSize:CGSizeMake(15, 15)];
            
            
        }else if ([dataDic[@"is_down"] intValue]  == 1){
            [Mlabel appendImage:[UIImage imageNamed:@"dropTag"] maxSize:CGSizeMake(15, 15)];
        }
        [Mlabel appendText:str];
    }
    else{
        [Mlabel appendText:str];
    }
    label2.frame = CGRectMake(10, Mlabel.frame.origin.y+Mlabel.frame.size.height, with1+10, 14);
    label3.frame = CGRectMake(imageW - with2 -10, label2.frame.origin.y+1, with2+10, 13);
    DataTapGestureRecognizer *tapgest = [[DataTapGestureRecognizer alloc] initWithTarget:self action:@selector(cellSelectBtnClick:)];
    tapgest.dataDic = [[NSMutableDictionary alloc] initWithObjects:@[dataDic[@"goods_id"]] forKeys:@[@"gid"]];
    self.picView.userInteractionEnabled = YES;
    [head addGestureRecognizer:tapgest];
    
}

- (void)initWithData2:(NSDictionary *)dataDic
{
    int imageW = (UIScreenWidth-30)/2;
    UIImageView * head = (UIImageView*)[self viewWithTag:101];
    UILabel * label2 = (UILabel*)[self viewWithTag:301];
    UILabel * label3 = (UILabel*)[self viewWithTag:401];
    UIImageView * down = (UIImageView*)[self viewWithTag:1001];
    M80AttributedLabel *Mlabel  =[[M80AttributedLabel alloc] initWithFrame:CGRectMake(10,10, imageW-20,40)];
    Mlabel.font = [UIFont systemFontOfSize:13];
    Mlabel.textColor = BLACKTEXT;
    Mlabel.numberOfLines = 2;
    [down addSubview:Mlabel];
//    NSString * chengjiao = [NSString stringWithFormat:@"%@",dataDic[@"salenum"]];
    NSString * chengjiaoStr;
//    if ([chengjiao isEqualToString:@"0"]) {
//        chengjiaoStr = @"暂无成交记录";
//    }else {
        chengjiaoStr = [NSString stringWithFormat:@"销量：%@",dataDic[@"salenum"]];
//    }
    label3.text = chengjiaoStr;
    int with2 = [TTIFont calWidthWithText:chengjiaoStr font:[UIFont systemFontOfSize:12] limitWidth:13];
    
    if (dataDic[@"img_url"]) {
        head.hidden = NO;
        [head setImageWithURL:[NSURL URLWithString:dataDic[@"img_url"]] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
    }else{
        head.hidden = YES;
    }
    
    NSString * priceStr = [NSString stringWithFormat:@"￥%@", dataDic[@"price"]];
    label2.text = priceStr;
    int with1 = [TTIFont calWidthWithText:priceStr font:[UIFont systemFontOfSize:14] limitWidth:14];
    NSString * str = dataDic[@"goods_name"];
    if ([dataDic[@"is_zeng"] intValue] == 1&&[dataDic[@"is_down"] intValue]  == 1) {
        [Mlabel appendImage:[UIImage imageNamed:@"cart_giftsIcon"] maxSize:CGSizeMake(15, 15)];
        NSString * text = [@" dropTag" stringByAppendingString:str];
        NSArray *components = [text componentsSeparatedByString:@"dropTag"];
        NSUInteger count = [components count];
        for (NSUInteger i = 0; i < count; i++)
        {
            [Mlabel appendText:[components objectAtIndex:i]];
            if (i != count - 1)
            {
                [Mlabel appendImage:[UIImage imageNamed:@"dropTag"]
                            maxSize:CGSizeMake(15, 15)
                             margin:UIEdgeInsetsZero
                          alignment:M80ImageAlignmentCenter];
            }
        }
        
        
    }else if([dataDic[@"is_zeng"] intValue] == 1||[dataDic[@"is_down"] intValue]  == 1){
        //赠品
        if ([dataDic[@"is_zeng"] intValue] == 1) {
            
            [Mlabel appendImage:[UIImage imageNamed:@"cart_giftsIcon"] maxSize:CGSizeMake(15, 15)];
            
            
        }else if ([dataDic[@"is_down"] intValue]  == 1){
            [Mlabel appendImage:[UIImage imageNamed:@"dropTag"] maxSize:CGSizeMake(15, 15)];
        }
        [Mlabel appendText:str];
    }
    else{
        [Mlabel appendText:str];
    }
    label2.frame = CGRectMake(10, Mlabel.frame.origin.y+Mlabel.frame.size.height, with1+10, 14);
    label3.frame = CGRectMake(imageW - with2 -10, label2.frame.origin.y+1, with2+10, 13);
    DataTapGestureRecognizer *tapgest = [[DataTapGestureRecognizer alloc] initWithTarget:self action:@selector(cellSelectBtnClick:)];
    tapgest.dataDic = [[NSMutableDictionary alloc] initWithObjects:@[dataDic[@"goods_id"]] forKeys:@[@"gid"]];
    self.picView2.userInteractionEnabled = YES;
    [head addGestureRecognizer:tapgest];
    
    //self.pDiscountView.hidden = YES;
}

- (void)showCellView {

    UIImageView * head = (UIImageView*)[self viewWithTag:101];
    UILabel * label2 = (UILabel*)[self viewWithTag:301];
    UILabel * label3 = (UILabel*)[self viewWithTag:401];
    UIImageView * down = (UIImageView*)[self viewWithTag:1001];
    head.hidden = NO;
    label2.hidden = NO;
    label3.hidden = NO;
    down.hidden = NO;}

- (void)hiddleCellView {

    UIImageView * head = (UIImageView*)[self viewWithTag:101];
    UILabel * label2 = (UILabel*)[self viewWithTag:301];
    UILabel * label3 = (UILabel*)[self viewWithTag:401];
    UIImageView * down = (UIImageView*)[self viewWithTag:1001];
    head.hidden = YES;
    label2.hidden = YES;
    label3.hidden = YES;
    down.hidden = YES;

}

- (void)cellSelectBtnClick:(DataTapGestureRecognizer *)gesture {
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(cellSelectBtnClick:)])
        [self.delegate cellSelectBtnClick:gesture.dataDic[@"gid"]];
}


@end
