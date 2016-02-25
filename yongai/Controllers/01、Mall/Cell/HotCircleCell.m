//
//  HotCircleCell.m
//  Yongai
//
//  Created by Kevin Su on 14/11/19.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "HotCircleCell.h"

@implementation HotCircleCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initDataWithArray:(NSArray *)array{
    
    NSInteger count = array.count;
    if(count == 1){
        
        self.circle02View.hidden = YES;
        self.circle03View.hidden = YES;
        self.circle04View.hidden = YES;
    }else if(count == 2){
        
        self.circle03View.hidden = YES;
        self.circle04View.hidden = YES;
    }else if(count == 3){
        
        self.circle04View.hidden = YES;
    }
    
    for (int i = 0; i < count;  i++) {
        
        switch (i) {
            case 0:
            {
                [self.circle01ImageView setImageWithURL:[NSURL URLWithString:array[i][@"logo"]] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
                self.circle01TitleLabel.text = array[i][@"name"];
                break;
            }
            case 1:
            {
                [self.circle02ImageView setImageWithURL:[NSURL URLWithString:array[i][@"logo"]] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
                self.circle02TitleLabel.text = array[i][@"name"];
                break;
            }
            case 2:
            {
                [self.circle03ImageView setImageWithURL:[NSURL URLWithString:array[i][@"logo"]] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
                self.circle03TitleLabel.text = array[i][@"name"];
                break;
            }
            case 3:
            {
                [self.circle04ImageView setImageWithURL:[NSURL URLWithString:array[i][@"logo"]] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
                self.circle04TitleLabel.text = array[i][@"name"];
                break;
            }
                
            default:
                break;
        }
    }
}

- (IBAction)hotButtonClick:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    if(self.delegate && [self.delegate respondsToSelector:@selector(hotCircleClickAtIndex:)])
        [self.delegate hotCircleClickAtIndex:button.tag];
}

@end
