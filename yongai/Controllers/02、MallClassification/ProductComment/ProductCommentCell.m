//
//  ProductCommentCell.m
//  Yongai
//
//  Created by Kevin Su on 14-11-12.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "ProductCommentCell.h"
#import "TTIFont.h"
@implementation ProductCommentCell

- (void)awakeFromNib{
    
    self.nameLabel.textColor = BLACKTEXT;
    self.commentContentLabel.textColor = BLACKTEXT;
    self.commentDateLabel.textColor = TEXT;
    self.specTitleLabel0.textColor = TEXT;
    self.specContentLabel0.textColor = BLACKTEXT;
    self.commentTitleLabel.textColor = TEXT;
}

- (void)initDataWithDictionary:(NSDictionary *)dataDic{
    
    if(!ICIsObjectEmpty(dataDic[@"user_name"])){
        
        self.nameLabel.text = dataDic[@"user_name"];
    }else
        self.nameLabel.text = @"永爱商城用户";
    
    self.commentDateLabel.text = dataDic[@"add_date"];
    
    self.commentContentLabel.text = dataDic[@"content"];
//    CGFloat with = [TTIFont calWidthWithText:dataDic[@"content"] font:[UIFont systemFontOfSize:13] limitWidth:20];
//    self.commentDateLabelWith.constant = with;
    if(self.commentContentLabel.text.length == 0)
        self.commentTitleLabel.hidden = YES;
    else
        self.commentContentLabel.hidden = NO;
    
    self.buyDateLabel.text = dataDic[@"buy_date"];
    
    
    self.specContentLabel0.text = dataDic[@"attr_value"];
    if(self.specContentLabel0.text.length == 0)
        self.specTitleLabel0.text = @"";
    else
        self.specTitleLabel0.text = @"规格:";
}

@end
