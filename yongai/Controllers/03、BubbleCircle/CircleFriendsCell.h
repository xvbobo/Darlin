//
//  CircleFriendsCell.h
//  Yongai
//
//  Created by arron on 14/11/7.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CircleFriendsCellDelegate <NSObject>

/// 显示泡友圈详情
-(void)showCircleDetailViewByRow:(NSInteger)row  btnTag:(NSInteger)tag  type:(NSInteger)type;

@end

/// 泡友圈页面上的 cell
@interface CircleFriendsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *circleCell1;

@property (weak, nonatomic) IBOutlet UIButton *circleBtn0;
@property (strong, nonatomic) IBOutlet UIImageView *icon1;
@property (strong, nonatomic) IBOutlet UILabel *nameLable1;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLable1;
@property (weak, nonatomic) IBOutlet UIImageView *lineView;
@property(nonatomic, assign)id<CircleFriendsCellDelegate> delegate;
- (void)updateCellDataDic:(BbsModel *)info1;

@property (nonatomic, assign)NSInteger  type; // section  0我的圈子 1推荐圈子

@end
