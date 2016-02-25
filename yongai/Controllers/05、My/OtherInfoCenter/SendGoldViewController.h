//
//  SendGoldViewController.h
//  Yongai
//
//  Created by myqu on 14/11/11.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  送金币页面
 */
@interface SendGoldViewController : UIViewController

@property(nonatomic, strong) NSString *receiverId;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *xianYou;
@property (weak, nonatomic) IBOutlet UILabel *zengSong;

@end
