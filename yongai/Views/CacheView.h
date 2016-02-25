//
//  CacheView.h
//  Yongai
//
//  Created by wangfang on 14/11/18.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CacheViewDelegate <NSObject>

- (void)changeCacheViewBtn:(id)sender;

@end

/**
 *  清空缓存View
 */
@interface CacheView : UIView

@property (strong, nonatomic) IBOutlet UIButton *sureButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;

@property (weak, nonatomic) id<CacheViewDelegate> delegate;

- (IBAction)changeBtn:(id)sender;

@end
