//
//  ChatViewController.h
//  Yongai
//
//  Created by wangfang on 14/11/13.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  聊天界面
 */
@interface ChatViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property(nonatomic, strong)MessageModel *message;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerViewBottom;
@property (nonatomic,strong) NSString * meStr;
@end
