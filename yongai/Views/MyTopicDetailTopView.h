//
//  MyTopicDetailTopView.h
//  Yongai
//
//  Created by wangfang on 14/11/14.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyTopicDetailTopViewDelegate <NSObject>
 

/**
 *  发送私信
 */
- (void)sendMessageAction;

/**
 *  举报帖子
 */
- (void)reportTopicAction;
    
    
@end


/**
 *  我的话题详情View
 */
@interface MyTopicDetailTopView : UIView <UIWebViewDelegate>

@property (nonatomic, strong)PostListModel  *postInfo;
@property (nonatomic, assign)CGFloat    viewHeight;

@property (nonatomic, assign)id <MyTopicDetailTopViewDelegate> delegate;
//楼主
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *louZhuW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *louZhuH;
@property (strong, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UIButton *headImgButton;
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *genderImgView;
@property (strong, nonatomic) IBOutlet UIImageView *rankImgView;
@property (strong, nonatomic) IBOutlet UIButton *sendMessageBtn;
@property (strong, nonatomic) IBOutlet UIButton *reportBtn;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleLabelHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentLabelHeight;


@property (strong, nonatomic) IBOutlet UIImageView *picImgView1;
@property (strong, nonatomic) IBOutlet UIImageView *picImgView2;
@property (strong, nonatomic) IBOutlet UIImageView *picImgView3;
@property (strong, nonatomic) IBOutlet UIImageView *picImgView4;
@property (strong, nonatomic) IBOutlet UIImageView *picImgView5;
@property (strong, nonatomic) IBOutlet UIImageView *picImgView6;
@property (strong, nonatomic) IBOutlet UIImageView *picImgView7;
@property (strong, nonatomic) IBOutlet UIImageView *picImgView8;


// 约束间隔设置
// 10
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *picImgViewHeight1;
// 10
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *picImgViewHeight2;
// 15
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *picImgViewHeight3;

// 10
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *picImgViewHeight4;
// 10
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *picImgViewHeight5;
// 15
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *picImgViewHeight6;
// 10
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *picImgViewHeight7;
// 15
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *picImgViewHeight8;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *louzhuLeft;


// 约束间隔设置
// 10
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *picImgViewBottom1;
// 10
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *picImgViewBottom2;
// 10
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *picImgViewBottom3;
@property (weak, nonatomic) IBOutlet UILabel *numbeLabel;

// 10
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *picImgViewBottom4;
// 10
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *picImgViewBottom5;
// 15
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *picImgViewBottom6;
// 10
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *picImgViewBottom7;
// 16
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *picImgViewBottom8;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstImaheViewTop;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *reportStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *line;

- (IBAction)reportBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *rightDownImage;
@property (weak, nonatomic) IBOutlet UIImageView *rightDownLine;
@property (nonatomic,strong) UILabel * huiLable;
@property (weak, nonatomic) IBOutlet UILabel *tieziName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tiziNameW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightDownViewW;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
@property (weak, nonatomic) IBOutlet UIImageView *dengjiImage;
@property (weak, nonatomic) IBOutlet UIView *UpView;
@property (weak, nonatomic) IBOutlet UIView *dashangView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dashangViewH;
@property (assign,nonatomic) NSInteger count;
@end
