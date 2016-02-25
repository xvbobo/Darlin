//
//  GoldFigureCell.m
//  Yongai
//
//  Created by myqu on 14/11/5.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "GoldFigureCell.h"

@implementation GoldFigureCell
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self createCell];
//    }
//}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)createCell
{
    
}
- (void)createCellWithArray:(NSArray *)array
{
    if (array.count) {
        int space;
        int with;
        if (UIScreenWidth > 320) {
            space = 100;
            with = 60;
        
        }else{
            space = 80;
            with = 40;
        }
        for (int j = 0; j< array.count; j++) {
            GoldListModel *gold = [array objectAtIndex:j];
            UIButton * headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            headBtn.frame = CGRectMake(0, 0, 50, 50);
            headBtn.tag = gold.user_id.integerValue;
            [headBtn addTarget:self action:@selector(headViewWAction:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView * headView = [[UIImageView alloc ] initWithFrame:CGRectMake(with+(j%3)*space, 20+(j/3)*90-5, 50,50)];
            [headView  setImageWithURL:[NSURL URLWithString:gold.user_photo] placeholderImage:[UIImage imageNamed:Default_UserHead]];
            headView.userInteractionEnabled = YES;
            headView.layer.masksToBounds = YES;
            headView.layer.cornerRadius = headView.frame.size.width/2;
            headView.backgroundColor = beijing;
            [headView addSubview:headBtn];
            NSString * nameStr = gold.nickname;
            CGSize size = [nameStr sizeWithFont:[UIFont systemFontOfSize:12]];
            UILabel * name = [[UILabel alloc ] initWithFrame:CGRectMake(0,0,size.width, 20)];
            name.center = CGPointMake(headView.center.x, headView.center.y+headView.frame.size.height/2+10);
            name.text = nameStr;
            name.textColor = TEXT;
            name.textAlignment = NSTextAlignmentCenter;
            name.font = [UIFont systemFontOfSize:12];
            NSString * str0 = [NSString stringWithFormat:@"送币数:%@",gold.fg_num];
            CGSize labelsize = [str0 sizeWithFont:name.font];
            UILabel * jinBiNumber = [[UILabel alloc ] initWithFrame:CGRectMake(0,0,labelsize.width, name.frame.size.height)];
            jinBiNumber.text = str0;
            jinBiNumber.textColor = TEXT;
            jinBiNumber.center = CGPointMake(name.center.x, name.center.y+name.frame.size.height/2+10);
            jinBiNumber.textAlignment = NSTextAlignmentCenter;
            NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc ] initWithString:jinBiNumber.text];
            NSString * str = [jinBiNumber.text componentsSeparatedByString:@":"].lastObject;
            NSRange redRange = NSMakeRange(4, [str length]);
            [string1 addAttribute:NSForegroundColorAttributeName value:beijing range:redRange];
            [jinBiNumber setAttributedText:string1];
            jinBiNumber.font = [UIFont systemFontOfSize:12];
            [self.contentView addSubview:name];
            [self.contentView addSubview:jinBiNumber];
            [self.contentView addSubview:headView];
        }

    }
}
- (void)headViewWAction:(UIButton *) button {
    
//    UIButton *button = (UIButton *)sender;
    if(self.delegate && [self.delegate respondsToSelector:@selector(gotoOthersCenterWithbuttonIndex:)])
        [self.delegate gotoOthersCenterWithbuttonIndex:button.tag];
}
@end
