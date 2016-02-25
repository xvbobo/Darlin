//
//  YongaiYabbarController.h
//  Yongai
//
//  Created by Kevin Su on 14/11/19.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeepView.h"
#import "CHDigitInput.h"

@interface YongaiYabbarController : UITabBarController
{
    CHDigitInput *digitInput;
}
@property (strong, nonatomic) PeepView *peepView;

@end
