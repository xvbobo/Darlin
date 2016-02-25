//
//  MallClassificationSearchView.h
//  Yongai
//
//  Created by Kevin Su on 14-11-7.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MallClassificationSearchView : UIView

@property (strong, nonatomic) IBOutlet UIView *saleTimeView;

@property (strong, nonatomic) IBOutlet UIView *priceView;

@property (strong, nonatomic) IBOutlet UIView *comprehensiveView;

@property (strong, nonatomic) IBOutlet UIView *salesVolumeView;

@property (strong, nonatomic) IBOutlet UIImageView *comBottomImageView;

@property (strong, nonatomic) IBOutlet UIImageView *priceBottomImageView;

@property (strong, nonatomic) IBOutlet UIImageView *saleBottomImageView;

@property (strong, nonatomic) IBOutlet UIImageView *volumeImageView;

@property (strong, nonatomic) IBOutlet UIImageView *saleIconImageView;

@property (strong, nonatomic) IBOutlet UIImageView *priceIconImageView;

@property (strong, nonatomic) IBOutlet UIImageView *comIconImageView;

@property (strong, nonatomic) IBOutlet UIImageView *volumeIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backView;
@end
