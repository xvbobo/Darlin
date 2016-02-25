//
//  ProvinceSelectView.h
//  Yongai
//
//  Created by myqu on 14/11/28.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SelectView_PayWayShow = 1,
    SelectView_Province,
    SelectView_Hobby,
} SelectViewType;

@protocol ProvinceSelectViewDelegate <NSObject>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

/// 选择省份、市区、爱好的view
@interface ProvinceSelectView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIView *myHeadView;
@property (strong, nonatomic) IBOutlet UIView *myFootView;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel; // 谈框的标题
@property (nonatomic, strong)NSArray  *dataSource; // tableview的数据源

@property(nonatomic, assign)SelectViewType selectViewType; //
@property (nonatomic, assign)id<ProvinceSelectViewDelegate> delegate;


@property (nonatomic, assign)NSInteger  selectRow; // 目前选择的发票方式，用于选择是否开发票  默认+1， 区分为0 和 没有传递该值得情况
@end
