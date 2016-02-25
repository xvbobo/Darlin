//
//  OrderCommentCell.h
//  Yongai
//
//  Created by Kevin Su on 14/12/9.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTITextView.h"
#import "AMRatingControl.h"

@protocol OrderCommentCellDelegate <NSObject>

-(void)commentTextChanged:(NSString *)content row:(int)index;
-(void)updateEndRating:(int)rating  row:(int)index;
@end


@interface OrderCommentCell : UITableViewCell<UITextViewDelegate>
@property (nonatomic, assign)id <OrderCommentCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIImageView *picImageView;

@property (strong, nonatomic) IBOutlet UILabel *pnameLabel;
//打星评分
@property (strong, nonatomic) IBOutlet UIView *starView;

@property (strong, nonatomic) IBOutlet TTITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UILabel *pingFenLable;
@property (weak, nonatomic) IBOutlet UILabel *pingJiaLable;

@property (strong, nonatomic) AMRatingControl *sView;

//剩余字数提示
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;

- (void)initDataWithDictionary:(CartListGoodsModel*)info;

@property (strong, nonatomic) CartListGoodsModel *goodsInfo;
@end
