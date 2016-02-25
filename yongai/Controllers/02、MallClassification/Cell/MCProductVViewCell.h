//
//  MCProductVViewCell.h
//  Yongai
//
//  Created by wangfang on 14/12/30.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MCProductVCellDelegate <NSObject>

-(void)cellSelectBtnClick:(NSString *)goodid;

@end

/**
 *  商品分类页面上  colloect 样式的cell
 */
@interface MCProductVViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *line1;
@property (weak, nonatomic) IBOutlet UIImageView *line2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line1W;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line2H;

@property(nonatomic, assign) id <MCProductVCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (strong, nonatomic) IBOutlet UIImageView *picView; //  商品图片
@property (strong, nonatomic) IBOutlet UIImageView *pConnerImageVew; // 商品 热销 标签
@property (strong, nonatomic) IBOutlet UILabel *pnameLabel; //  商品名称label
@property (strong, nonatomic) IBOutlet UILabel *priceLabel; // 商品价格 label
@property (strong, nonatomic) IBOutlet UIImageView *pZengView; //商品 赠 标签
@property (strong, nonatomic) IBOutlet UIImageView *pJiangView;  //商品 降 标签
@property (strong, nonatomic) IBOutlet UILabel *pMarketPriceLabel; // 市场价 label

@property (strong, nonatomic) IBOutlet UIImageView *picView2; //  商品图片
@property (strong, nonatomic) IBOutlet UIImageView *pConnerImageVew2; // 商品 热销 标签
@property (strong, nonatomic) IBOutlet UILabel *pnameLabel2; //  商品名称label
@property (strong, nonatomic) IBOutlet UILabel *priceLabel2; // 商品价格 label
@property (strong, nonatomic) IBOutlet UIImageView *pZengView2; //商品 赠 标签
@property (strong, nonatomic) IBOutlet UIImageView *pJiangView2;  //商品 降 标签
@property (strong, nonatomic) IBOutlet UILabel *pMarketPriceLabel2; // 市场价 label
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightJiangW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightJiangH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightZengW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightZengH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightJiangLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftZengH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftZengW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftJiangH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftJiangW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftJiangLeft;
@property (weak, nonatomic) IBOutlet UILabel *chengjiaoRight;

@property (weak, nonatomic) IBOutlet UILabel *chengjiaoLeft;
@property (nonatomic,strong) NSDictionary * dataDic1;
@property (nonatomic,strong) NSDictionary * dataDic2;
- (void)initWithData:(NSDictionary *)dataDic;
- (void)initWithData2:(NSDictionary *)dataDic;

- (void)showCellView;
- (void)hiddleCellView;

@end
