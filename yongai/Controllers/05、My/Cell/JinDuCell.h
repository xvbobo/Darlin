//
//  JinDuCell.h
//  com.threeti
//
//  Created by alan on 15/11/4.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JinDuCellDelegate <NSObject>

- (void)buttonAction:(UIButton *) button withServeId:(NSString *)serveid;

@end
@interface JinDuCell : UITableViewCell
@property (nonatomic,strong) id <JinDuCellDelegate> delegate;
@property (nonatomic,strong) NSDictionary * model;
- (void)initWithDict:(NSDictionary *) dict withIndexPath:(NSIndexPath *)indexPath;
@end
