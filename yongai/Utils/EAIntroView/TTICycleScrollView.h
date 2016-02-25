//
//  TTICycleScrollView.h
//  iOSCodeProject
//
//  Created by Fox on 14-7-18.
//  Copyright (c) 2014年 翔傲信息科技（上海）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTICycleScrollView;

@protocol TTICycleScrollViewDelegate <NSObject>

@optional
- (void)didClickPage:(TTICycleScrollView *)csView atIndex:(NSInteger)index;

@end

@protocol TTICycleScrollViewDatasource <NSObject>

@required
- (NSInteger)numberOfPages;
- (UIView *)pageAtIndex:(NSInteger)index;

@end

/**
 *  可循环滚动的ScrollView
 */
@interface TTICycleScrollView : UIView<UIScrollViewDelegate>{
    
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    
    NSInteger _totalPages;
    NSInteger _curPage;
    
    NSMutableArray *_curViews;
}

@property (nonatomic,readonly) UIScrollView *scrollView;
@property (nonatomic,readonly) UIPageControl *pageControl;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) id<TTICycleScrollViewDatasource> datasource;
@property (nonatomic,assign) id<TTICycleScrollViewDelegate> delegate;

- (void)reloadData;
- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index;

@end
