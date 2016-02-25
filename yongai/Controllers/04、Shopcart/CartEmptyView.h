//
//  CartEmptyView.h
//  Yongai
//
//  Created by arron on 14/11/5.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CartEmptyDelegate <NSObject>

- (void)goToMall;

@end
@interface CartEmptyView : UIView
@property (assign , nonatomic)id<CartEmptyDelegate>emptyDelegate;
@property (weak, nonatomic) IBOutlet UIButton *carBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
