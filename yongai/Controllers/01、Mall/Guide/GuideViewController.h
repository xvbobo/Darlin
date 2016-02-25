//
//  GuideViewController.h
//  Yongai
//
//  Created by Kevin Su on 14/12/1.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAIntroView.h"

/**
 *  初次启动加载页
 */
@interface GuideViewController : UIViewController<EAIntroDelegate>

@property (nonatomic, strong) UIImage *page_1;
@property (nonatomic, strong) UIImage *page_2;
@property (nonatomic, strong) UIImage *page_3;
@property (nonatomic, strong) UIImage *page_4;
@property (nonatomic, strong) UIImage *page_5;

@end
