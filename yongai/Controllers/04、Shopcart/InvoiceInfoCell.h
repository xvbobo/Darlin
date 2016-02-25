//
//  InvoiceInfoCell.h
//  Yongai
//
//  Created by arron on 14/11/5.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InvoiceInfoCellDelegate <NSObject>
-(void)selectInvoiceType:(NSString *)type;
-(void)selectInvoiceContent:(NSString *)type;
-(void)updateInvoiceText:(NSString *)text;
@end

/**
 *  确认订单页面 发票信息cell
 */
@interface InvoiceInfoCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic, assign)id<InvoiceInfoCellDelegate> delegate;


@property (strong, nonatomic) IBOutlet UIButton *personalBtn; // 个人
@property (strong, nonatomic) IBOutlet UIButton *companyBtn; // 单位
@property (strong, nonatomic) IBOutlet UITextField *InvoiceTextFiled; // 发票抬头

@property (strong, nonatomic) IBOutlet UIButton *productDetailsBtn; // 商品详情
@property (strong, nonatomic) IBOutlet UIButton *officeBtn; // 办公用品

@property (strong, nonatomic) IBOutlet UIView *invoiveMarginView;
@property (weak, nonatomic) IBOutlet UILabel *faPiaoXinxi;
@property (weak, nonatomic) IBOutlet UILabel *faPiaoTaitou;
@property (weak, nonatomic) IBOutlet UILabel *faPiaoNeiRong;
@property (weak, nonatomic) IBOutlet UILabel *shangpin;
@property (weak, nonatomic) IBOutlet UILabel *danWei;
@property (weak, nonatomic) IBOutlet UILabel *geren;
@property (weak, nonatomic) IBOutlet UILabel *banGong;

//  选择发票类型
- (IBAction)invoiceTypeBtnClick:(id)sender;
// 选择发票内容
- (IBAction)invoiceContentBtnClick:(id)sender;

@end
