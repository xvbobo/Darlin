//
//  UpdateGoodsCountView.m
//  Yongai
//
//  Created by arron on 14/11/3.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "UpdateGoodsCountView.h"

@implementation UpdateGoodsCountView

//减小商品数量
- (IBAction)plusGoodsCount:(UIButton *)sender
{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(plusGoodsCount:)])
    {
        
        [self.delegate plusGoodsCount:self.goodsCountField.text];
    }
}

//增加商品数量
- (IBAction)addGoodsCount:(UIButton *)sender
{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(addGoodsCount:)])
    {
        [self.delegate addGoodsCount:self.goodsCountField.text];
    }
}

//取消
- (IBAction)cancelChangeCount:(UIButton *)sender
{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(cancel)])
    {
        [self.delegate cancel];
    }
}

//确认数量
- (IBAction)doSureCount:(UIButton *)sender
{
    // 数量修改为0时，提示删除该数据
    if([_goodsCountField.text isEqualToString:@"0"] || ICIsStringEmpty(_goodsCountField.text))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"你确认要删除该商品吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.delegate =self;
        [alert show];
        
        return;
    }
    
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(sureChoice:)])
    {
        if(![_originCount isEqualToString:_goodsCountField.text])
        {
            [[TTIHttpClient shareInstance] editCartRequestWithsid:nil withcart_id:_goodsID
                                                 withgoods_number:_goodsCountField.text
                                                  withSucessBlock:^(TTIRequest *request, TTIResponse *response)
             {
                 [self.delegate sureChoice:_goodsCountField.text];
                 
             } withFailedBlock:^(TTIRequest *request, TTIResponse *response)
             {
                 [SVProgressHUD showErrorWithStatus:response.error_desc];
                 
             }];
        }
        else
             [self.delegate sureChoice:_goodsCountField.text];
    }
    
}


#pragma mark -- @protocol UIAlertViewDelegate <NSObject>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) // 取消
    {
    }
    else if (buttonIndex == 1) // 确定
    {
        
        [[TTIHttpClient shareInstance] deleteCartRequestWithsid:nil withcart_id:[NSArray arrayWithObject:_goodsID] withSucessBlock:^(TTIRequest *request, TTIResponse *response)
         {
             [self.delegate sureChoice:_goodsCountField.text];
             
         } withFailedBlock:^(TTIRequest *request, TTIResponse *response)
         {
             [SVProgressHUD showErrorWithStatus:response.error_desc];
             
         }];
    }
}
@end
