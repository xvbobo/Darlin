//
//  HotCircleCell.h
//  Yongai
//
//  Created by Kevin Su on 14/11/19.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HotCircleCellDelegate <NSObject>

-(void)hotCircleClickAtIndex:(NSInteger)index;

@end


/// 商城首页 最热圈子cell
@interface HotCircleCell : UITableViewCell

@property (nonatomic, assign)id <HotCircleCellDelegate>delegate;

@property (strong, nonatomic) IBOutlet UIView *circle01View;
@property (strong, nonatomic) IBOutlet UIImageView *circle01ImageView;
@property (strong, nonatomic) IBOutlet UILabel *circle01TitleLabel;

@property (strong, nonatomic) IBOutlet UIView *circle02View;
@property (strong, nonatomic) IBOutlet UIImageView *circle02ImageView;
@property (strong, nonatomic) IBOutlet UILabel *circle02TitleLabel;

@property (strong, nonatomic) IBOutlet UIView *circle03View;
@property (strong, nonatomic) IBOutlet UIImageView *circle03ImageView;
@property (strong, nonatomic) IBOutlet UILabel *circle03TitleLabel;

@property (strong, nonatomic) IBOutlet UIView *circle04View;
@property (strong, nonatomic) IBOutlet UIImageView *circle04ImageView;
@property (strong, nonatomic) IBOutlet UILabel *circle04TitleLabel;

- (void)initDataWithArray:(NSArray *)array;

- (IBAction)hotButtonClick:(id)sender;

@end
