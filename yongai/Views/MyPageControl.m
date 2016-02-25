//
//  MyPageControl.m
//  com.threeti
//
//  Created by alan on 15/5/20.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import "MyPageControl.h"

@implementation MyPageControl

-(id) initWithFrame:(CGRect)frame
 {
     self = [super initWithFrame:frame];
         return self;
}
 -(void) updateDots
{
    for (int i=0; i<[self.subviews count]; i++) {
        
        UIImageView* dot = [self.subviews objectAtIndex:i];
        
        CGSize size;
        
        size.height = 8;     //自定义圆点的大小
        
        size.width = 8;      //自定义圆点的大小
        [dot setFrame:CGRectMake(dot.frame.origin.x, dot.frame.origin.y, size.width, size.width)];
        if (i==self.currentPage)dot.backgroundColor = RGBACOLOR(255, 97, 46, 1);
        
        else dot.backgroundColor =TEXT;
    }
}
-(void) setCurrentPage:(NSInteger)page {
         [super setCurrentPage:page];
        [self updateDots];
}
@end
