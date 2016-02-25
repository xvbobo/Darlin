//
//  CaiNiXiHuan.h
//  com.threeti
//
//  Created by alan on 15/9/7.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol   CaiNiXiHuanDelegate <NSObject>

- (void)ShangPinAction:(NSString *) goods_id;

@end
@interface CaiNiXiHuan : UIView <UIScrollViewDelegate,UICollectionViewDelegate>
@property (assign,nonatomic) id <CaiNiXiHuanDelegate> delegate;
//@property (assign,nonatomic) id <ScrollCollectionCellViewDelegate> delegate;
- (void)initWithArray:(NSArray*)array;
@end
