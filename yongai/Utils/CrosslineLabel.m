//
//  CrosslineLabel.m
//  YueTaoiPhone
//
//  Created by Kevin Su on 14-9-15.
//  Copyright (c) 2014年 com.threeti.yuetao. All rights reserved.
//

#import "CrosslineLabel.h"

@implementation CrosslineLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGSize contentSize = [self.text sizeWithFont:self.font constrainedToSize:self.frame.size];
    CGContextRef c = UIGraphicsGetCurrentContext();
//    TEXT213, 204,197, 1
    CGFloat color[4] = {213/255, 204/255, 197/255, 1.0};
    CGContextSetStrokeColor(c, color);
    CGContextSetLineWidth(c, 0.5);
    CGContextBeginPath(c);
    CGFloat halfWayUp = (self.bounds.size.height - self.bounds.origin.y) / 2.0;
    CGContextMoveToPoint(c, self.bounds.origin.x - 5, halfWayUp );
    CGContextAddLineToPoint(c, self.bounds.origin.x + contentSize.width + 5, halfWayUp);
    CGContextStrokePath(c);
    
    [super drawRect:rect];
}

@end
