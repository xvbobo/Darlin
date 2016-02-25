//
//  MallClassficationDetailViewController.h
//  Yongai
//
//  Created by Kevin Su on 14-11-7.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  商品分类页面
 */
@interface MallClassficationDetailViewController : UIViewController

//分类ID
@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic ,strong) NSString *myTitle;
@property (nonatomic,strong) NSString * titleLable;//从哪个页面进来
@end
