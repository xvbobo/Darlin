//
//  OpinionViewController.h
//  Yongai
//
//  Created by wangfang on 14/11/18.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTITextView.h"

/**
 *  意见反馈
 */
@interface OpinionViewController : UIViewController

@property (strong, nonatomic) IBOutlet TTITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end
