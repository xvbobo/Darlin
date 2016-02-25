//
//  MingxiCell.h
//  com.threeti
//
//  Created by alan on 15/7/2.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MingxiCell : UITableViewCell
@property (strong,nonatomic) UILabel * lable;
- (void)cellWithModel:(NSDictionary*)model;
@end
