//
//  GoldRuleViewController.h
//  Yongai
//
//  Created by myqu on 14/11/6.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ExplainType_GoldRule = 0, // 金币规则
    ExplainType_RankRule, //等级说明
} ExplainType;

/**
 *  金币规则页面
 */
@interface GoldRuleViewController : UIViewController

@property (nonatomic, assign)ExplainType  type;

@property(nonatomic, strong)NSString *content; // 规则内容

@end
