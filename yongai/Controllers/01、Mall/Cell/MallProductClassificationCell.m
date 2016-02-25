//
//  MallProductClassificationCell.m
//  Yongai
//
//  Created by Kevin Su on 14/11/19.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MallProductClassificationCell.h"
#import "UIImageView+WebCache.h"
#import "DataTapGestureRecognizer.h"
#import "GTMBase64.h"
@implementation MallProductClassificationCell

- (void)awakeFromNib {
    // Initialization code
//    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithArray:(NSArray *)array{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    int jianGe = (UIScreenWidth - 60*4)/5;
//    int space,leftw;
//    if (UIScreenWidth > 320) {
//        space = 90;
//        leftw = 20;
//    }else{
//        space = 80;
//        leftw = 10;
//    }
    for (int i=0 ; i< array.count;i++) {
        NSDictionary * dict = array[i];
        NSString * dataStr = [dict objectForKey:@"name"];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(jianGe+(i%4)*(60+jianGe), 15+(i/4)*100, 60, 60)];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = imageView.frame.size.width/2;
        imageView.userInteractionEnabled = YES;
        [imageView setImageWithURL:[NSURL URLWithString:dict[@"logo"]] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
        DataTapGestureRecognizer *gesture = [[DataTapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        gesture.dataDic = dict;
        [imageView addGestureRecognizer:gesture];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x+2, imageView.frame.origin.y+imageView.frame.size.height, 60, 30)];
        label.text = dataStr;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = RGBACOLOR(108, 97, 85, 1);
        [self.contentView addSubview:label];
        [self.contentView addSubview:imageView];
    }
}

- (void)tapGesture:(DataTapGestureRecognizer *)gesture{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(showClassification:title:)]){
          [self.delegate showClassification:gesture.dataDic[@"id"] title:nil];
        
    }
}

@end
