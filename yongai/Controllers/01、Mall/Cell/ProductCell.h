//
//  ProductCell.h
//  Yongai
//
//  Created by Kevin Su on 14-11-1.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductCellDelegate <NSObject>

///显示商品详情页
- (void)showProductView:(UIButton*)btn;
- (void)showClassification:(NSString *)cid  title:(NSString *)title;
@end

//内衣热卖
@interface ProductCell : UITableViewCell

@property (nonatomic, assign) id<ProductCellDelegate> delegate;

- (void)initDataWithArray:(NSArray *)array andSectionTitle:(NSString*) string;

@end
