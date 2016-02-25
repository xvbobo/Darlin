//
//  OrderProductCell.h
//  Yongai
//
//  Created by Kevin Su on 14/11/30.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderProductCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *picImageView;

@property (strong, nonatomic) IBOutlet UILabel *pnameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *line;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LineH;

//- (void)initDataWithDictionary:(NSDictionary *)dataDic;

-(void)initDataWithInfo:(CartListGoodsModel *)goodsInfo;
@end
