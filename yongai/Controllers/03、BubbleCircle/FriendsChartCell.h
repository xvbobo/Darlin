//
//  FriendsChartCell.h
//  Yongai
//
//  Created by myqu on 14/11/17.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  泡友榜页面的cell
 */
@interface FriendsChartCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *rankLabel;
@property (strong, nonatomic) IBOutlet UIImageView *headImgView;
@property (strong, nonatomic) IBOutlet UIImageView *flowerImgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLableTop;

@property (strong, nonatomic) IBOutlet UILabel *contributionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *stateImgView;
@property (strong, nonatomic) IBOutlet UIImageView *genderImgView;

@property (strong, nonatomic) IBOutlet UIButton *headImgButton;
@property (weak, nonatomic) IBOutlet UIImageView *line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineH;
@property (weak, nonatomic) IBOutlet UILabel *dengjiLabel;
@property(nonatomic, strong) RankModel  *rankInfo;
@property (weak, nonatomic) IBOutlet UIView *dengJIVIew;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dengjiBViewW;
@end
