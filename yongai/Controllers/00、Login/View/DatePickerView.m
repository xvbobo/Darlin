//
//  DatePickerView.m
//  Yongai
//
//  Created by Kevin Su on 14-11-6.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "DatePickerView.h"

@implementation DatePickerView
{
    NSMutableArray *yearArray;
    NSArray *monthArray;
    NSMutableArray *DaysArray;
    
    NSString *currentMonthString;
    
    int selectedYearRow;
    int selectedMonthRow;
    int selectedDayRow;
    
    BOOL firstTimeLoad;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    firstTimeLoad = YES;
    NSDate *date = [NSDate date];
    
//    common_button_background_blue
    self.submitButton.backgroundColor =blueBtn;
    // Get Current Year
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    NSString *year = [formatter stringFromDate:date];
    
    NSString *currentyearString = [NSString stringWithFormat:@"%d", year.intValue-19];
    
    
    // Get Current  Month
    [formatter setDateFormat:@"MM"];
    //    currentMonthString = [NSString stringWithFormat:@"%02d",[[formatter stringFromDate:date]integerValue]];
    currentMonthString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    // Get Current  Date
    [formatter setDateFormat:@"dd"];
    NSString *currentDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@年%@月%@日", currentyearString, currentMonthString, currentDateString];
    
    // PickerView -  Years data
    yearArray = [[NSMutableArray alloc]init];
    
    for (int i = 1900; i <= 1996 ; i++)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    
    // PickerView -  Months data
    monthArray = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
 
    
    // PickerView -  days data
    
    DaysArray = [[NSMutableArray alloc]init];
    
    for (int i = 1; i <= 31; i++)
    {
        [DaysArray addObject:[NSString stringWithFormat:@"%02d",i]];
        
    }
    
    selectedMonthRow = [monthArray indexOfObject:currentMonthString];
    
    // PickerView - Default Selection as per current Date
    
    [self.pickerView selectRow:[yearArray indexOfObject:currentyearString] inComponent:0 animated:YES];
    
    [self.pickerView selectRow:[monthArray indexOfObject:currentMonthString] inComponent:1 animated:YES];
    
    [self.pickerView selectRow:[DaysArray indexOfObject:currentDateString] inComponent:2 animated:YES];
    
    [self.submitButton addTarget:self action:@selector(actionDone:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton addTarget:self action:@selector(actionCancel:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        selectedYearRow = row;
        [self.pickerView reloadAllComponents];
    }
    else if (component == 1)
    {
        selectedMonthRow = row;
        [self.pickerView reloadAllComponents];
    }
    else if (component == 2)
    {
        selectedDayRow = row;
        
        [self.pickerView reloadAllComponents];
        
    }
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@年%@月%@日",
                          [yearArray objectAtIndex:[self.pickerView selectedRowInComponent:0]],
                          [monthArray objectAtIndex:[self.pickerView selectedRowInComponent:1]],
                          [DaysArray objectAtIndex:[self.pickerView selectedRowInComponent:2]]];
}


#pragma mark - UIPickerViewDatasource

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    // Custom View created for each component
    
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 50, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15.0f]];
    }
    
    
    
    if (component == 0)
    {
        pickerLabel.text = [NSString stringWithFormat:@"%@年", [yearArray objectAtIndex:row]] ; // Year
    }
    else if (component == 1)
    {
        pickerLabel.text =  [NSString stringWithFormat:@"%@月",[monthArray objectAtIndex:row]];  // Month
    }
    else if (component == 2)
    {
        pickerLabel.text =  [NSString stringWithFormat:@"%@日",[DaysArray objectAtIndex:row]]; // Date
        
    }

    
    return pickerLabel;
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (component == 0)
    {
        return [yearArray count];
        
    }
    else if (component == 1)
    {
        return [monthArray count];
    }
    else if (component == 2)
    { // day
        
        if (firstTimeLoad)
        {
            NSInteger currentMonth = selectedMonthRow+1;
            if (currentMonth == 1 || currentMonth == 3 || currentMonth == 5 || currentMonth == 7 || currentMonth == 8 || currentMonth == 10 ||currentMonth == 12)
                //            if (selectedMonthRow == 1 || selectedMonthRow == 3 || selectedMonthRow == 5 || selectedMonthRow == 7 || selectedMonthRow == 8 || selectedMonthRow == 10 ||selectedMonthRow == 12)
                
            {
                return 31;
            }
            else if (currentMonth == 2)
            {
                int yearint = [[yearArray objectAtIndex:selectedYearRow]intValue ];
                
                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                    
                    return 29;
                }
                else
                {
                    return 28; // or return 29
                }
                
            }
            else
            {
                return 30;
            }
            
        }
        else
        {
            
            if (selectedMonthRow == 0 || selectedMonthRow == 2 || selectedMonthRow == 4 || selectedMonthRow == 6 || selectedMonthRow == 7 || selectedMonthRow == 9 || selectedMonthRow == 11)
            {
                return 31;
            }
            else if (selectedMonthRow == 1)
            {
                int yearint = [[yearArray objectAtIndex:selectedYearRow]intValue ];
                
                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                    return 29;
                }
                else
                {
                    return 28; // or return 29
                }
                
                
                
            }
            else
            {
                return 30;
            }
            
        }
        
        
    }
    
    else
    { // am/pm
        return 2;
        
    }
    
}






//- (IBAction)actionCancel:(id)sender
//{
//    if(self.delegate && [self.delegate respondsToSelector:@selector(hideDatePickerView)])
//        [self.delegate hideDatePickerView];
//}
//
//- (IBAction)actionDone:(id)sender
//{
//    self.selectDateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",[yearArray objectAtIndex:[self.customPicker selectedRowInComponent:0]],[monthArray objectAtIndex:[self.customPicker selectedRowInComponent:1]],[DaysArray objectAtIndex:[self.customPicker selectedRowInComponent:2]],[hoursArray objectAtIndex:[self.customPicker selectedRowInComponent:3]],[minutesArray objectAtIndex:[self.customPicker selectedRowInComponent:4]]];
//    
//    if(self.delegate && [self.delegate respondsToSelector:@selector(sureDatePickerView)])
//        [self.delegate sureDatePickerView];
//    
//}

- (IBAction)actionCancel:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(hideDatePickerView)])
        [self.delegate hideDatePickerView];
}

- (IBAction)actionDone:(id)sender
{
    self.selectDateStr = [NSString stringWithFormat:@"%@年%@月%@日",
                          [yearArray objectAtIndex:[self.pickerView selectedRowInComponent:0]],
                          [monthArray objectAtIndex:[self.pickerView selectedRowInComponent:1]],
                          [DaysArray objectAtIndex:[self.pickerView selectedRowInComponent:2]]];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(sureDatePickerView)])
        [self.delegate sureDatePickerView];
    
}



@end
