//
//  MiaoShaCell.h
//  com.threeti
//
//  Created by alan on 15/7/16.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FlashProductCellDelegate <NSObject>

-(void)cellBtnClickByRow:(NSInteger)row;

@end
@interface MiaoShaCell : UITableViewCell
@property (nonatomic, assign) id<FlashProductCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *markpriceW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pnameLbaleH;

@property (strong, nonatomic) IBOutlet UIImageView *picImageView;

@property (strong, nonatomic) IBOutlet UILabel *pnameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discountW;

@property (strong, nonatomic) IBOutlet UILabel *discountLabel;

@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *qiangGou;

@property (strong, nonatomic) IBOutlet UILabel *marketPriceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zheKouTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *namelabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *markpricebottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonBottom;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *shouQinLabel;

- (void)initDataWithDictionary:(NSDictionary *)dataDic;

@end
