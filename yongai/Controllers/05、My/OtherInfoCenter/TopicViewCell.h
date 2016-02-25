//
//  TopicViewCell.h
//  Yongai
//
//  Created by myqu on 14/11/13.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+Utils.h"

@protocol CancelBtnDelegate <NSObject>

- (void)whileCancelBtnClick;

@end
/**
 *  话题页面的cell
 */
@interface TopicViewCell : UITableViewCell
@property (copy,nonatomic) id <CancelBtnDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imgBgViewHeightConstraint;

@property (strong, nonatomic) IBOutlet UIView *imgBgView;
@property (strong, nonatomic) IBOutlet UIImageView *imgView0;
@property (strong, nonatomic) IBOutlet UIImageView *imgView1;
@property (strong, nonatomic) IBOutlet UIImageView *imgView2;

@property (strong, nonatomic) IBOutlet UILabel *replyCountLabel;
//@property (nonatomic,strong)  UIButton * cancelBtn;
@property (nonatomic,strong)  UIImageView * imageV;
@property (nonatomic,strong) NSString * cellName;
/**
 *  是否隐藏图片背景
 *
 *  @param bHide YES：是 NO：否
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelLeft;
-(void)hideImgBgView:(BOOL)bHide;

@property (nonatomic, strong) PostListModel  *postInfo;
- (void)initWith:(CGFloat)Height;
@end
