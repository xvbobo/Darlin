//
//  MyCell.h
//  Yongai
//
//  Created by Kevin Su on 14-10-27.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIImageView *cellLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellineH;

@property (strong, nonatomic) IBOutlet UIImageView *pointRemindImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelWidth;


@end
