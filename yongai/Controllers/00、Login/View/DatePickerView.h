//
//  DatePickerView.h
//  Yongai
//
//  Created by Kevin Su on 14-11-6.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerViewDelegate <NSObject>

-(void)hideDatePickerView;
-(void)sureDatePickerView;

@end

@interface DatePickerView : UIView
@property(nonatomic, assign)id<DatePickerViewDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;


@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

@property (strong, nonatomic) IBOutlet UIButton *submitButton;

@property (nonatomic, strong)NSString  *selectDateStr;

@end
