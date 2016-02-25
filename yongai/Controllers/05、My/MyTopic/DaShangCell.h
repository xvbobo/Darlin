//
//  DaShangCell.h
//  com.threeti
//
//  Created by alan on 15/8/28.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DaShangCellDelegate <NSObject>

- (void)headClick:(NSString*)user_id;

@end
@interface DaShangCell : UITableViewCell
@property (assign,nonatomic) id <DaShangCellDelegate> delegate;
- (void)upCellWithDict:(NSDictionary*) dict;
@end
