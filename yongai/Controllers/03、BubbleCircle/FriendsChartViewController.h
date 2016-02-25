//
//  FriendsChartViewController.h
//  Yongai
//
//  Created by myqu on 14/11/17.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  泡友榜
 */
@interface FriendsChartViewController : UIViewController

@property (nonatomic, strong) NSString *fid; //帖子id
@property (weak, nonatomic) IBOutlet UILabel *paiMingLable;
@property (weak, nonatomic) IBOutlet UILabel *bangLable;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIView *headView;

@end
