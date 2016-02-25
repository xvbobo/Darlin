//
//  PublishViewController.h
//  Yongai
//
//  Created by myqu on 14/11/17.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  发布帖子页面
 */
@interface PublishViewController : UIViewController

@property(nonatomic, strong) NSString *fid;
@property (nonatomic ,strong) NSArray * biaoQianArr;
@property (nonatomic,strong) NSString * isShenHe;

@property (weak, nonatomic) IBOutlet UIImageView *labelVIew;
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UIScrollView *BGScroller;
@property (weak, nonatomic) IBOutlet UIView *BGVIew;
@property (weak, nonatomic) IBOutlet UIButton *FaceBtn;
@property (weak, nonatomic) IBOutlet UIButton *PHbtn;
@property (weak, nonatomic) IBOutlet UIButton *sheQubtn;
@property (weak, nonatomic) IBOutlet UILabel *xuanZhongLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xiaImageH;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xuanZhongTop;

@end
