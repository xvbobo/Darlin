//
//  ProductCommentCell.h
//  Yongai
//
//  Created by Kevin Su on 14-11-12.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCommentCell :UITableViewCell

//评论人
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
//评论时间
@property (strong, nonatomic) IBOutlet UILabel *commentDateLabel;

// 规格
@property (strong, nonatomic) IBOutlet UILabel *specTitleLabel0;
@property (strong, nonatomic) IBOutlet UILabel *specContentLabel0;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentDateLabelWith;


//购买时间
@property (strong, nonatomic) IBOutlet UILabel *buyDateLabel;

//评论内容
@property (strong, nonatomic) IBOutlet UILabel *commentContentLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentTitleLabel;

- (void)initDataWithDictionary:(NSDictionary *)dataDic;
@end
