//
//  UpdateGoodsCountView.h
//  Yongai
//
//  Created by arron on 14/11/3.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangeGoodsCountDelegate <NSObject>

/**
 *  添加商品数量
 *
 *  @param goodsCount 原商品数量
 */
- (void)addGoodsCount:(NSString*)goodsCount;

/**
 *  减少商品数量
 *
 *  @param goodsCount 原商品数量
 */
- (void)plusGoodsCount:(NSString*)goodsCount;

/**
 *  取消
 */
- (void)cancel;

/**
 *  确认修改商品数量
 *
 *  @param goodsCount 修改后的商品数量值
 */
- (void)sureChoice:(NSString*)goodsCount;

@end

@interface UpdateGoodsCountView : UIView<UIAlertViewDelegate>

@property(nonatomic, strong)NSString  *goodsID;
@property(nonatomic, strong)NSString *originCount;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (strong, nonatomic) IBOutlet UITextField *goodsCountField;//商品数量
@property (assign, nonatomic) id<ChangeGoodsCountDelegate>delegate;
@end

