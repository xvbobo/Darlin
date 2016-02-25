//
//  MyGoldViewController.h
//  Yongai
//
//  Created by myqu on 14/11/5.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  我的金币页面
 */
@interface MyGoldViewController : UIViewController

@property (nonatomic, assign)BOOL bFromBubbleCircle;
@property (weak, nonatomic) IBOutlet UIImageView *goldTask;
@property (strong, nonatomic) UIImageView *backView;
@property (strong,nonatomic) NSString * myTitle;
@end
