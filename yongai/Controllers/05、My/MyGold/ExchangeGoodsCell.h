//
//  ExchangeGoodsCell.h
//  Yongai
//
//  Created by myqu on 14/11/13.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExchangeGoodsCellDelegate <NSObject>

/**
 *  点击某个商品的事件响应
 *
 *  @param btnTag 商品对应的事件id
 */
-(void)didClickGoodsCell:(NSInteger)btnTag;

@end


/**
 *  兑换中心商品的cell
 */
@interface ExchangeGoodsCell : UITableViewCell

@property (nonatomic, strong)ExchangeListModel  *goods1;
@property (nonatomic, strong)ExchangeListModel  *goods2;

-(void)setgoodsInfo:(ExchangeListModel *)goods1 goods2:(ExchangeListModel *)goods2;

@property(nonatomic, assign)id<ExchangeGoodsCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIView *goodsBgView0;
@property (strong, nonatomic) IBOutlet UIView *goodsBgView1;


@property (strong, nonatomic) IBOutlet UIImageView *goodsImgView0;
@property (strong, nonatomic) IBOutlet UILabel *goodsNameLabel0;
@property (strong, nonatomic) IBOutlet UILabel *goodsGoldLabel0;

@property (strong, nonatomic) IBOutlet UIImageView *goodsImgView1;
@property (strong, nonatomic) IBOutlet UILabel *goodsNameLabel1;
@property (strong, nonatomic) IBOutlet UILabel *goodsGoldLabel1;

@property (strong, nonatomic) IBOutlet UIButton *goodsBtn0;
@property (strong, nonatomic) IBOutlet UIButton *goodsBtn1;

- (IBAction)goodsBtnClick0:(id)sender;
- (IBAction)goodsBtnClick1:(id)sender;

@end
