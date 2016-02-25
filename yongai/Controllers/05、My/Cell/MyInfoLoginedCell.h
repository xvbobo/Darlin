//
//  MyInfoLoginedCell.h
//  Yongai
//
//  Created by Kevin Su on 14-10-31.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol loginDelegate <NSObject>
- (void)downBtnAction:(UIButton *)button;
-(void)showLoginView;
@end
@interface MyInfoLoginedCell : UITableViewCell

@property (assign,nonatomic) id <loginDelegate> delegate;
@property (nonatomic,strong) UIButton * headBtn;
@property (nonatomic,strong) UIImageView * redImage;
@property (nonatomic,strong) UIImageView * redImage1;

@end
