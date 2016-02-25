//
//  RightChatViewCell.h
//  Yongai
//
//  Created by wangfang on 14/11/13.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  聊天界面
 */
@interface RightChatViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *headImg;
@property (strong, nonatomic) UIImageView *backImg;
@property (strong, nonatomic) UILabel *msgLable;
@property (strong, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImgW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageTop;

@property (strong, nonatomic) IBOutlet UIButton *headButton;

- (void)updateCellWithMessage:(MessageContentModel *)message;

@end
