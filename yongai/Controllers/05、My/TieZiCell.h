//
//  TieZiCell.h
//  com.threeti
//
//  Created by alan on 15/8/31.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TieZiCellDelegate <NSObject>

- (void)buttonAction:(NSString*)tid withFid:(NSString*)fid;

@end
@interface TieZiCell : UITableViewCell
@property (assign,nonatomic) id <TieZiCellDelegate> delegate;
- (void)TieZiWithArray:(NSArray*)array;
@end
