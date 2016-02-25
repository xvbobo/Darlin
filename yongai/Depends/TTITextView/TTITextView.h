//
//  TTITextView.h
//  iOSCodeProject
//
//  Created by Fox on 14-7-18.
//  Copyright (c) 2014年 翔傲信息科技（上海）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView ()
- (id)styleString;
@end

@interface TTITextView : UITextView

/**
 *	默认提示文字
 */
@property (nonatomic, retain) NSString *placeholder;

/**
 *  默认提示文字颜色
 */
@property (nonatomic, retain) UIColor *placeholderColor;

@end
