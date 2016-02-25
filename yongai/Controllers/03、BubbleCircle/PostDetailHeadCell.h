//
//  PostDetailHeadCell.h
//  Yongai
//
//  Created by arron on 14/11/11.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PostDetailHeadCellDelegate <NSObject>

/**
 *  显示事件触发的页面
 *
 *  @param tag 0:泡友榜 1:签到 2:精华区 3:领金币
 */
-(void)showActionViewWithTag:(int)tag;

/// 显示个人中心页面
-(void)showPersonalCenterView:(NSInteger)userId;
- (void)changeCell:(BOOL)YN;
/// 关注/取消关注
-(void)joinBtnClick;

@end

/**
 *  帖子详情页面headview
 */

@interface PostDetailHeadCell : UITableViewCell
@property(nonatomic, assign)id<PostDetailHeadCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *post_detail_line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *post_detail_lineH;

@property (strong, nonatomic) IBOutlet UIImageView *headImgView;
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descpLabel;
@property (strong, nonatomic) IBOutlet UIButton *isJoinBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upViewBootm;
@property (strong,nonatomic) UIButton * qianDaoBtn;
@property (strong,nonatomic) UILabel * qiandaoLabel;
@property (strong,nonatomic) UIImageView * imageQiandao;
@property (strong,nonatomic) UIButton * btn;
- (void)isOrNotQianDao:(NSString *) str;
@end
