//
//  JCTopic.m
//  PSCollectionViewDemo
//
//  Created by jc on 14-1-7.
//
//

#import "JCTopic.h"
#import "UIImageView+WebCache.h"

@implementation JCTopic
@synthesize JCdelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = frame;
        [self setSelf];
    }
    return self;
}
-(void)setSelf
{
    self.pagingEnabled = YES;
    self.scrollEnabled = YES;
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.backgroundColor = [UIColor whiteColor];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self setSelf];
    // Drawing code
}

-(void)upDate
{
    if (scrollTimer)
    {
        [scrollTimer invalidate];
        scrollTimer = nil;
    }
    for (UIView* view in self.subviews)
    {
        [view removeFromSuperview];
    }
    // 当图片少于1时，直接返回
    if ([self.pics count] < 1)
    {
        return;
    }
    
    
    // 当图片大于1个时，将self.pics最后一个图片添加至tempImageArray第一个图片，将self.pics第一个图片添加至tempImageArray最后 实现4+[1~4]+1
    if([self.pics count] >1) // add by my
    {
        NSMutableArray * tempImageArray = [[NSMutableArray alloc]init];
        [tempImageArray addObject:[self.pics lastObject]];
        for (id obj in self.pics)
        {
            [tempImageArray addObject:obj];
        }
        [tempImageArray addObject:[self.pics objectAtIndex:0]];
        self.pics = Nil;
        self.pics = tempImageArray;
    }
    
    int i = 0;
    for (id obj in self.pics)
    {
        pic= Nil;
        pic = [UIButton buttonWithType:UIButtonTypeCustom];
        //pic.imageView.contentMode = UIViewContentModeTop;
        [pic setFrame:CGRectMake(i*self.frame.size.width,0, self.frame.size.width, self.frame.size.height)];
        UIImageView * tempImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, pic.frame.size.width, pic.frame.size.height)];
        tempImage.contentMode = UIViewContentModeScaleToFill;
        [tempImage setClipsToBounds:YES];
        
        /**
         *  设置图片
         */
        NSURL *url = [NSURL URLWithString:obj];
        tempImage.contentMode = UIViewContentModeScaleToFill;
        [tempImage setImageWithURL:url placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
        
        [pic addSubview:tempImage];
        pic.tag = i;
        [pic addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:pic];
        
        i++;
    }
    
    [self setContentSize:CGSizeMake(self.frame.size.width*[self.pics count], self.frame.size.height)];
    
     // 当轮播图大于一个时，动态显示第二张图【4、1】
    if( [self.pics count] >1)
    {
        [self setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
    }
    
    // 当轮播图大于一个时，添加计时器，动态滚动
    if ([self.pics count] > 3)
    {
        scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(scrollTopic) userInfo:nil repeats:YES];
    }
}

-(void)click:(id)sender
{
    [JCdelegate didClick:[self.pics objectAtIndex:[sender tag]]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 当仅为一张图片时, 设置显示范围
    if(self.pics.count <2)
    {
        [self setContentOffset:CGPointMake(0, 0) animated:NO];
        return;
    }
    
    
    CGFloat Width = self.frame.size.width;
    if (scrollView.contentOffset.x == self.frame.size.width)
    {
        flag = YES;
    }
    if (flag)
    {
        if (scrollView.contentOffset.x <= 0)
        {
            [self setContentOffset:CGPointMake(Width * ([self.pics count] - 2), 0) animated:NO];
        }
        else if (scrollView.contentOffset.x >= Width * ([self.pics count] - 1))
        {
            [self setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
        }
    }
    currentPage = scrollView.contentOffset.x / self.frame.size.width - 1;
    [JCdelegate currentPage:currentPage total:[self.pics count] - 2];
    scrollTopicFlag = currentPage + 2 == 2 ? 2 : currentPage + 2;
}

-(void)scrollTopic
{
    [self setContentOffset:CGPointMake(self.frame.size.width*scrollTopicFlag, 0) animated:YES];
    
    if (scrollTopicFlag > [self.pics count])
    {
        scrollTopicFlag = 1;
    }
    else
    {
        scrollTopicFlag++;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(scrollTopic) userInfo:nil repeats:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollTimer)
    {
        [scrollTimer invalidate];
        scrollTimer = nil;
    }
}

-(void)releaseTimer
{
    if (scrollTimer)
    {
        [scrollTimer invalidate];
        scrollTimer = nil;
    }
}

-(void)restartTimer
{
    if (scrollTimer)
    {
        [scrollTimer invalidate];
        scrollTimer = nil;
    }
    scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(scrollTopic) userInfo:nil repeats:YES];
}
@end
