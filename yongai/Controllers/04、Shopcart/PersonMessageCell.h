//
//  PersonMessageCell.h
//  com.threeti
//
//  Created by alan on 15/11/2.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonMessageCell : UITableViewCell
- (void)initWithModel:(AddressModel*) model withAdressString:(NSString *)adString;
- (void)upDateCellWith:(CGFloat)cellHeight;
@end
