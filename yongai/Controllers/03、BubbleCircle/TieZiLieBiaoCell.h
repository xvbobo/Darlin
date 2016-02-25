//
//  TieZiLieBiaoCell.h
//  com.threeti
//
//  Created by alan on 15/7/24.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TieZiLieBiaoCell : UITableViewCell
@property (nonatomic, strong) PostListModel *postInfo;
@property (nonatomic,strong) NSArray * imageArr;
@property (nonatomic,assign) BOOL adTime;
- (void)createimageWithArray:(NSArray *)imageArr;
@end
