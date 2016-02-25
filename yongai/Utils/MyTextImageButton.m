//
//  MyTextImageButton.m
//  Kaiyi
//
//  Created by rwang on 14-4-10.
//  Copyright (c) 2014年 rwang. All rights reserved.
//

#import "MyTextImageButton.h"

@implementation MyTextImageButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        frame.origin.y -= 2.0;
        self.title = [[UILabel alloc] initWithFrame:frame];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.backgroundColor = [UIColor clearColor];
        NSDictionary *currentStyle = [[UINavigationBar appearance] titleTextAttributes];
        //self.title.textColor = currentStyle[UITextAttributeTextColor];
        self.title.textColor = [UIColor whiteColor];
        self.title.font = currentStyle[UITextAttributeFont];
        self.title.shadowColor = currentStyle[UITextAttributeTextShadowColor];
        NSValue *shadowOffset = currentStyle[UITextAttributeTextShadowOffset];
        self.title.shadowOffset = shadowOffset.CGSizeValue;
        [self addSubview:self.title];
        
        self.arrow = [[UIImageView alloc] initWithImage:[MyTextImageButton arrowImage]];
        [self addSubview:self.arrow];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.title sizeToFit];
    self.title.center = CGPointMake(self.frame.size.width/2, (self.frame.size.height-2.0)/2);
    self.arrow.center = CGPointMake(CGRectGetMaxX(self.title.frame) + [MyTextImageButton arrowPadding], self.frame.size.height / 2);
}

#pragma mark -
#pragma mark Handle taps
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.isActive = !self.isActive;
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
//Arrow image near title
+ (UIImage *)arrowImage
{
    return [UIImage imageNamed:@"post_detail_sjx.png"];
}

//Distance between Title and arrow image
+ (float)arrowPadding
{
    return 13.0;
}
@end
