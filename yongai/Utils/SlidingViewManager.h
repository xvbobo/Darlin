//
//  SlidingViewManager.h
//  notificationview
//
//  Created by Andrew Drozdov on 11/13/14.
//  Copyright (c) 2014 Andrew Drozdov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SlidingViewManager : NSObject

- (id)initWithInnerView:(UIView*)_innerView containerView:(UIView *)_containerView;
- (void)slideViewIn;
- (void)slideViewOut;

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
