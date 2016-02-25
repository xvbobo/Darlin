//
//  ProvinceSelectView.m
//  Yongai
//
//  Created by myqu on 14/11/28.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "ProvinceSelectView.h"
@implementation ProvinceSelectView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    
    self.dataSource = [[NSMutableArray alloc] init];
    self.myTableView.delegate = self;
    self.myTableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton *btn = (UIButton *)cell.accessoryView;
    btn.selected = !btn.selected;
    
    if(self.selectViewType == SelectView_Hobby)
    {
        HobbyModel * model = [_dataSource objectAtIndex:indexPath.row];
        model.selectStatus = [NSString stringWithFormat:@"%d", btn.selected];
    }
    
    if ([_delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
            [_delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProvinceSelectCell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProvinceSelectCell"];
    }
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-40, (44-20)/2, 20, 20)];
    [btn setImage:[UIImage imageNamed:@"cart_normal"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"cart_selected"] forState:UIControlStateSelected];
    btn.tag = indexPath.row;
    [btn  addTarget:self action:@selector(updateStatus:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = btn;
    
    if(self.selectViewType == SelectView_Hobby )
    {
        HobbyModel *model = [_dataSource objectAtIndex:indexPath.row];
        cell.textLabel.text = model.name;
        
        if([model.selectStatus isEqualToString:@"1"])
            btn.selected = YES;
        else
            btn.selected = NO;
    }
    else if (self.selectViewType == SelectView_Province)
    {
        RegionModel *model = [_dataSource objectAtIndex:indexPath.row];
        cell.textLabel.text = model.name;
    }
    else
    {
        cell.textLabel.text = [_dataSource objectAtIndex:indexPath.row];
    }
    
    if(_selectRow-1 == indexPath.row && self.selectViewType == SelectView_PayWayShow)
        btn.selected = YES;
    
    return cell;
}

-(void)updateStatus:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [self tableView:_myTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:0]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if ([_dataSource respondsToSelector:@selector(numberOfSectionsInTableAlert:)])
//        return [_dataSource numberOfSectionsInTableAlert:self];
//    
//    return 1;
//}

@end
