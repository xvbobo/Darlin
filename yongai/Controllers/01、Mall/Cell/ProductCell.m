//
//  ProductCell.m
//  Yongai
//
//  Created by Kevin Su on 14-11-1.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "ProductCell.h"
#import "UIImageView+WebCache.h"
#import "DataTapGestureRecognizer.h"
#import "QFControl.h"
#define Height  UIScreenWidth*0.75
#define jianGe 6
#define left 4
@implementation ProductCell
- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.selected = NO;
    self.translatesAutoresizingMaskIntoConstraints = YES;
//    self.backgroundColor = beijing;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

- (void)showProductDetailView:(UIButton *)sender{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(showProductView:)]){
        
        [self.delegate showProductView:sender];
    }
}

- (void)initDataWithArray:(NSArray *)array andSectionTitle:(NSString *)string{
    self.backgroundColor = BJCLOLR;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([string isEqualToString:@"内衣热卖"]) {
        [self creatNeiYi:array];
    }else if ([string isEqualToString:@"套套热卖"])
    {
        [self createTaoTao:array];
    }else if ([string isEqualToString:@"男用热卖"])
    {
        [self createMale:array];
    }else if ([string isEqualToString:@"女用热卖"])
    {
        [self createFemale:array];
    }else if ([string isEqualToString:@"精选"]){
        [self createJingXuan:array];
    }
}
- (void)creatNeiYi:(NSArray *) array
{
//    int with = 3;
    int with = (UIScreenWidth - left*2-jianGe);
    UIImageView * leftImage = [QFControl createUIImageViewWithFrame:CGRectMake(left, 0, with/3*2, Height/5*2.7) url:array[0][@"logo"]];    [leftImage addSubview:[QFControl createButtonWithFrame:CGRectMake(0, 0, leftImage.frame.size.width, leftImage.frame.size.height) title:array[0][@"return_cat"] target:self action:@selector(showProductDetailView:) tag:[array[0][@"id"] intValue]]];
    leftImage.userInteractionEnabled = YES;
    UIImageView * rightImage = [QFControl createUIImageViewWithFrame:CGRectMake(leftImage.frame.origin.x+leftImage.frame.size.width+jianGe,leftImage.frame.origin.y, with/3, leftImage.frame.size.height) url:array[1][@"logo"]];
    rightImage.userInteractionEnabled = YES;
    [rightImage addSubview:[QFControl createButtonWithFrame:CGRectMake(0, 0, rightImage.frame.size.width, rightImage.frame.size.height) title:array[1][@"return_cat"] target:self action:@selector(showProductDetailView:) tag:[array[1][@"id"] intValue]]];
    UIImageView * downImage = [QFControl createUIImageViewWithFrame:CGRectMake(left,leftImage.frame.origin.y+leftImage.frame.size.height+jianGe, UIScreenWidth-left*2, Height/5*2.3-5) url:array[2][@"logo"]];
    [downImage addSubview:[QFControl createButtonWithFrame:CGRectMake(0, 0, downImage.frame.size.width, downImage.frame.size.height) title:array[2][@"return_cat"] target:self action:@selector(showProductDetailView:) tag:[array[2][@"id"] intValue]]];
    downImage.userInteractionEnabled = YES;
    [self.contentView addSubview:leftImage];
    [self.contentView addSubview:rightImage];
    [self.contentView addSubview:downImage];
}
- (void)createTaoTao:(NSArray *)array
{
    int with = (UIScreenWidth - left*2 -jianGe*2)/3;
    UIImageView * imageView;
    for (int i =0; i < 4; i++) {
        if (i == 3) {
        imageView = [QFControl createUIImageViewWithFrame:CGRectMake(left,Height/5*2.7+jianGe, UIScreenWidth-left*2, Height/5*2.3-5) url:array[i][@"logo"]];
        }else{
         imageView = [QFControl createUIImageViewWithFrame:CGRectMake(left+i*(with+jianGe), 0, with, Height/5*2.7) url:array[i][@"logo"]];
        }
        [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        imageView.userInteractionEnabled = YES;
        [imageView addSubview:[QFControl createButtonWithFrame:CGRectMake(0, 0,imageView.frame.size.width, imageView.frame.size.height) title:array[i][@"return_cat"]target:self action:@selector(showProductDetailView:) tag:[array[i][@"id"]intValue]]];
        [self.contentView addSubview:imageView];
    }
    
}
- (void)createMale:(NSArray *)array
{
    int with = (UIScreenWidth - left*2-jianGe)/2;
    UIImageView * leftImage = [QFControl createUIImageViewWithFrame:CGRectMake(left, 0, with, Height/5*2.7) url:array[0][@"logo"]];
    [leftImage addSubview:[QFControl createButtonWithFrame:CGRectMake(0, 0, leftImage.frame.size.width, leftImage.frame.size.height) title:array[0][@"return_cat"] target:self action:@selector(showProductDetailView:) tag:[array[0][@"id"] intValue]]];
    leftImage.userInteractionEnabled = YES;
    UIImageView * rightImage = [QFControl createUIImageViewWithFrame:CGRectMake(leftImage.frame.origin.x+leftImage.frame.size.width+jianGe,leftImage.frame.origin.y, UIScreenWidth-leftImage.frame.origin.x*2-leftImage.frame.size.width-jianGe, (leftImage.frame.size.height)/2) url:array[1][@"logo"]];
    rightImage.userInteractionEnabled = YES;
    [rightImage addSubview:[QFControl createButtonWithFrame:CGRectMake(0, 0, rightImage.frame.size.width, rightImage.frame.size.height) title:array[1][@"return_cat"] target:self action:@selector(showProductDetailView:) tag:[array[1][@"id"] intValue]]];
    UIImageView * rightImage1 = [QFControl createUIImageViewWithFrame:CGRectMake(leftImage.frame.origin.x+leftImage.frame.size.width+jianGe,rightImage.frame.origin.y+rightImage.frame.size.height+5, UIScreenWidth-leftImage.frame.origin.x*2-leftImage.frame.size.width-jianGe, (leftImage.frame.size.height)/2-5) url:array[2][@"logo"]];
    rightImage1.userInteractionEnabled = YES;
    [rightImage1 addSubview:[QFControl createButtonWithFrame:CGRectMake(0, 0, rightImage1.frame.size.width, rightImage1.frame.size.height) title:array[2][@"return_cat"] target:self action:@selector(showProductDetailView:) tag:[array[2][@"id"] intValue]]];
    UIImageView * downImage = [QFControl createUIImageViewWithFrame:CGRectMake(left,leftImage.frame.origin.y+leftImage.frame.size.height+jianGe, UIScreenWidth-left*2, Height/5*2.3-5) url:array[3][@"logo"]];
    [downImage addSubview:[QFControl createButtonWithFrame:CGRectMake(0, 0, downImage.frame.size.width, downImage.frame.size.height) title:array[3][@"return_cat"] target:self action:@selector(showProductDetailView:) tag:[array[3][@"id"] intValue]]];
    downImage.userInteractionEnabled = YES;
    [self.contentView addSubview:rightImage1];
    [self.contentView addSubview:leftImage];
    [self.contentView addSubview:rightImage];
    [self.contentView addSubview:downImage];
}
- (void)createFemale:(NSArray *)array
{
    int with = (UIScreenWidth - left*2-jianGe)/2;
    UIImageView * leftImage = [QFControl createUIImageViewWithFrame:CGRectMake(left, 0, with, Height/5*2.7) url:array[0][@"logo"]];
    [leftImage addSubview:[QFControl createButtonWithFrame:CGRectMake(0, 0, leftImage.frame.size.width, leftImage.frame.size.height) title:array[0][@"return_cat"] target:self action:@selector(showProductDetailView:) tag:[array[0][@"id"] intValue]]];
    leftImage.userInteractionEnabled = YES;
    UIImageView * rightImage = [QFControl createUIImageViewWithFrame:CGRectMake(leftImage.frame.origin.x+leftImage.frame.size.width+jianGe,leftImage.frame.origin.y, with, leftImage.frame.size.height) url:array[1][@"logo"]];
    rightImage.userInteractionEnabled = YES;
    [rightImage addSubview:[QFControl createButtonWithFrame:CGRectMake(0, 0, rightImage.frame.size.width, rightImage.frame.size.height) title:array[1][@"return_cat"] target:self action:@selector(showProductDetailView:) tag:[array[1][@"id"] intValue]]];
    UIImageView * downImage = [QFControl createUIImageViewWithFrame:CGRectMake(left,leftImage.frame.origin.y+leftImage.frame.size.height+jianGe, UIScreenWidth-left*2, Height/5*2.3-5) url:array[2][@"logo"]];
    [downImage addSubview:[QFControl createButtonWithFrame:CGRectMake(0, 0, downImage.frame.size.width, downImage.frame.size.height) title:array[2][@"return_cat"] target:self action:@selector(showProductDetailView:) tag:[array[2][@"id"] intValue]]];
    downImage.userInteractionEnabled = YES;
    [self.contentView addSubview:leftImage];
    [self.contentView addSubview:rightImage];
    [self.contentView addSubview:downImage];
}
- (void)createJingXuan:(NSArray *)array
{
   
    CGFloat With = UIScreenWidth-left*2;
    CGFloat H = (With * 215)/703;
    for (int i = 0 ;i < array.count; i++) {
        NSDictionary * dict = array[i];
        NSString *  if_goods = [NSString stringWithFormat:@"%@",[dict objectForKey:@"if_goods"]];
        if ([if_goods isEqualToString:@"1"]){
            if_goods = @"2";
        }
        NSString * ad_link = [dict objectForKey:@"ad_link"];
        UIImageView * image = [QFControl createUIImageViewWithFrame:CGRectMake(left, i*(H+5),With, H) url:dict[@"img_url"]];
        image.userInteractionEnabled = YES;
        [image addSubview:[QFControl createButtonWithFrame:CGRectMake(0, 0, image.frame.size.width, image.frame.size.height) title:if_goods target:self action:@selector(jixuanAction:) tag:ad_link.intValue]];
        [self.contentView addSubview:image];
    }
   
}
- (void)jixuanAction:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(showClassification:title: )]) {
        [self.delegate showClassification:btn.titleLabel.text title:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
    }
    
}
@end
