//
//  FCXRefreshHeaderView.h
//  RefreshPrj
//
//  Created by fcx on 15/8/21.
//  Copyright (c) 2015年 fcx. All rights reserved.
//

#import "FCXRefreshBaseView.h"

@interface FCXRefreshHeaderView : FCXRefreshBaseView
/**
 *  是否自动刷新
 */
@property (nonatomic, unsafe_unretained) BOOL autoLoadMore;
@property (nonatomic,strong) NSString * gengGai;
+ (instancetype)headerWithRefreshHandler:(FCXRefreshedHandler)refreshHandler;

@end
