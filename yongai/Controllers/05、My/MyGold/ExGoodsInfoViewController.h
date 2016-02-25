//
//  ExGoodsInfoViewController.h
//  Yongai
//
//  Created by myqu on 14/11/13.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  兑换商品详情页面
 */
@interface ExGoodsInfoViewController : UIViewController

@property (nonatomic ,strong)NSString *goodsId;
@property (weak, nonatomic) IBOutlet UIView *viewFooter;
@property (weak, nonatomic) IBOutlet UILabel *nowLabel;
@property (weak, nonatomic) IBOutlet UIButton *duiHuanBtn;
@end
