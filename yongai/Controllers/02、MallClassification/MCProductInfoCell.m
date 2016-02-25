//
//  MCProductInfoCell.m
//  Yongai
//
//  Created by Kevin Su on 14-11-10.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MCProductInfoCell.h"
#define jianGe (UIScreenWidth - 20)/4
@implementation MCProductInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        NSArray * nameArr = @[@"安全材质",@"正品承诺",@"保密配送",@"7天包退换"];
        int with ;
        int fenGe;
        if (UIScreenWidth > 320) {
            with = 25;
            fenGe = 5;
        }else{
            with = 20;
            fenGe =2;
        }
        for (int i= 0 ; i< 4; i++) {
            UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10+i*jianGe, 10, with, with)];
            imageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@1",nameArr[i]]];
            UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageview.frame.origin.x+with+fenGe, 10, 100, with)];
            nameLabel.text = nameArr[i];
            nameLabel.font = [UIFont systemFontOfSize:13];
            nameLabel.textColor = BLACKTEXT;
            [self.contentView addSubview:nameLabel];
            [self.contentView addSubview:imageview];
        }
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    self.goodsMessage.textColor = TEXT;
    self.pDescLabel.textColor = TEXT;
    self.preferentialLabel.textColor = beijing;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initDataWithInfo:(GoodsInfoModel *)info
{
    self.pDescLabel.text = info.goods_name;
    self.preferentialLabel.text = info.keywords;
    self.pDescLabel.numberOfLines = 0;
    [self.pDescLabel sizeToFit];
}
 

@end
