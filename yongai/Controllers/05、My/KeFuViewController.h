//
//  KeFuViewController.h
//  com.threeti
//
//  Created by alan on 15/10/8.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceView.h"
@interface KeFuViewController : UIViewController
@property (strong, nonatomic) ServiceView *serviceView;
@property (assign,nonatomic) BOOL if_new_message;
@end
