//
//  NewOrderFooterCell.h
//  com.threeti
//
//  Created by alan on 15/11/3.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewOrderFooterCellDelegate <NSObject>

- (void)NewOrderFooterCellButtonAction:(UIButton *) button;

@end
@interface NewOrderFooterCell : UITableViewCell
@property (nonatomic,strong) id <NewOrderFooterCellDelegate> delegate;
-(void)initDataWithInfo:(OrderListModel *)dataInfo index:(NSInteger)index;
@end
