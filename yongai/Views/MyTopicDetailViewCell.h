//
//  MyTopicDetailViewCell.h
//  Yongai
//
//  Created by myqu on 14/12/12.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConvertToCommonEmoticonsHelper.h"


#define PicImgViewHeight  86 //评论图片的默认高度
#define UserContentLabelHeight  18 //回复内容的默认高度


#define  ReplyHeadViewTop  10 // 被回复用户头像距离上方间隔
#define  ReplyHeadImgViewHeight  36 // 被回复用户头像高度


#define  ReplyTimeBtnHeight  20 // 被回复内容的时间显示高度
#define  ReplyTimeBtnTop   16   //时间按钮距离上方的间隔 3

#define  ReplyNameLabelTop  16  //被回复 姓名距离上方的间距 11
#define  ReplyNameLabelHeight  17  //被回复   姓名高度 17


#define  ReplyGenderImgViewHeight   15  //被回复人的性别 高度  15


#define  ReplyContentBottom  10 // 被回复内容距离上的间距
#define  ReplyContentTop     8 // 被回复内容距离下的间距

//被回复内容默认的高度  17
#define  ReplyContentDefaultHeight  12

#define  ReplyBgViewBottom   25 // 被回复整个view距离下方的间隔

//被回复整个view默认的高度  90
#define  ReplyBgViewDefaultHeight  90


/**
 *  我的话题详情 回复内容的Cell
 */
@interface MyTopicDetailViewCell : UITableViewCell
@property (nonatomic, strong)PostDetailModel *info;
@property (strong, nonatomic) NSString * user_id;
@property (strong,nonatomic)  NSMutableArray * subDictArray;//被引用回复的楼层
/**
 *  评论内容
 */
@property (strong, nonatomic) IBOutlet UIView *commentBgView;
@property (strong, nonatomic) IBOutlet UIImageView *userHeadImgView;
@property (strong, nonatomic) IBOutlet UIButton *userHeadImgButton;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userGenderImgView;
@property (strong, nonatomic) IBOutlet UIImageView *userRankImgView;//皇冠
@property (strong, nonatomic) IBOutlet UILabel *userContentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *picImgView;
@property (weak, nonatomic) IBOutlet UIImageView *downHuangGuan;


// 约束更新
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *userContentLabelHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *picImgViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upHuangGuanLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upLouzhuLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upHuangW;

/**
 *  被回复的内容
 */
@property (strong, nonatomic) IBOutlet UIView *replyBgView; // 回复内容的大视图

@property (strong, nonatomic) IBOutlet UIImageView *replyBgImgView; // 回复内容的背景
@property (strong, nonatomic) IBOutlet UIImageView *replyHeadImgView; // 用户头像
@property (strong, nonatomic) IBOutlet UIButton *replyHeadImgButton;
@property (strong, nonatomic) IBOutlet UILabel *replyNameLabel; // 姓名
@property (strong, nonatomic) IBOutlet UIImageView *replyGenderImgView; //性别
@property (weak, nonatomic) IBOutlet UILabel *replyTimeDown;
@property (strong, nonatomic) IBOutlet UIButton *replyTimeBtn; //时间
@property (strong, nonatomic) IBOutlet UILabel *replyContentLabel; //内容

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userHeadViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *huiFuHeadViewW;
@property (weak, nonatomic) IBOutlet UIImageView *downLouZhu;

// 动态改变的约束

// 回复内容距离下的间距 10
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *replyBgViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyViewHeight;

// 姓名距离上方的间距 11  姓名高度 17
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *replyNameLabelTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *replyNameLabelHeight;

// 头像距离上下的间距 15  头像高度 36
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *replyHeadViewTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *replyHeadImgViewHeight;


//时间高度  20
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *replyTimeBtnHeight;
//时间按钮距离上方的间隔 3


// 回复人的性别 高度  15
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *replyGenderImgViewHeight;

//新加button
@property (weak, nonatomic)  IBOutlet UIButton *huiFuBtn;


// 回复内容距离上下的间距 11
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *replyContentBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *huifuLableHeiht;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *huiFuBigViewHeight;

//楼主
@property (weak, nonatomic) IBOutlet UIImageView *upLouZhu;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upLouZhuH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upLouZhuW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downLouZhuW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downLouZhuH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downhuangW;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewYe;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *huiFuBtnRight;
@property (weak, nonatomic) IBOutlet UIImageView *line1;
@property (weak, nonatomic) IBOutlet UIImageView *line2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xiaLabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lin1H;
@property (nonatomic,strong) UILabel * shaFaLabelUp;
@property (nonatomic,strong) UILabel * shaFaLabelDown;
-(NSString *)getCellHeightByInfo;

@end
