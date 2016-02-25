//
//  CaiNiXiHuan.m
//  com.threeti
//
//  Created by alan on 15/9/7.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import "CaiNiXiHuan.h"
@implementation CaiNiXiHuan
{
    UIScrollView * sv;
    UIImageView * image1;
    UIImageView * image2;
    UIPageControl * pageControl;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0,30,UIScreenWidth,400-70)];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10,10,200, 20)];
        label.textColor = TEXT;
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"猜你喜欢：";
        UIImageView * labelView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, UIScreenWidth, 20)];
        labelView.backgroundColor = [UIColor whiteColor];
        [labelView addSubview:label];
        [self addSubview:labelView];
        UIImageView * pageControlView = [[UIImageView alloc] initWithFrame:CGRectMake(0,sv.frame.origin.y+sv.frame.size.height, UIScreenWidth,20)];
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 10)];
        pageControl.pageIndicatorTintColor = [UIColor grayColor];
        pageControl.currentPageIndicatorTintColor = beijing;
        [pageControlView addSubview:pageControl];
        [self addSubview:pageControlView];
        image1 = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, UIScreenWidth, sv.frame.size.height-30)];
        image1.userInteractionEnabled = YES;
        image1.backgroundColor = [UIColor whiteColor];
        [sv addSubview:image1];
        image2 = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenWidth,0, UIScreenWidth, sv.frame.size.height-30)];
        image2.backgroundColor = [UIColor whiteColor];
        image2.userInteractionEnabled = YES;
        [sv addSubview:image2];
        CGFloat imageWith = 90;
        CGFloat  with = (UIScreenWidth  - 40 - imageWith*3)/2;
        
        for (int i = 0; i < 12; i++) {
    
            if (i < 6) {
                UIImageView * view1 = [[UIImageView alloc] initWithFrame:CGRectMake(20+i%3*(imageWith+with),20+i/3*(imageWith+65), imageWith, imageWith)];
                view1.hidden = YES;
                view1.tag = 100+i;
                view1.layer.borderColor = LINE.CGColor;
                view1.layer.borderWidth = 0.5;
                view1.layer.masksToBounds = YES;
                view1.layer.cornerRadius = 5;
                view1.backgroundColor = beijing;
                [image1 addSubview:view1];
                UILabel * Namelable = [[UILabel alloc] initWithFrame:CGRectMake(view1.frame.origin.x,view1.frame.origin.y+view1.frame.size.height+10, view1.frame.size.width, 30)];
                Namelable.tag = 200+i;
                Namelable.numberOfLines = 2;
                Namelable.textColor = TEXT;
                Namelable.font = [UIFont systemFontOfSize:12];
                Namelable.textAlignment = NSTextAlignmentCenter;
                [image1 addSubview:Namelable];
                UILabel * lableP = [[UILabel alloc] initWithFrame:CGRectMake(view1.frame.origin.x,Namelable.frame.origin.y+Namelable.frame.size.height, view1.frame.size.width, 20)];
                lableP.tag = 300+i;
                lableP.textColor = BLACKTEXT;
                lableP.font = [UIFont systemFontOfSize:12];
                [image1 addSubview:lableP];
                UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(view1.frame.origin.x, view1.frame.origin.y, view1.frame.size.width, view1.frame.size.height+Namelable.frame.size.height+lableP.frame.size.height);
                btn.tag = 1000+i;
                [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                [image1 addSubview:btn];
               
            }
            else{
                UIImageView * view1 = [[UIImageView alloc] initWithFrame:CGRectMake(20+(i-6)%3*(imageWith+with),20+(i-6)/3*(imageWith+65), imageWith, imageWith)];
                view1.hidden = YES;
                view1.backgroundColor = beijing;
                view1.layer.borderColor = LINE.CGColor;
                view1.layer.borderWidth = 0.5;
                view1.layer.masksToBounds = YES;
                view1.layer.cornerRadius = 5;
                view1.tag = 400+i;
                UILabel * namelable = [[UILabel alloc] initWithFrame:CGRectMake(view1.frame.origin.x,view1.frame.origin.y+view1.frame.size.height+10, view1.frame.size.width, 30)];
                namelable.tag = 500+i;
                namelable.numberOfLines = 2;
                namelable.textColor = TEXT;
                namelable.font = [UIFont systemFontOfSize:12];
                namelable.textAlignment = NSTextAlignmentCenter;
                UILabel * lableP = [[UILabel alloc] initWithFrame:CGRectMake(view1.frame.origin.x,namelable.frame.origin.y+namelable.frame.size.height, view1.frame.size.width, 20)];
                lableP.tag = 600+i;
                lableP.textColor = BLACKTEXT;
                lableP.font = [UIFont systemFontOfSize:12];
                [image2 addSubview:lableP];
                [image2 addSubview:view1];
                [image2 addSubview:namelable];
                UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(view1.frame.origin.x, view1.frame.origin.y, view1.frame.size.width, view1.frame.size.height+namelable.frame.size.height+lableP.frame.size.height);
                btn.tag = 2000+i;
                [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                [image2 addSubview:btn];
            }
            
            
        }
        sv.contentSize = CGSizeMake(sv.frame.size.width*2, sv.frame.size.height);
        [self addSubview:sv];
        sv.pagingEnabled = YES;
        sv.showsHorizontalScrollIndicator = NO;
        sv.showsVerticalScrollIndicator = NO;
        sv.delegate = self;

    }
   
    // Do any additional setup after loading the view, typically from a nib.
    return self;
}
- (void)btnAction:(UIButton*)button
{
    if ( [self.delegate respondsToSelector:@selector(ShangPinAction:)]) {
        [self.delegate ShangPinAction:[NSString stringWithFormat:@"%ld",button.tag]];
    }
    NSLog(@"%ld",(long)button.tag);
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger a = scrollView.contentOffset.x/UIScreenWidth;
    pageControl.currentPage = a ;
}
- (void)initWithArray:(NSArray*)array
{
    
    NSUInteger count;
    if (array.count > 12) {
        count = 12;
        pageControl.numberOfPages = 2;
    }else{
        count = array.count;
        if (count > 6) {
            pageControl.numberOfPages = 2;
        }else{
            pageControl.numberOfPages = 1;
        }
        
    }
    for (int i = 0; i< count; i++) {
       
         NSDictionary * dict = array[i];
        NSString * imageUrl = [dict objectForKey:@"img_url"];
        NSString * nameStr = [dict objectForKey:@"goods_name"];
        NSString * priceStr = [NSString stringWithFormat:@"￥%@",dict[@"price"]];
        NSString * goods_id = [dict objectForKey:@"goods_id"];

        if (i< 6) {

            UIImageView * view1 = (UIImageView *)[image1 viewWithTag:100+i];
            view1.hidden = NO;
            UILabel * label = (UILabel*)[image1 viewWithTag:200+i];
            UILabel * labelP = (UILabel*)[image1 viewWithTag:300+i];
            UIButton * btn = (UIButton*)[image1 viewWithTag:1000+i];
            btn.tag = goods_id.intValue;
            [view1 setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
            label.text = nameStr;
            labelP.text = priceStr;
//            labelP.text = @"￥47";
//            if (i==3) {
//                labelP.text = @"￥47";
//            }else{
//                labelP.text = priceStr;
//            }
            
            NSLog(@"%@",priceStr);
        }else{
            UIImageView * view1 = (UIImageView *)[image2 viewWithTag:400+i];
            view1.hidden = NO;
            UILabel * label = (UILabel*)[image2 viewWithTag:500+i];
            UILabel * labelP = (UILabel*)[image2 viewWithTag:600+i];
            UIButton * btn = (UIButton*)[image2 viewWithTag:2000+i];
            btn.tag = goods_id.intValue;
            [view1 setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
            label.text = nameStr;
            labelP.text = priceStr ;
        }
    }
}
@end
