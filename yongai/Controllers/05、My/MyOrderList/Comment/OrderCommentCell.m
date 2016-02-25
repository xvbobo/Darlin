//
//  OrderCommentCell.m
//  Yongai
//
//  Created by Kevin Su on 14/12/9.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "OrderCommentCell.h"
#import "UIImageView+AFNetworking.h"

#define COMMENT_MAC_MUMBER 150

@implementation OrderCommentCell{
    
    NSInteger maxLength;
}

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _commentTextView.placeholder = @"评价至少需要5个字哟";
    
    maxLength = COMMENT_MAC_MUMBER;
    self.commentTextView.delegate = self;
    self.tipLabel.text = [NSString stringWithFormat:@"还可以输入%i个字", maxLength];
    self.tipLabel.textColor = BLACKTEXT;
    self.pnameLabel.textColor = BLACKTEXT;
    self.pingFenLable.textColor = BLACKTEXT;
    self.pingJiaLable.textColor = BLACKTEXT;
    self.commentTextView.textColor = BLACKTEXT;
    [self initStarView];
}

- (void)initStarView {
    
    self.sView = [[AMRatingControl alloc] initWithLocation:CGPointMake(0, 0)
                                                emptyColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]
                                                solidColor:[UIColor colorWithRed:255/255.0 green:136/255.0 blue:71/255.0 alpha:1.0]
                                              andMaxRating:5];
    [self.sView setRating:5];
    
    [self.sView addTarget:self action:@selector(updateRating:) forControlEvents:UIControlEventEditingChanged];
    [self.sView addTarget:self action:@selector(updateEndRating:) forControlEvents:UIControlEventEditingDidEnd];
    
    [self.starView addSubview:self.sView];
}

#pragma mark - Private Methods

- (void)updateRating:(id)sender
{
    DLOG(@"Rating: %d", [(AMRatingControl *)sender rating]);
}

- (void)updateEndRating:(id)sender
{
    DLOG(@"End Rating: %d", [(AMRatingControl *)sender rating]);
    if(self.delegate && [self.delegate respondsToSelector:@selector(commentTextChanged:row:)])
        [self.delegate updateEndRating:[(AMRatingControl *)sender rating] row:self.tag];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initDataWithDictionary:(CartListGoodsModel *)info{
    
    if(info == nil){
        
        return;
    }
    
    _goodsInfo = info;
    
    [self.picImageView setImageWithURL:[NSURL URLWithString:_goodsInfo.img_url ]];
    self.pnameLabel.text = _goodsInfo.goods_name;
    self.commentTextView.text = _goodsInfo.commentInfo;
    self.sView.rating = _goodsInfo.rating.doubleValue;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    NSString *content = textView.text;
    if(textView.text.length > maxLength){
        
        [SVProgressHUD showErrorWithStatus:@"评论不能超过限定字数"];
        NSMutableString *mulStr = [[NSMutableString alloc] initWithString:content];
        [mulStr deleteCharactersInRange:NSMakeRange(mulStr.length - 1, 1)];
        textView.text = mulStr;
        return;
    }
    self.tipLabel.text = [NSString stringWithFormat:@"还可以输入%i个字", maxLength - content.length];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(commentTextChanged:row:)])
        [self.delegate commentTextChanged:content row:self.tag];
}

@end
