//
//  MCProductDetailCell.m
//  Yongai
//
//  Created by Kevin Su on 14-11-10.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MCProductDetailCell.h"
#import "TTIFont.h"
@implementation MCProductDetailCell
{
    int timeCount;
    NSString * discountStr;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.ScrollView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenWidth)];
        self.ScrollView.backgroundColor = BJCLOLR;
        [self.contentView addSubview:self.ScrollView];
        self.detailView = [[UIView alloc] initWithFrame:CGRectMake(0, UIScreenWidth, UIScreenWidth, 60)];
//        self.detailView.backgroundColor = beijing;
        [self.contentView addSubview:self.detailView];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, UIScreenWidth+5, UIScreenWidth-20, 40)];
        self.titleLabel.textColor = BLACKTEXT;
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.numberOfLines = 0;
        [self.detailView addSubview:self.titleLabel];
        self.detailLabel = [[UILabel alloc] init];
        self.detailLabel.numberOfLines = 0;
        self.detailLabel.font = [UIFont systemFontOfSize:15];
        self.detailLabel.textColor = beijing;
        [self.detailView addSubview:self.detailLabel];
        self.priceLable = [[UILabel alloc] init];
        self.priceLable.textColor = beijing;
        self.priceLable.font = font(20);
        [self.detailView addSubview:self.priceLable];
        self.ZengView = [[UIImageView alloc] init];
        self.ZengView.image = [UIImage imageNamed:@"cart_giftsIcon"];
        [self.detailView addSubview:self.ZengView];
        self.jiangView = [[UIImageView alloc] init];
        self.jiangView.image = [UIImage imageNamed:@"dropTag"];
        [self.detailView addSubview:self.jiangView];
        self.countLabel = [[UILabel alloc] init];
        self.countLabel.font = [UIFont systemFontOfSize:13];
        self.countLabel.textColor = TEXT;
        [self.detailView addSubview:self.countLabel];
        self.shijianView = [[UIImageView alloc] init];
        self.shijianView.image = [UIImage imageNamed:@"时钟1"];
        [self.detailView addSubview:self.shijianView];
        self.shijianLabel = [[UILabel alloc] init];
        self.shijianLabel.font = [UIFont systemFontOfSize:13];
        self.shijianLabel.textColor = TEXT;
       
//        self.contentView.backgroundColor = beijing;
        NSLog(@"%f",self.contentView.frame.size.height);
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)initCellWithDeatilInfo:(GoodsDetailInfoModel *)info withCellHeight:(CGFloat)cellHeight with:(NSString *)saleNum
{
    self.detailView.frame = CGRectMake(0, UIScreenWidth, UIScreenWidth, cellHeight-UIScreenWidth);
    if (self.imagesScrollView != nil) {
        
        [self.imagesScrollView removeFromSuperview];
    }
    self.titleLabel.text = info.goods_info.goods_name;
    int titleH = [ TTIFont calHeightWithText:self.titleLabel.text font:[UIFont systemFontOfSize:17] limitWidth:UIScreenWidth-20];
    self.titleLabel.frame = CGRectMake(10,10, UIScreenWidth-20, titleH);
    self.detailLabel.text = info.goods_info.keywords;
    int detailH = [TTIFont calHeightWithText:self.detailLabel.text font:[UIFont systemFontOfSize:15] limitWidth:UIScreenWidth-20];
    self.detailLabel.frame = CGRectMake(10, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+5, UIScreenWidth-20, detailH);
    self.priceLable.text = [NSString stringWithFormat:@"￥%.2f", [info.goods_info.price floatValue]];
    self.countLabel.text = saleNum;
    int countW = [saleNum sizeWithFont:[UIFont systemFontOfSize:14]].width;
    int priceW  = [self.priceLable.text sizeWithFont:font(20)].width;
    int H;
    if (self.detailLabel.text.length != 0) {
        self.detailLabel.hidden = NO;
        H = self.detailLabel.frame.origin.y+self.detailLabel.frame.size.height+5;
    }else{
        self.detailLabel.hidden = YES;
        H = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height+5;
       
    }
     self.priceLable.frame = CGRectMake(10,H, priceW, 30);
    self.shijianView.frame = CGRectMake(self.priceLable.frame.origin.x+5, self.priceLable.frame.origin.y+self.priceLable.frame.size.height+5, 15, 15);
//    self.shijianView.backgroundColor = beijing;
    NSString * shijianStr = info.goods_info.end_time;
    discountStr = [NSString stringWithFormat:@"%@折",info.goods_info.discount];
    if ([shijianStr isEqualToString:@"-1"]) {
        self.shijianLabel.hidden = YES;
        self.shijianView.hidden = YES;
    }else{
        [self createNstimer:shijianStr];
    }
    
    self.shijianLabel.frame = CGRectMake(self.shijianView.frame.origin.x+20, self.shijianView.frame.origin.y, UIScreenWidth, 15);
//    self.shijianLabel.backgroundColor = beijing;
    self.ZengView.frame = CGRectMake(self.priceLable.frame.origin.x+priceW+10, self.priceLable.frame.origin.y+7, 16, 16);
    self.jiangView.frame = CGRectMake(self.ZengView.frame.origin.x+self.ZengView.frame.size.width+5, self.ZengView.frame.origin.y, 16, 16);
    self.countLabel.frame = CGRectMake(UIScreenWidth-countW-10, self.priceLable.frame.origin.y, countW, 30);
    self.imagesScrollView = [[TTICycleScrollView alloc] initWithFrame:CGRectMake(0, 0,UIScreenWidth, UIScreenWidth)];
    self.imagesScrollView.datasource = self;
    self.imagesScrollView.delegate = self;
    self.imagesScrollView.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.imagesScrollView.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    
    self.picsArray = info.focus_item;
    if(self.picsArray.count != 0)
    {
        self.imagesScrollView.pageControl.hidden = NO;
    }
    else
        self.imagesScrollView.pageControl.hidden = YES;

    [self.ScrollView addSubview:self.imagesScrollView];
    [self.imagesScrollView reloadData];
    if([info.goods_info.is_zeng intValue] == 1){
        
        self.ZengView.hidden = NO;
    }
    else{
        self.ZengView.hidden = YES;
        self.jiangView.frame = self.ZengView.frame;
    }
    
    if([info.goods_info.is_down intValue] == 1){
        self.jiangView.hidden = NO;
    }
    else{
        self.jiangView.hidden = YES;
    }
    

}
#pragma mark -- 创建剩余时间
- (void)createNstimer:(NSString*)stirng
{
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeDown) userInfo:nil repeats:YES];
    if (stirng) {
        timeCount = stirng.intValue;
    }
}
- (void)timeDown
{
    
    timeCount--;
    if (timeCount == 0) {
        if ([self.delegate respondsToSelector:@selector(shijiandao)]) {
            [self.delegate shijiandao];
        }
    }
    int H = timeCount/3600;
    int m = (timeCount%3600)/60;
    int s = (timeCount%3600)%60;
//    self.shijianLabel.text = [NSString stringWithFormat:@"秒杀%@ 剩余%d时%d分%d秒",discountStr,H,m,s];
//    NSString * str = [NSString stringWithFormat:@"秒杀%@ 剩余%d时%d分%d秒",discountStr,H,m,s];
    if (discountStr) {
        NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc ] initWithString:[NSString stringWithFormat:@"秒杀%@ 剩余%d时%d分%d秒",discountStr,H,m,s]];
        NSRange redRange = NSMakeRange(2, [discountStr length]);
        [string1 addAttribute:NSForegroundColorAttributeName value:beijing range:redRange];
        [self.shijianLabel setAttributedText:string1];
         [self.detailView addSubview:self.shijianLabel];

    }
    
}


#pragma mark - TTICycleScrollViewDelegate methods

//- (void)didClickPage:(TTICycleScrollView *)csView atIndex:(NSInteger)index{
//    
//    //点击事件
//    NSString *url = @"www.baidu.com";
//    [[ UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
//}

#pragma mark - TTICycleScrollViewDatasource methods

- (NSInteger)numberOfPages{
    if([self.picsArray count] == 0)
        return 1;
    else
        return [self.picsArray count];
}

- (UIView *)pageAtIndex:(NSInteger)index{
    
    if([self.picsArray count] == 0)
    {
        UIImageView *newsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.imagesScrollView.frame.size.width, self.imagesScrollView.frame.size.height)];
        newsImageView.contentMode = UIViewContentModeScaleToFill;
        [newsImageView setImage:[UIImage imageNamed:Default_GoodsHead]];
        
        return newsImageView;
    }
    else
    {
        UIImageView *newsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.imagesScrollView.frame.size.width, self.imagesScrollView.frame.size.height)];
        newsImageView.contentMode = UIViewContentModeScaleToFill;
        
        ScrollImgModel *image = [self.picsArray objectAtIndex:index];
        [newsImageView setImageWithURL:[NSURL URLWithString:image.logo] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
        
        return newsImageView;
    }
}

@end
