//
//  JiBITableViewCell.h
//  com.threeti
//
//  Created by alan on 15/10/22.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JiBITableViewCell : UITableViewCell
@property (strong, nonatomic) UIImageView *backView;
@property (strong,nonatomic) NSString * jinBiStr;
@property (strong,nonatomic) UIButton * changeBtn;
@property (strong,nonatomic) UILabel * chajuLabel;
@property (strong,nonatomic) UILabel * jinbiLabel;
//- (void)cellInitWithInfo:()
@end
