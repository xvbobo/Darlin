//
//  MCProductPicTextDetailViewController.h
//  Yongai
//
//  Created by Kevin Su on 14-11-12.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//
//  图文详情页面
#import <UIKit/UIKit.h>

@interface MCProductPicTextDetailViewController : UIViewController 

@property (strong, nonatomic) IBOutlet UIWebView *contentWebView;

@property (strong, nonatomic) NSString *contentHtmlStr;

@end
