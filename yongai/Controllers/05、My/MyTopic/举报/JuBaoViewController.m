//
//  JuBaoViewController.m
//  xv
//
//  Created by alan on 15/4/2.
//  Copyright (c) 2015年 com.threeti.yongai. All rights reserved.
//

#import "JuBaoViewController.h"
#import "BuChongViewController.h"
#define url @"localhost/app/controller/user/user_report.php"
@interface JuBaoViewController () {
    BOOL _isFirst;
    NSMutableArray * _btnArray;
    NSString * _string;
}

@end

@implementation JuBaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lalbel8.textColor = TEXT;
    self.lable9.textColor = TEXT;
    self.lablel1.textColor = BLACKTEXT;
    self.lable2.textColor  = BLACKTEXT;
    self.lable3.textColor  = BLACKTEXT;
    self.lable4.textColor  = BLACKTEXT;
    self.lable5.textColor  = BLACKTEXT;
    self.lable6.textColor  = BLACKTEXT;
    self.lable7.textColor  = BLACKTEXT;
    _btnArray = [[NSMutableArray alloc ] init];
    self.title = @"举报";
    self.imageViewTop.constant = 35;//调整间距
    [self.navigationController.navigationBar setTitleTextAttributes:
     
  @{NSFontAttributeName:[UIFont systemFontOfSize:19],
    
    NSForegroundColorAttributeName:[UIColor whiteColor]}];
    NAV_INIT(self, @"举报",nil, nil, @"提交", @selector(subBtn));
    [self createLeftBtn];
    [self.btn0 setImage:[UIImage imageNamed:@"jubao_selected"] forState:UIControlStateSelected];
    [self.btn1 setImage:[UIImage imageNamed:@"jubao_selected"] forState:UIControlStateSelected];
    [self.btn2 setImage:[UIImage imageNamed:@"jubao_selected"] forState:UIControlStateSelected];
    [self.btn3 setImage:[UIImage imageNamed:@"jubao_selected"] forState:UIControlStateSelected];
    [self.btn4 setImage:[UIImage imageNamed:@"jubao_selected"] forState:UIControlStateSelected];
    [self.btn5 setImage:[UIImage imageNamed:@"jubao_selected"] forState:UIControlStateSelected];
        // Do any additional setup after loading the view.
    self.view.backgroundColor = BJCLOLR;
}
- (void)createLeftBtn
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 20)];
    UILabel *titleTxt = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    titleTxt.text = @"取消";
    [titleTxt setFont:[UIFont systemFontOfSize:15.0f]];
    titleTxt.textColor = [UIColor whiteColor];
    titleTxt.textAlignment = NSTextAlignmentRight;
    [button addSubview:titleTxt];
    [button addTarget:self action:@selector(cancleBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [titleTxt setBackgroundColor:[UIColor clearColor]];
    [button setBackgroundColor:[UIColor clearColor]];
    UIBarButtonItem *LeftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = LeftBtnItem;
}
- (void)cancleBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)subBtn
{
    [_btnArray removeAllObjects];
    NSString * report_type;
    NSUserDefaults * db = [NSUserDefaults standardUserDefaults];
    NSString * report_note = [db objectForKey:@"contenView"];
    NSLog(@"report_note = %@",report_note);
    if (self.btn0.selected == YES) {
        [_btnArray addObject:[NSString stringWithFormat:@"%ld",self.btn0.tag - 100]];
    }if (self.btn1.selected == YES) {
        [_btnArray addObject:[NSString stringWithFormat:@"%ld",self.btn1.tag - 100]];
        
    }if (self.btn2.selected == YES) {
        [_btnArray addObject:[NSString stringWithFormat:@"%ld",self.btn2.tag - 100]];
    }if (self.btn3.selected == YES) {
        [_btnArray addObject:[NSString stringWithFormat:@"%ld",self.btn3.tag - 100]];
    }if (self.btn4.selected == YES) {
        [_btnArray addObject:[NSString stringWithFormat:@"%ld",self.btn4.tag - 100]];
    }if (self.btn5.selected == YES) {
        [_btnArray addObject:[NSString stringWithFormat:@"%ld",self.btn5.tag - 100]];
    }
   NSLog(@"%@",_btnArray);
    if (self.btn0.selected == NO && self.btn1.selected == NO && self.btn2.selected == NO && self.btn3.selected == NO && self.btn4.selected == NO && self.btn5.selected == NO) {
        [SVProgressHUD showErrorWithStatus:@"请至少选择一项"];
    }else
    {
      report_type = [_btnArray componentsJoinedByString:@""];
        NSUserDefaults * db = [NSUserDefaults standardUserDefaults];
        [db removeObjectForKey:@"contenView"];
        [db removeObjectForKey:@"num"];
      if (_tid) {
        [[TTIHttpClient shareInstance ] reportPostRequestWithTid:_tid withreport_note:report_note withReport_type:report_type withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
            [SVProgressHUD showSuccessWithStatus:@"已成功举报"];
            [self cancleBtn];
        } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
            [SVProgressHUD showErrorWithStatus:response.error_desc];
            
        }];

    } else{
        [[TTIHttpClient shareInstance] reportPostRequestWithuserid:_user_id withreport_note:report_note withReport_type:report_type withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
            [SVProgressHUD showSuccessWithStatus:@"已成功举报"];
            [self cancleBtn];
        } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
            [SVProgressHUD showErrorWithStatus:response.error_desc];
        }];
    }
}
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)btn1:(UIButton *)sender {
    if (self.btn0.selected == NO) {
        self.btn0.selected = YES;
    }else{
        self.btn0.selected = NO;
    }
    
}
- (IBAction)btn2:(UIButton *)sender {
    if (self.btn1.selected == NO) {
        self.btn1.selected = YES;
    }else{
        self.btn1.selected = NO;
    }

}
- (IBAction)btn3:(UIButton *)sender {
    if (self.btn2.selected == NO) {
        self.btn2.selected = YES;
    }else{
        self.btn2.selected = NO;
    }

}
- (IBAction)btn4:(UIButton *)sender {
    if (self.btn3.selected == NO) {
        self.btn3.selected = YES;
    }else{
        self.btn3.selected = NO;
    }

}
- (IBAction)btn5:(UIButton *)sender {
    if (self.btn4.selected == NO) {
        self.btn4.selected = YES;
    }else{
        self.btn4.selected = NO;
    }

}
- (IBAction)btn6:(UIButton *)sender {
    if (self.btn5.selected == NO) {
        self.btn5.selected = YES;
    }else{
        self.btn5.selected = NO;
    }

}
- (IBAction)selectBtn:(UIButton *)sender {
    
    if (sender.selected ==  NO) {
         sender.selected = YES;
    }else{
        sender.selected = NO;
    
    }

}
- (IBAction)BCBtn:(UIButton *)sender {
    BuChongViewController * BCVC = [[UIStoryboard storyboardWithName:@"my" bundle:nil] instantiateViewControllerWithIdentifier:@"BuChong"];
    BCVC.contentView.text = self.buLabel.text;
    BCVC.MyBlock = ^ (NSString * string)
    {
        NSString * str;
        if (string.length < 3 && string.length > 1) {
            str = [string substringToIndex:2];
        }else if (string.length < 2 && string.length > 0 ) {
            str = [string substringToIndex:1];
        }else if (string.length == 0)
        {
            str = @"可选填";
        }else{
            str = [string substringToIndex:3];
        }
        self.buLabel.text = str;
        

    };
    [self.navigationController pushViewController:BCVC animated:YES];
}
@end
