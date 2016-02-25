//
//  MCProductOtherInfoCell.m
//  Yongai
//
//  Created by Kevin Su on 14-11-10.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MCProductOtherInfoCell.h"

@implementation MCProductOtherInfoCell{
    
    CWStarRateView *sView;
    NSMutableAttributedString * string1;
}

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.label2.textColor = TEXT;
    self.line2.backgroundColor = LINE;
    self.line2H.constant = 0.5;
    UITapGestureRecognizer *productCommentGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProductCommentView:)];
    self.productCommentView.userInteractionEnabled = YES;
    [self.productCommentView addGestureRecognizer:productCommentGest];
    sView.userInteractionEnabled = NO;
    sView.allowIncompleteStar = YES;
    sView.hasAnimation = YES;
    sView.scorePercent = 0;
    string1 = [[NSMutableAttributedString alloc ]init];
    //        _pic1 = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenWidth - 20, 12, 8, 15)];
    //        _pic1.image = [UIImage imageNamed:@"common_cell_right_point"];
    //        [self.contentView addSubview:_pic1];
//    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initDataWithGoodsInfo:(GoodsInfoModel*)goodsInfo
{
    //初始化
//    NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc ] initWithString:[NSString stringWithFormat:@"已有%d人评价", goodsInfo.evaluation.intValue]];
    string1 = [string1 initWithString:[NSString stringWithFormat:@"已有%d人评价", goodsInfo.evaluation.intValue]];
//    string1 = [NSString stringWithFormat:@"已有%d人评价", goodsInfo.evaluation.intValue];
    NSRange redRange = NSMakeRange(2, [goodsInfo.evaluation length]);
    [string1 addAttribute:NSForegroundColorAttributeName value:beijing range:redRange];
    [self.commentNumLabel setAttributedText:string1];
    
//    self.commentNumLabel.text = [NSString stringWithFormat:@"已有%d人评价", goodsInfo.evaluation.intValue];
    float starCount = [goodsInfo.star_value floatValue] / 5.0;
    sView.scorePercent = starCount;
}



- (void)showProductCommentView:(UITapGestureRecognizer *)gesture{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(showProductCommentView:)])
        [self.delegate showProductCommentView:gesture];
}


@end
