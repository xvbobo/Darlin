//
//  HisTopicViewController.h
//  Yongai
//
//  Created by myqu on 14/11/13.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>
//@protocol HisTopicViewControllerDelegate <NSObject>
//
//- (void)guanZhuBtn;
//- (void)SendGoldBtn;
//
//@end

/**
 *  他的话题页面
 */
@interface HisTopicViewController : UIViewController

@property (nonatomic, strong) NSString *userId;
@property (weak, nonatomic) IBOutlet UIView *BackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headW;
@property (weak, nonatomic) IBOutlet UIView *upView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewUp;
@property (weak, nonatomic) IBOutlet UIImageView *bigView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLableLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLableRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *UpViewH;
@property (weak, nonatomic) IBOutlet UIView *UpBigView;
@property (weak, nonatomic) IBOutlet UIImageView *guanzhuImage;
@property (strong,nonatomic) UILabel * noMessageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *noMessageView;
@property (strong,nonatomic) NSString * msid;
@end
