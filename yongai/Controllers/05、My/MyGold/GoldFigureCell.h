//
//  GoldFigureCell.h
//  Yongai
//
//  Created by myqu on 14/11/5.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoldFigureCelldelegate <NSObject>

// 跳转到他人个人中心页面
-(void)gotoOthersCenterWithRow:(NSInteger)row buttonIndex:(NSInteger)index;
-(void)gotoOthersCenterWithbuttonIndex:(NSInteger)index;
@end

/**
 *  送金币人物的cell -- 我的金币页面
 */
@interface GoldFigureCell : UITableViewCell

@property (nonatomic, assign)id<GoldFigureCelldelegate> delegate;

- (void)createCellWithArray:(NSArray *) array;
@end
