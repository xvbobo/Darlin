//
//  LeftViewController.h
//  Yongai
//
//  Created by arron on 14/11/10.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  左侧滑菜单
 */
@interface LeftViewController : UIViewController

@property (weak ,nonatomic) IBOutlet UIImageView *topicImg;
@property (weak ,nonatomic) IBOutlet UILabel *topicLable;

@property (weak ,nonatomic) IBOutlet UIImageView *emailImg;
@property (weak ,nonatomic) IBOutlet UILabel *emailLable;

@property (weak ,nonatomic) IBOutlet UIImageView *attentionImg;
@property (weak ,nonatomic) IBOutlet UILabel *attentionLable;

@property (weak ,nonatomic) IBOutlet UIImageView *goldImg;
@property (weak ,nonatomic) IBOutlet UILabel *goldLable;

@property (strong, nonatomic) IBOutlet UIImageView *redPointImg;

@end
