//
//  ProductSpecView.m
//  Yongai
//
//  Created by Kevin Su on 14-11-14.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "ProductSpecView.h"

@implementation ProductSpecView{
    
    NSArray *specArray;
    NSMutableArray *specButtonArray;
}

- (void)awakeFromNib{
      
    [self.closeButton addTarget:self action:@selector(closeProductSpecView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.addButton addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.minusButton addTarget:self action:@selector(minusAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.resultCount = 1;
    self.priceLabel.text = nil;
    self.goodsStatusLabel.text = nil;
    self.pnameLabel.textColor = BLACKTEXT;
    self.goodsStatusLabel.textColor = BLACKTEXT;
    _specJiangTag.hidden = YES;
    _specZengTag.hidden = YES;
    self.gouMaiNumber.textColor = BLACKTEXT;
    self.specStrLabel.textColor = BLACKTEXT;
    specButtonArray = [[NSMutableArray alloc] init];
    self.resultButton.titleLabel.textColor = BLACKTEXT;
}

- (void)initDataWithDictionary:(NSDictionary *)dataDic width:(CGFloat)width{
    
    for(UIView *subView in self.specView.subviews)
    {
        if([subView isKindOfClass:[UIButton class]])
            [subView removeFromSuperview];
    }
    
    [specButtonArray removeAllObjects];
    
    specArray = dataDic[@"spec_item"];
    
    [self.picView setImageWithURL:[NSURL URLWithString:dataDic[@"goods_info"][@"img_url"]]placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
    self.pnameLabel.text = dataDic[@"goods_info"][@"goods_name"]; 
    
    CGFloat buttonWidth = (width - 40) / 3;
    int index = 0;
    int row = 1;
    
    //当前选中状态的buttonTag
    NSInteger btnTag = [specArray indexOfObject:self.selectedSpecDic];
    DLOG(@"============%d", btnTag);
    
    for(int i = 0; i < specArray.count; i++){
         
        if(index >= 3){
            
            index = index - 3;
            row++;
        }
        
        UIButton *specButton = [[UIButton alloc] initWithFrame:CGRectMake(10 + index*(buttonWidth + 10), 40 + 40 * (row - 1), buttonWidth, 30)];
        
        [specButton setBackgroundImage:[UIImage imageNamed:@"mc_spec_button_bgimage"] forState:UIControlStateNormal];
        [specButton setBackgroundImage:[UIImage imageNamed:@"spec_button_selected"] forState:UIControlStateSelected];
        [specButton addTarget:self action:@selector(specButtonSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
 
        [specButton setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0  blue:153/255.0  alpha:1] forState:UIControlStateNormal];
        specButton.tag = i;
        [specButton setTitle:specArray[i][@"attr_value"] forState:UIControlStateNormal];
        specButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.specView addSubview:specButton];
        
        [specButtonArray addObject:specButton];
        
        // 标记当前选中的button
        if(btnTag < specArray.count && btnTag == i)
            specButton.selected = YES;
            
        index++;
    }
    float specViewHeight = 40 + 40 * row;
    self.specView.translatesAutoresizingMaskIntoConstraints = NO;
    self.specViewHeight.constant = specViewHeight;
    
    self.productSpecViewHeight.constant = 268 - 90 + specViewHeight;
    
//    [self.specView addSubview:_specStrLabel]; 
}

/**
 *  选择某个规格的事件
 *
 *  @param sender 
 */
- (void)specButtonSelectedAction:(UIButton *)sender{
    
    for(UIButton *button in specButtonArray)
    {
        button.selected = NO;
    }
    
   self.selectedSpecDic = specArray[sender.tag];
    
    sender.selected = YES;
    if(sender.selected)
    {
        self.specLabel.text = self.selectedSpecDic[@"attr_value"];
        self.priceLabel.text =[NSString stringWithFormat:@"¥%@", self.selectedSpecDic[@"attr_price"]];
        self.goodsStatusLabel.text = self.selectedSpecDic[@"goods_status"];
        
        if([self.selectedSpecDic[@"is_zeng"] intValue] == 0)
        {
            _specZengTag.hidden = YES;
            _zengW.constant = 0;
            _jiangLeft.constant = 0;
        }
        else
        {
//            _jiangLeft.constant = 10;
            _specZengTag.hidden = NO;
        }
        
        if([self.selectedSpecDic[@"is_down"] intValue] == 0 )
            _specJiangTag.hidden = YES;
        else
            _specJiangTag.hidden = NO;
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(specButtonSelected:)]){
        
        [self.delegate specButtonSelected:self.selectedSpecDic];
    }
}

- (void)closeProductSpecView:(id)sender{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(closeProductSpecView:)]){
        
        [self.delegate closeProductSpecView:sender];
    }
}

/**
 *  显示规格选择View
 **/
- (void)showProductSpecView:(id)sender{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(showProductSpecView:)]){
        
        [self.delegate showProductSpecView:sender];
    }
}

/**
 *  增加
 **/
- (void)addAction:(id)sender{
    
    if(self.selectedSpecDic.count == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请选择：规格/购买数量"];
        return;
    }
    
    if(self.resultCount < [self.selectedSpecDic[@"attr_goods_number"] intValue]){
        
        //不能超过库存
        self.resultCount++;
        [self.resultButton setTitle:[NSString stringWithFormat:@"%i", self.resultCount] forState:UIControlStateNormal];
    }else{
        
        [SVProgressHUD showErrorWithStatus:@"选中的数目不能超过库存"];
        return;
    }
}

/**
 *  减少
 **/
- (void)minusAction:(id)sender{
    
    if(self.selectedSpecDic.count == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请选择：规格/购买数量"];
        return;
    }
    
    if(self.resultCount > 1){
        
        //不能少于一件
        self.resultCount--;
        [self.resultButton setTitle:[NSString stringWithFormat:@"%i", self.resultCount] forState:UIControlStateNormal];
    }else{
        
        [SVProgressHUD showErrorWithStatus:@"至少选中一件该商品"];
        return;
    }
}

@end
