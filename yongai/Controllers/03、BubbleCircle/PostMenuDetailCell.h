//
//  PostMenuDetailCell.h
//  Yongai
//
//  Created by arron on 14/11/11.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define Content_Font [UIFont systemFontOfSize:15.0]
//#define Content_Height   70.0

@protocol PostMenuDetailCellDelegate <NSObject>

/**
 *  点击不同标签的事件
 *
 *  @param tag 0:全部  1:男神  2:女神  3:派对
 */
-(void)postMenuBtnAction:(int)tag;

#pragma mark --- 帖子详情cell事件
/// 显示个人中心页面
-(void)showOtherCenterView:(NSString *)userId;

@end

/**
 *  帖子详情页面上置顶列表的cell ［置顶cell＋标签cell］
 */
@interface PostMenuDetailCell : UITableViewCell

@property(nonatomic, strong)id<PostMenuDetailCellDelegate> delegate;
@property (nonatomic,strong) UILabel * label;
#pragma mark --- 置顶的cell的cell
@property (strong, nonatomic) IBOutlet UILabel *dingDescpLabel;

#pragma mark --- 帖子列表的cell
@property (strong, nonatomic) IBOutlet UIImageView *headImgView; //头像
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViwW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImgLeft;
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel; //昵称
@property (strong, nonatomic) IBOutlet UIButton *addTimeLabel; //发帖时间
@property (strong, nonatomic) IBOutlet UIButton *replyBtn; //回复按钮
@property (strong, nonatomic) IBOutlet UILabel *replyCountLabel; //回复数

@property (strong, nonatomic) IBOutlet UIButton *statusBtn1; //精状态
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *jingImgWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jingImgH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jingLeft;

@property (strong, nonatomic) IBOutlet UIButton *statusBtn2; //热状态
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *hotImgWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hotImgH;

@property (strong, nonatomic) IBOutlet UIButton *statusBtn3; //新状态
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *xinImgWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xinImgH;


@property (strong, nonatomic) IBOutlet UILabel *subjectLabel; //主题
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
 //内容
@property (nonatomic, strong) PostListModel *listInfo;

-(NSString*)getContentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewH;
@property (weak, nonatomic) IBOutlet UIView *imageBackView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBackViewW;
@property (weak, nonatomic) IBOutlet UIImageView *zhiDingLine1;
@property (weak, nonatomic) IBOutlet UIImageView *zhiDingLine2;
@property (weak, nonatomic) IBOutlet UIImageView *detailLine1;
@property (weak, nonatomic) IBOutlet UIImageView *detailLine2;
- (void)createimageWithArray:(NSArray *)imageArr;
@end
