//
//  MyInfoViewController.h
//  Yongai
//
//  Created by myqu on 14/11/6.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  我的信息页面
 */
@interface MyInfoViewController : UIViewController
{
    UIDatePicker *datePicker; ///< 时间选择器
    UIToolbar *doneBar; // 时间选择器上的完成按钮
    
    UITextField *textField;
}
@property (weak, nonatomic) IBOutlet UIView *view1;
@end
