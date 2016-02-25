//
//  ModifyNickNameViewController.h
//  Yongai
//
//  Created by myqu on 14/11/6.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  修改昵称的视图
 */
@interface ModifyNickNameViewController : UIViewController

// 昵称编辑框
@property (strong, nonatomic) IBOutlet UITextField *nickNameTextFiled;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UIButton *baoCunBtn;

// 保存按钮
- (IBAction)saveNameBtnClick:(id)sender;

@end
