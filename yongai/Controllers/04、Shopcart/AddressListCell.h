//
//  AddressListCell.h
//  Yongai
//
//  Created by arron on 14/11/5.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditAddressDelegate <NSObject>

// 设置默认地址
- (void)selectDefaultAddress:(NSInteger)addId;

//编辑当前地址
- (void)editCurrentAddress:(NSInteger)addId;


@end

/**
 *  收货人地址cell
 */
@interface AddressListCell : UITableViewCell
{
    UIButton *lastButton;
}
@property(nonatomic, strong)AddressModel *addrInfo; // 收货人地址

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UIButton *defaultAddrBtn;//m默认地址按钮
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameH;

@property(nonatomic, assign)id<EditAddressDelegate>delegate;


@end

