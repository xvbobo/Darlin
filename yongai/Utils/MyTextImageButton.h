//
//  MyTextImageButton.h
//  Kaiyi
//
//  Created by rwang on 14-4-10.
//  Copyright (c) 2014年 rwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTextImageButton : UIButton
@property (nonatomic, unsafe_unretained) BOOL isActive;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *arrow;

- (void)layoutSubviews;
@end
