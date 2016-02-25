//
//  ConfirmReceptViewController.h
//  Yongai
//
//  Created by Kevin Su on 14/12/10.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//
//  确认收货
#import <UIKit/UIKit.h>
typedef void (^myBlock)(NSString * myTitle);
@interface ConfirmReceptViewController : UIViewController<UIAlertViewDelegate>
@property (nonatomic,copy) myBlock Myblock;
@property (strong, nonatomic) IBOutlet UITextView *confirmTextView;

@property (strong, nonatomic) IBOutlet UIButton *confirmButton;

@property (strong, nonatomic) NSString *order_id;
@property (strong, nonatomic) NSString *contentStr;
@property (strong,nonatomic) NSString * formStr;
@property (strong,nonatomic) NSArray * orderArray;
//确认收货
- (IBAction)confirmAction:(id)sender;
- (void)returnText:(myBlock)block;
@end
