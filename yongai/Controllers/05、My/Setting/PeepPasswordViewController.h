//
//  PeepPasswordViewController.h
//  Yongai
//
//  Created by wangfang on 14/11/18.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHDigitInput.h"

/**
 *  防偷窥密码
 */
@interface PeepPasswordViewController : UIViewController
{
    CHDigitInput *digitInput;
}
@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIImageView *image;



@end
