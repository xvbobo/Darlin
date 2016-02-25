//
//  FCXRefreshHeaderView.m
//  RefreshPrj
//
//  Created by fcx on 15/8/21.
//  Copyright (c) 2015年 fcx. All rights reserved.
//

#import "FCXRefreshHeaderView.h"

@implementation FCXRefreshHeaderView

@synthesize refreshState = _refreshState;

+ (instancetype)headerWithRefreshHandler:(FCXRefreshedHandler)refreshHandler {

    FCXRefreshHeaderView *header = [[FCXRefreshHeaderView alloc] init];
    header.refreshHandler = refreshHandler;
    return header;
}
- (void)setAutoLoadMore:(BOOL)autoLoadMore {
    
    _autoLoadMore = autoLoadMore;
    if (_autoLoadMore) {//自动加载更多不显示箭头
        [_arrowImage removeFromSuperview];
        _arrowImage = nil;
        self.normalStateText = @"正在加载更多...";
        self.pullingStateText = @"正在加载更多...";
        self.loadingStateText = @"正在用力加载，请骚等~";
    }
}

- (void)setStateText {
    if ([self.gengGai isEqualToString:@"1"]) {
        self.normalStateText = @"下拉加载";
        self.pullingStateText = @"松开可加载";
        self.loadingStateText = @"正在加载...";
    }else {
        self.normalStateText = @"下拉刷新";
        self.pullingStateText = @"松开可刷新";
        self.loadingStateText = @"正在刷新...";
 
    }
}

- (void)addRefreshContentView {

    [super addRefreshContentView];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;

    //刷新状态
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.frame = CGRectMake(0, 15, screenWidth, 20);
    _statusLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    _statusLabel.textColor = FCXREFRESHTEXTCOLOR;
    _statusLabel.backgroundColor = [UIColor clearColor];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_statusLabel];

    //更新时间
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.frame = CGRectMake(0, 35, screenWidth, 20);
    _timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    _timeLabel.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_timeLabel];
    
    //箭头图片
    _arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueArrow"]];
    _arrowImage.frame = CGRectMake(screenWidth/2.0 - 100, (FCXLoadingOffsetHeight - 40)/2.0 + 5, 15, 40);
    [self addSubview:_arrowImage];
    
    //转圈动画
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityView.frame = _arrowImage.frame;
    [self addSubview:_activityView];
    
    [self updateTimeLabelWitLastUpdateTime:[NSDate date]];
}
//超过scrollview的contentSize高度
//- (CGFloat)exceedScrollviewContentSizeHeight {
//    
//    //获取scrollview实际显示内容高度
//    CGFloat actualShowHeight = self.scrollView.frame.size.height - _originalEdgeInset.bottom - _originalEdgeInset.top;
//    return self.scrollView.contentOffset.y - (self.scrollView.contentSize.height - actualShowHeight);
//}
- (void)scrollViewContentOffsetDidChange {
    
//    if (self.autoLoadMore) {//如果是自动加载更多
////        if ([self exceedScrollviewContentSizeHeight] > 1) {//大于偏移量1，转为加载更多loading
//            self.refreshState = FCXRefreshStateLoading;
////        }
//        return;
//    }

    if (self.scrollView.isDragging) {//正在拖拽
        if (self.scrollView.contentOffset.y < -FCXLoadingOffsetHeight) {//大于偏移量，转为pulling
            
            self.refreshState = FCXRefreshStatePulling;
            
        }else {//小于偏移量，转为正常normal
            
            self.refreshState = FCXRefreshStateNormal;
        }
        
    } else {
        if (self.refreshState == FCXRefreshStatePulling) {//如果是pulling状态，改为刷新加载loading
            
            self.refreshState = FCXRefreshStateLoading;
            
        }else if (self.scrollView.contentOffset.y > -FCXLoadingOffsetHeight) {//如果小于偏移量，转为正常normal
            
            self.refreshState = FCXRefreshStateNormal;
        }
    }
    
}

- (void)setRefreshState:(FCXRefreshState)refreshState {

    FCXRefreshState lastRefreshState = _refreshState;
    
    if (_refreshState != refreshState) {
        _refreshState = refreshState;
        
        __weak __typeof(self)weakSelf = self;

        switch (refreshState) {
            case FCXRefreshStateNormal:
            {
                _statusLabel.text = self.normalStateText;
                if (lastRefreshState == FCXRefreshStateLoading) {//之前是在刷新
                    [self updateTimeLabelWitLastUpdateTime:[NSDate date]];
                }
                _arrowImage.hidden = NO;
                [_activityView stopAnimating];
                
                [UIView animateWithDuration:0.2 animations:^{
                    _arrowImage.transform = CGAffineTransformIdentity;
                    weakSelf.scrollView.contentInset = _originalEdgeInset;
                }];
            }
                break;
                
            case FCXRefreshStatePulling:
            {
                _statusLabel.text = self.pullingStateText;

                [UIView animateWithDuration:0.2 animations:^{
                    _arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
                }];

            }
                break;
            case FCXRefreshStateLoading:
            {
                _statusLabel.text = self.loadingStateText;
                
                [_activityView startAnimating];
                _arrowImage.hidden = YES;
                _arrowImage.transform = CGAffineTransformIdentity;

                [UIView animateWithDuration:0.2 animations:^{

                    UIEdgeInsets edgeInset = _originalEdgeInset;
                    edgeInset.top += FCXLoadingOffsetHeight;
                    weakSelf.scrollView.contentInset = edgeInset;
 
                }];

                if (self.refreshHandler) {
                    self.refreshHandler(self);
                }
            }
                break;
            case FCXRefreshStateNoMoreData:
            {
            }
                break;
        }
    }
}

- (void)startRefresh {

    __weak __typeof(self)weakSelf = self;
    weakSelf.refreshState = FCXRefreshStateLoading;

    [UIView animateWithDuration:.2 animations:^{
       weakSelf.scrollView.contentOffset = CGPointMake(0, -FCXLoadingOffsetHeight);
    } completion:^(BOOL finished) {
        weakSelf.refreshState = FCXRefreshStateLoading;
    }];
}

- (void)updateTimeLabelWitLastUpdateTime:(NSDate *)lastUpdateTime
{
    if (!lastUpdateTime){
        _timeLabel.text = @"最后更新：无记录";
        return;
    }
    
    //获得年月日
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:lastUpdateTime];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    //格式化日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([cmp1 day] == [cmp2 day]) { // 今天
        formatter.dateFormat = @"今天 HH:mm";
    } else if ([cmp1 year] == [cmp2 year]) { // 今年
        formatter.dateFormat = @"MM-dd HH:mm";
    } else {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    NSString *time = [formatter stringFromDate:lastUpdateTime];
    //显示日期
    _timeLabel.text = [NSString stringWithFormat:@"最后更新：%@", time];
}


@end
