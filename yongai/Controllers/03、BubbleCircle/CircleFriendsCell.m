//
//  CircleFriendsCell.m
//  Yongai
//
//  Created by arron on 14/11/7.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "CircleFriendsCell.h"
#import "UIImageView+WebCache.h"

@implementation CircleFriendsCell

- (void)awakeFromNib {
 
    _circleBtn0.tag = 0;
    self.nameLable1.textColor = RGBACOLOR(108, 97, 85, 1);
    self.descriptionLable1.textColor = RGBACOLOR(160, 154, 149, 1);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)circleBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(showCircleDetailViewByRow:btnTag:type:)])
        [self.delegate showCircleDetailViewByRow:self.tag btnTag:btn.tag type:_type];
}

- (void)updateCellDataDic:(BbsModel *)info1 {

    NSLog(@"%@",info1.fid);
    if (info1.fid) {
        [self.icon1 setImageWithURL:[NSURL URLWithString:info1.icon] placeholderImage:[UIImage imageNamed:Default_UserHead]];
        
        self.nameLable1.text = info1.name;
        self.descriptionLable1.text = info1.descp;
    }
    
}

@end
