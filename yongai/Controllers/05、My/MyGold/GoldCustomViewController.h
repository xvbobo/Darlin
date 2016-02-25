//
//  GoldCustomViewController.h
//  Yongai
//
//  Created by myqu on 14/11/5.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GoldViewType_Personal = 0,  // 完善个人资料
    GoldViewType_Attendance,   //每日签到
    GoldViewType_Invite,       //邀请好友
    GoldViewType_Ranking,      //泡友排行榜
    GoldViewType_Topic,        //话题加精华
    GoldViewType_Mall,         //商城购物
    GoldViewType_Evaluation,   //商品评价
} GoldCustomViewType;


/**
 *  我的金币首页cell中点击跳转的部分页面
 */
@interface GoldCustomViewController : UIViewController

@property (nonatomic, assign)BOOL bFromCircle;


@property (strong, nonatomic) IBOutlet UIView *anchorView;

@property (nonatomic, strong) GoldRuleModel *ruleInfo; //规则数据
@property (nonatomic, strong) NSString *imgTagName; // 图表

@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;

// 视图标签
@property (strong, nonatomic) IBOutlet UIImageView *viewImgView;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

// 金币奖励
@property (strong, nonatomic) IBOutlet UILabel *goldNumLabel;

//完成情况
@property (strong, nonatomic) IBOutlet UILabel *goldRatioLabel;

//完成情况描述
@property (strong, nonatomic) IBOutlet UILabel *goldDescpLabel;
@property (strong, nonatomic) IBOutlet UIWebView *myWebView;
@property (weak, nonatomic) IBOutlet UILabel *jinBiLable;
@property (weak, nonatomic) IBOutlet UILabel *doneLable;

// 下方button事件
@property (strong, nonatomic) IBOutlet UIButton *gotoBtn;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *viewContent;

- (IBAction)gotoBtnClick:(id)sender;
@property (strong,nonatomic) NSString * titleString;

@end
