//
//  BuChongViewController.h
//  xv
//
//  Created by alan on 15/4/3.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuChongViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (copy,nonatomic,readwrite) void (^MyBlock)(NSString * string);

@end
