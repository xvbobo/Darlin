//
//  AttentionPersonCell.h
//  Yongai
//
//  Created by myqu on 14/11/10.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  我的关注- 看人cell
 */
@interface AttentionPersonCell : UITableViewCell
@property (strong, nonatomic)  UIImageView *headImgView;
@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UIImageView *sexImgView;
@property (strong, nonatomic)  UIImageView *rankLabel; //等级

- (void) setInfo:(RankModel *) dict;
@end
