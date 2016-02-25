//
//  UserInfoCell.h
//  Yongai
//
//  Created by myqu on 14/11/6.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 我的信息页面的cell
@interface UserInfoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descpLabel;
@property (strong, nonatomic) IBOutlet UIButton *rightTriangleBtn;
@property (strong, nonatomic) IBOutlet UILabel *promptLabel;// 不可修改的账号提示label
@property (strong, nonatomic) IBOutlet UIImageView *headImgView;

@end
