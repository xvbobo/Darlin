//
//  MiaoShaViewController.h
//  com.threeti
//
//  Created by alan on 15/7/16.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnTextBlock)(NSString *showText);

@interface MiaoShaViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *productsArray;
@property (nonatomic, assign) NSInteger productIndex;
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;

- (void)returnText:(ReturnTextBlock)block;
@end
