//
//  ShangPinViewCell.h
//  com.threeti
//
//  Created by alan on 15/8/31.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ShangPinViewCellDelegate <NSObject>

- (void)ShangPinViewCellButtonAction:(NSString*)goods_id;

@end
@interface ShangPinViewCell : UITableViewCell
@property(assign,nonatomic) id <ShangPinViewCellDelegate> delegate;
- (void)ShangPinWithArray:(NSArray*)shangpinArr;
@end
