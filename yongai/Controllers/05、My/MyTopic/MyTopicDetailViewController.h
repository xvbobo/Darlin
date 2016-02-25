//
//  MyTopicDetailViewController.h
//  Yongai
//
//  Created by wangfang on 14/11/14.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTopicDetailTopView.h"
#import "CommonTextView.h"
/**
 *  我的话题详情
 */
@interface MyTopicDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (copy,nonatomic,readwrite) void (^MyBlock)(NSString * string);
@property (nonatomic,strong) NSString * string;
@property (nonatomic,strong) NSString * quanString;
@property (strong, nonatomic) NSString *isJoic;// 是否加入本圈子
@property (strong, nonatomic) NSString *tid; // 话题id
@property (strong, nonatomic) NSString *fid; // 圈子id
@property (strong,nonatomic) NSArray * tag_ids;//标签id
@property (strong, nonatomic) NSString * userid;
@property (assign,nonatomic) CGFloat  dingwei;
@property (assign,nonatomic) NSString * pageT;
//@property (nonatomic,strong) NSString * quanString;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myTableViewH;

@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottom;

@property (strong, nonatomic) MyTopicDetailTopView *topView;

@property (strong, nonatomic)  UITextView *chatTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatBootmH;
@property (weak, nonatomic) IBOutlet UIImageView *chatBootm;

@property (strong, nonatomic) IBOutlet UIButton *pictureButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bootmVIewH;
@property (assign, nonatomic) BOOL isBulleCircle;// 判断是否由泡友圈进入该页面

@property (assign, nonatomic)BOOL bShowTabBar; // 返回时，是否显示tabbar
@property (nonatomic,strong) NSString * number;
- (IBAction)showSmileView:(id)sender;
- (IBAction)showPictureView:(id)sender;

@end
