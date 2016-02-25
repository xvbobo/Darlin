//
//  OrderCommentViewController.m
//  Yongai
//
//  Created by Kevin Su on 14/12/9.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "OrderCommentViewController.h"
#import "CommonUtils.h"
#import "OrderCommentCell.h"
#import "QFControl.h"
#define QDBJ RGBACOLOR(23, 17, 26,0.7)
@interface OrderCommentViewController ()<OrderCommentCellDelegate>
{
    
    UIButton *confirmButton;//提交
    UIView *maskView; // 浮层视图
    UIImageView * qiandaoBj;//签到背景
    UILabel * qiandaoLB;
    UIScrollView * scrollerView;
}

@end

@implementation OrderCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
    scrollerView.backgroundColor = BJCLOLR;
    [self createInterface];
    scrollerView.contentSize = CGSizeMake(UIScreenWidth, 325*(self.productsArray.count+1)-100);
    [self.view addSubview:scrollerView];
    self.tableView.hidden = YES;
    self.tableView.backgroundColor = BJCLOLR;
    NAV_INIT(self, @"评价", @"common_nav_back_icon", @selector(back), nil, nil);
    maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
    maskView.alpha = 0;
    maskView.backgroundColor = QDBJ;
    qiandaoBj = [[UIImageView alloc] initWithFrame:CGRectMake(20, (UIScreenHeight-UIScreenWidth-40)/2, UIScreenWidth-40, UIScreenWidth-40)];
    qiandaoBj.image = [UIImage imageNamed:@"领取金币"];
    qiandaoLB = [[UILabel alloc] initWithFrame:CGRectMake(50, qiandaoBj.frame.size.height/4*3-40, qiandaoBj.frame.size.width-100, 30)];
    qiandaoLB.textColor = [UIColor whiteColor];
    qiandaoLB.font = [UIFont systemFontOfSize:17];
    qiandaoLB.textAlignment = NSTextAlignmentCenter;
    [qiandaoBj addSubview:qiandaoLB];
//    [maskView addSubview:qiandaoBj];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0,scrollerView.contentSize.height-200, self.view.frame.size.width, 100)];
    confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 145, 20, 131, 41)];
    [confirmButton setTitle:@"提交" forState:UIControlStateNormal];
    confirmButton.titleLabel.textColor = [UIColor whiteColor];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [confirmButton setBackgroundColor:beijing];
    confirmButton.layer.masksToBounds = YES;
    confirmButton.layer.cornerRadius = 5;
    [confirmButton addTarget:self action:@selector(confirmComments) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:confirmButton];
    [scrollerView addSubview:footerView];
    self.Myblock(@"评价");
   
}
- (void)returnText:(myBlock)block
{
    self.Myblock = block;
}
- (void)createInterface
{
    for (int i = 0; i< self.productsArray.count; i++) {
         OrderCommentCell *cell = [[[UINib nibWithNibName:@"OrderCommentCell" bundle:nil] instantiateWithOwner:self options:nil] lastObject];
        cell.frame = CGRectMake(0, i*325, UIScreenWidth, 325);
        CartListGoodsModel *model = self.productsArray[i];
        cell.tag = i;
//        UILabel * textViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 100, 30)];
//        textViewLabel.text = @"评价至少需要10个字哟";
//        textViewLabel.font = [UIFont systemFontOfSize:13.0];
//        [cell.commentTextView addSubview:textViewLabel];
        [cell initDataWithDictionary:model];
        cell.delegate = self;
        [scrollerView addSubview:cell];
    }
   
    
    
//    cell.delegate = self;
//    
//    CartListGoodsModel *model = self.productsArray[indexPath.row];
//    [cell initDataWithDictionary:model];
}
#pragma mark - UITableView Delegate && DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.productsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 325;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier = @"OrderCommentCell";
    OrderCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
        cell = [[[UINib nibWithNibName:@"OrderCommentCell" bundle:nil] instantiateWithOwner:self options:nil] lastObject];
   
    cell.tag = indexPath.row;
    cell.delegate = self;
    
    CartListGoodsModel *model = self.productsArray[indexPath.row];
    [cell initDataWithDictionary:model];

    return cell;
}

#pragma mark --  OrderCommentCellDelegate <NSObject>

-(void)commentTextChanged:(NSString *)content row:(int)index
{
    CartListGoodsModel *model = [self.productsArray  objectAtIndex:index];
    model.commentInfo = content;
    [self.productsArray replaceObjectAtIndex:index withObject:model];
}
-(void)updateEndRating:(int)rating  row:(int)index
{
    CartListGoodsModel *model = [self.productsArray  objectAtIndex:index];
    model.rating =[NSString stringWithFormat:@"%d", rating];
    [self.productsArray replaceObjectAtIndex:index withObject:model];
}

#pragma mark -------------------------  Detail Actions

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 提交按钮
- (void)confirmComments {
    
    __block BOOL bSend = YES;
    __block NSMutableArray *tempArray = [NSMutableArray array];
    
    [self.productsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        NSMutableDictionary *cDic = [NSMutableDictionary dictionary];
        CartListGoodsModel *model = (CartListGoodsModel *)obj;
        
        [cDic setValue:model.commentInfo forKey:@"content"];
        
        if(model.commentInfo.length == 0)
        {
            bSend = NO;
        }
        
        [cDic setValue:model.rating forKey:@"star_value"];
        [cDic setValue:model.product_id forKey:@"product_id"];
        
        [tempArray addObject:cDic];
    }];
    
    
    if(bSend == NO)
    {
        [SVProgressHUD showErrorWithStatus:@"评价内容不能为空"];
        return;
    }
    for (NSDictionary * dict in tempArray) {
        NSString * string = [dict objectForKey:@"content"];
        int strlength = 0;
        char* p = (char*)[string cStringUsingEncoding:NSUnicodeStringEncoding];
        for (int i=0 ; i<[string lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
            if (*p) {
                p++;
                strlength++;
            }
            else {
                p++;
            }
        }
        NSLog(@"%d",(strlength+1)/2);
        if (strlength < 10) {
            [SVProgressHUD showErrorWithStatus:@"评价至少需要5个字哟"];
            return;
        }
    }
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [[TTIHttpClient shareInstance] commentsOrderRequestWithsid:g_userInfo.sid
                                                      order_id:self.order_id
                                                       comment:tempArray
                                               withSucessBlock:^(TTIRequest *request, TTIResponse *response)
    {
        NSString * str = response.error_desc;
        if ([str isEqualToString:@"皇冠会员"]) {
            NSString * string = @"恭喜您，升级为皇冠会员 !";
            NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc ] initWithString:string];
            NSRange range1 = [string rangeOfString:str];
            NSRange redRange = NSMakeRange(range1.location, range1.length);
            [string1 addAttribute:NSForegroundColorAttributeName value:beijing range:redRange];
            UILabel * lable = [[UILabel alloc] init];
            [lable setAttributedText:string1];
            UIImageView * shengjiView = [QFControl createUIImageFrame:CGRectMake(30, (UIScreenHeight-UIScreenWidth+100)/2, UIScreenWidth-60, UIScreenHeight/3) imageName:@"升级" withStr1:string1 withStr: @"您可到个人中心“我的等级”页面查看详情" withStr3:@"么么哒~"];
            [UIView animateWithDuration:1.5 animations:^{
                maskView.alpha = 1;
            }];
            [maskView addSubview:shengjiView];
        }else{
            if (![response.error_desc isEqualToString:@"个"]) {
                qiandaoLB.text = [NSString stringWithFormat:@"恭喜~获得%@金币",response.error_desc];
                [UIView animateWithDuration:1.5 animations:^{
                    maskView.alpha = 1;
                }];
                [maskView addSubview:qiandaoBj];
            }
            
        }
        [self.navigationController.view addSubview:maskView];
        if ([str isEqualToString:@"皇冠会员"]) {
            [self performSelector:@selector(hideView) withObject:nil afterDelay:2.5];
        }else{
            [self performSelector:@selector(hideView) withObject:nil afterDelay:1.5];
        }
//        [SVProgressHUD showSuccessWithStatus:@"发表评论成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notify_RefreshOrderStatus object:@"已评价"];
                                                   
//        [self back];
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
}
- (void)hideView
{
    [UIView animateWithDuration:1.5 animations:^{
        maskView.alpha = 0;
    }];
    [self.navigationController popViewControllerAnimated:YES];
//    confirmButton.userInteractionEnabled = NO;
}
@end
