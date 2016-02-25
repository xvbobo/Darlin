//
//  PostsCell.h
//  Yongai
//
//  Created by myqu on 14/11/10.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  帖子cell
 */
@interface PostsCell : UITableViewCell

@property (nonatomic, strong) PostListModel *postInfo;

-(NSString *)getContentHeightByInfo:(PostListModel *)info;

@end
