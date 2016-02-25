//
//  DeletePictuerViewController.m
//  Yongai
//
//  Created by wangfang on 14/11/20.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "DeletePictuerViewController.h"

@interface DeletePictuerViewController ()

@end

@implementation DeletePictuerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NAV_INIT(self, nil, @"common_nav_back_icon", @selector(backAction), @"删除", @selector(deleteBtn));
    
    self.img.contentMode = UIViewContentModeScaleAspectFit;
    self.img.image = self.image;
}

- (void)backAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteBtn {
    
    // 向我的话题发送删除图片通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeletePictureNotification" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
