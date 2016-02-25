//
//  HostCityViewController.h
//  Yongai
//
//  Created by myqu on 14/11/27.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  所在城市
 */
@interface HostCityViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *provinceBtn;
@property (strong, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UIButton *baoCunBtn;


- (IBAction)provinceBtnClick:(id)sender;
- (IBAction)cityBtnClick:(id)sender;

- (IBAction)saveBtnClick:(id)sender;

@end
