//
//  GoodsMessageCell.m
//  com.threeti
//
//  Created by alan on 15/11/2.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "GoodsMessageCell.h"
@implementation GoodsMessageCell
{
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0,100, UIScreenWidth, 0.5)];
        imageview.backgroundColor = LINE;
        [self addSubview:imageview];
        _goodPic = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        _goodPic.backgroundColor = BJCLOLR;
        _goodLabel = [[UILabel alloc] initWithFrame:CGRectMake(_goodPic.frame.origin.x+_goodPic.frame.size.width+10, _goodPic.frame.origin.y+_goodPic.frame.size.height/2-20, UIScreenWidth/3*2, 40)];
        _goodLabel.textColor = BLACKTEXT;
        _goodLabel.numberOfLines = 2;
        _goodLabel.font = [UIFont systemFontOfSize:13.0];
        [self addSubview:_goodLabel];
        [self addSubview:_goodPic];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}
-(void)initDataWithInfo:(CartListGoodsModel *)goodsInfo
{
    [_goodPic setImageWithURL:[NSURL URLWithString:goodsInfo.img_url] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
    _goodLabel.text = goodsInfo.goods_name;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
