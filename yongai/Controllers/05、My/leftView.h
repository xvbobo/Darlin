//
//  leftView.h
//  com.threeti
//
//  Created by alan on 15/10/8.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface leftView : UIView
@property (nonatomic,strong) UILabel * timeLabel;
@property (nonatomic,strong) UIImageView * LeftHeadView;
@property (nonatomic,strong) UILabel * contentLable;
@property (nonatomic,assign) BOOL shuaXin;
- (void)updataHeightAndWidth:(NSString *) contentText withIfTime:(BOOL)if_time;
@end
