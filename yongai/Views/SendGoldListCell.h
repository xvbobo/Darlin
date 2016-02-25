//
//  SendGoldListCell.h
//  yongai
//
//  Created by wangfang on 15/1/22.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SendGoldListCellDelegate <NSObject>

-(void)showOtherInfoWithRow:(NSInteger)row;

@end

@interface SendGoldListCell : UITableViewCell
@property (nonatomic, assign) id <SendGoldListCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UILabel *goldNunLable;

-(void)updateCellWithDic:(NSDictionary *)dic;

// 点击头像按钮
- (IBAction)headBtnAction:(id)sender;
@end
