//
//  TieZiCell.m
//  com.threeti
//
//  Created by alan on 15/8/31.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import "TieZiCell.h"
#import "TTIFont.h"
@implementation TieZiCell
{
     UIView * view;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        view = [[UIView alloc] initWithFrame:CGRectMake(10,10, UIScreenWidth-20, 420)];
        view.userInteractionEnabled = YES;
        view.backgroundColor = [UIColor whiteColor];
        view.layer.masksToBounds = YES;
        view.layer.borderColor = LINE.CGColor;
        view.layer.borderWidth  = 1.0;
        view.layer.cornerRadius = 2;
        for (int i  =0 ; i< 6; i++) {
            UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width-70, 5+i*70, 60, 60)];
            image.userInteractionEnabled = YES;
//            image.backgroundColor = beijing;
            image.tag = 100+i;
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            btn.backgroundColor = BJCLOLR;
            btn.frame = CGRectMake(0, i*70,UIScreenWidth, 60);
            [btn addTarget:self action:@selector(buttonpress1:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 300+i;
//            btn.backgroundColor = BJCLOLR;
//            [btn insertSubview:view aboveSubview:view];
//
            UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, image.frame.origin.y+image.frame.size.height+5, view.frame.size.width, 0.5)];
            line.backgroundColor = LINE;
            [view addSubview:line];
            [view addSubview:image];
            [view addSubview:btn];
             UILabel * HotLable = [[UILabel alloc] initWithFrame:CGRectMake(15, image.frame.origin.y+20,35,20)];
            HotLable.tag = 400+i;
            HotLable.textAlignment = NSTextAlignmentCenter;
            HotLable.font = [UIFont systemFontOfSize:14];
            HotLable.layer.masksToBounds = YES;
            HotLable.layer.cornerRadius = 4;
            [view addSubview:HotLable];
            UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(20+HotLable.frame.size.width, image.frame.origin.y+10, view.frame.size.width-100-50, 40)];
            lable.tag = 200+i;
//            lable.backgroundColor = BJCLOLR;
//            lable.text = @"减肥最佳时刻表你造吗？";
//            lable.text = @"减肥最佳时刻表你造吗？不是什么好东西";
            lable.textColor =BLACKTEXT;
            lable.numberOfLines = 2;
            lable.font = font(16);
//            lable.font = [UIFont systemFontOfSize:17];
           
            [view addSubview: lable];
//            [self TieZiWithArray];
        }
        [self.contentView addSubview:view];
         self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)buttonpress1:(UIButton *)button
{
    if ( [self.delegate respondsToSelector:@selector(buttonAction:withFid:)]) {
        [self.delegate buttonAction:[NSString stringWithFormat:@"%ld",(long)button.tag] withFid:button.titleLabel.text];
    }
    NSLog(@"%ld",(long)button.tag);
}
- (void)TieZiWithArray:(NSArray *)array
{
    view.frame = CGRectMake(10,10, UIScreenWidth-20, array.count*70);
    view.userInteractionEnabled = YES;
    for (int i =0 ; i< array.count; i++) {
        UIImageView * image = (UIImageView*)[view viewWithTag:100+i];
        
//        image.userInteractionEnabled = YES;
        UILabel * lable = (UILabel*)[view viewWithTag:200+i];
        UIButton * btn = (UIButton*)[view viewWithTag:300+i];
        UILabel * Hot = (UILabel*)[view viewWithTag:400+i];
        PostListModelTui * model = array[i];
        [image setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
        lable.text = model.subject;
        btn.tag = model.tid.intValue;
        btn.titleLabel.text = model.fid;
        Hot.backgroundColor = RGBACOLOR(229, 2, 2, 1);
        Hot.text = @"热帖";
        Hot.textColor = [UIColor whiteColor];
        
        
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
