//
//  PeepPasswordViewController.m
//  Yongai
//
//  Created by wangfang on 14/11/18.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "PeepPasswordViewController.h"
#import "ChangePeepPasswordViewController.h"
#import "JKLLockScreenPincodeView.h"
static const NSTimeInterval LSVShakeAnimationDuration = 0.5f;
@interface PeepPasswordViewController ()<UITextFieldDelegate, CHDigitInputDelegate,JKLLockScreenPincodeViewDelegate>
{
    BOOL changePasBool;// 判断当前是否是修改密码
    int changePasNum;// 修改密码次数
    NSString *changePasStr;// 存储修改密码时的临时密码
    NSMutableString *peepStr;// 数字密码
    UITextField *textF;
    JKLLockScreenPincodeView * view1;
    NSString * zhongjianMima;// 存储修改密码时的临时密码
    NSString * chushiMima;// 数字密码
    NSString * secondMima;
    NSString * gengGaiMiMa;
    BOOL isFirst;
    BOOL xin;
}
@property (strong, nonatomic) NSMutableArray *passowordArray;
@property (strong, nonatomic) UserInfo *info;
@end

@implementation PeepPasswordViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    NAV_INIT(self, @"防偷窥密码", @"common_nav_back_icon", @selector(backAction), nil, nil);
//    _info = [[UserInfo alloc] init];
    changePasBool = NO;
    xin = YES;
    self.image.backgroundColor = BJCLOLR;
    self.view.backgroundColor = beijing;
    self.button1.backgroundColor = beijing;
    self.button2.backgroundColor = beijing;
    [self.button1 addTarget:self action:@selector(sheZhiMiMa:) forControlEvents:UIControlEventTouchUpInside];
    [self.button2 addTarget:self action:@selector(gengGaiMiMa:) forControlEvents:UIControlEventTouchUpInside];
    [self.button1 setTitle:@"设置密码" forState:UIControlStateNormal];
    self.button2.titleLabel.font = [UIFont systemFontOfSize:17];
    self.button1.layer.masksToBounds = YES;
    self.button1.layer.cornerRadius = 5;
    self.button2.layer.masksToBounds = YES;
    self.button2.layer.cornerRadius = 5;
    self.button2.enabled = NO;
    self.button2.alpha = 0.5;
    isFirst = NO;
    self.view.backgroundColor = [UIColor grayColor];
    view1 = [[JKLLockScreenPincodeView alloc] init];
    CGFloat x = UIScreenWidth / 2 - 167 / 2;
    CGFloat y = 127;
    view1.frame = CGRectMake(x, y, 167, 47);
    view1.backgroundColor = [UIColor whiteColor];
    view1.delegate = self;
    textF = [[UITextField alloc] initWithFrame:view1.frame];
    textF.keyboardType  = UIKeyboardTypeNumberPad;
    textF.delegate  = self;
    [textF addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    [textF addTarget:self
                  action:@selector(textFieldDidEndEditing:)
        forControlEvents:UIControlEventEditingDidEnd];
    textF.hidden = YES;
    [self.view addSubview:textF];
    view1.hidden = YES;
    [self.view addSubview:view1];
    // Do any additional setup after loading the view, typically from a nib.
    [self refreshView];
}
- (void)refreshView {
    
//    self.titleLable.hidden = YES;
    
    _info = [[UserInfo alloc] init];
    
    if (!ICIsObjectEmpty([[LocalStoreManager shareInstance] getValueFromDefaultWithKey:DefaultKey_PeepPassword])) {
        
        _info = [[LocalStoreManager shareInstance] getValueFromDefaultWithKey:DefaultKey_PeepPassword];
    }
    
    // 判断当前是否设置偷窥密码
    if (ICIsStringEmpty(_info.pwd)) {
        
        // 无密码时左侧按钮文字
        [self.button1 setTitle:@"设置密码" forState:UIControlStateNormal];
        self.button2.enabled = NO;
        self.button2.alpha = 0.5;
    }
    else
    {
        // 判断当前是否打开防偷窥密码
        if ([_info.pwd isEqualToString:@"1"]) {
            
            [self.button1 setTitle:@"关闭密码" forState:UIControlStateNormal];
            self.button2.enabled = NO;
            self.button2.alpha = 0.5;
            isFirst = YES;
        }
        else{
           [self.button1 setTitle:@"开启密码" forState:UIControlStateNormal];
            self.button2.enabled = YES;
            self.button2.alpha = 1;
            isFirst = YES;
        }
        
        
//        self.button2.enabled = YES;
//        self.button2.alpha = 1.0;
    }
    
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)sheZhiMiMa:(UIButton *)shezhiBtn
{
    
    if ([shezhiBtn.titleLabel.text isEqualToString:@"设置密码"]) {
        if (_info.account) {
            [SVProgressHUD showErrorWithStatus:@"您已经设置过密码"];
            
            return;
        }else{
            textF.hidden = NO;
            view1.hidden = NO;
            
        }
    }else if ([shezhiBtn.titleLabel.text isEqualToString:@"开启密码"]){
        textF.hidden = NO;
        view1.hidden = NO;

    }else if ([shezhiBtn.titleLabel.text isEqualToString:@"关闭密码"]){
        textF.hidden = NO;
        view1.hidden = NO;
        
    }
   [textF becomeFirstResponder];
}
- (void)gengGaiMiMa:(UIButton*)gengGaiBtn
{
    changePasBool = YES;
    view1.hidden = NO;
//    self.button1.enabled = NO;
//    self.button1.alpha = 0.5;
    self.titleLable.text = @"请输入密码";
    zhongjianMima = @"";
    secondMima = @"";
    isFirst = NO;
    [textF becomeFirstResponder];
}
- (void)textFieldDidChange:(UITextField*)tf
{
    //    NSLog(@"%@",tf.text);
    //    [view1 appendingPincode:@"1"];
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (changePasBool == YES) {
        if ([gengGaiMiMa isEqualToString:zhongjianMima]) {
                    chushiMima = zhongjianMima;
                    
                    self.titleLable.text = @"";
                    [textF resignFirstResponder];
                    textF.hidden = YES;
                    view1.hidden = YES;
                _info.account = gengGaiMiMa;
            
            [[LocalStoreManager shareInstance] setValueInDefault:_info withKey:DefaultKey_PeepPassword];
                    zhongjianMima = @"";
                    [SVProgressHUD showSuccessWithStatus:@"密码更改成功"];
                    [textF resignFirstResponder];
            [self refreshView];
            [self backAction];
                    NSLog(@"初始密码 = %@",chushiMima);
                    NSLog(@"设置成功");
                    return;
                }else{
                    if (zhongjianMima!= nil) {
                        CAAnimation * shake = [self lsv_makeShakeAnimation];
                        [view1.layer addAnimation:shake forKey:@"shake"];
                        [view1 initPincode];
                        self.titleLable.text = @"请重新输入密码";
                        NSLog(@"设置失败");
                    }
                    
                }

    
    }else{
        if ([self.button1.titleLabel.text isEqualToString:@"设置密码"]) {
                if ([zhongjianMima isEqualToString:secondMima]) {
                    chushiMima = zhongjianMima;
                    UILabel * label = (UILabel*)[self.view viewWithTag:100];
                    label.text = chushiMima;
                    _info.account = chushiMima;
                    _info.pwd = @"1";
                    [[LocalStoreManager shareInstance] setValueInDefault:_info withKey:DefaultKey_PeepPassword];
                    self.titleLable.text = @"";
                    [textF resignFirstResponder];
                    textF.hidden = YES;
                    view1.hidden = YES;
                    [self.button1 setTitle:@"开启密码" forState:UIControlStateNormal];
                    zhongjianMima = @"";
                    [self refreshView];
                    [self backAction];
                    [SVProgressHUD showSuccessWithStatus:@"密码设置成功"];
                    [textF resignFirstResponder];
                   
                    NSLog(@"初始密码 = %@",chushiMima);
                    NSLog(@"设置成功");
                    return;
                }else{
                    if (zhongjianMima!= nil) {
                        CAAnimation * shake = [self lsv_makeShakeAnimation];
                        [view1.layer addAnimation:shake forKey:@"shake"];
                        [view1 initPincode];
                        self.titleLable.text = @"请重新输入密码";
                        NSLog(@"设置失败");
                    }
                    
                }
        }else if ([self.button1.titleLabel.text isEqualToString:@"开启密码"]){
            textF.hidden = YES;
            view1.hidden = YES;
            if ([zhongjianMima isEqualToString:_info.account]) {
                self.button2.enabled = YES;
                self.button2.alpha = 1;
                [self.button1 setTitle:@"关闭密码" forState:UIControlStateNormal];
                _info.pwd = @"1";
                [[LocalStoreManager shareInstance] setValueInDefault:_info withKey:DefaultKey_PeepPassword];
                [self refreshView];
                [SVProgressHUD showSuccessWithStatus:@"密码开启成功"];
                [textF resignFirstResponder];
                return;
            }else{
                [SVProgressHUD showSuccessWithStatus:@"密码错误"];
                return;
            }
        }else if ([self.button1.titleLabel.text isEqualToString:@"关闭密码"]){
            textF.hidden = YES;
            view1.hidden = YES;
            if ([zhongjianMima isEqualToString:_info.account]) {
                self.button2.enabled = NO;
                self.button2.alpha = 0.5;
                [self.button1 setTitle:@"开启密码" forState:UIControlStateNormal];
                _info.pwd = @"0";
                [[LocalStoreManager shareInstance] setValueInDefault:_info withKey:DefaultKey_PeepPassword];
                [self refreshView];
                [SVProgressHUD showSuccessWithStatus:@"密码已关闭"];
                [textF resignFirstResponder];
                return;
            }else{
                [SVProgressHUD showSuccessWithStatus:@"密码错误"];
                return;
            }
        }

    }
    NSLog(@"zhongjianMima1 = %@",zhongjianMima);
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string length]!= 0) //点击了非删除键
    {
        [view1 appendingPincode:string];
        NSLog(@"非删除键");
    }
    else
    {
        [view1 removeLastPincode];
        NSLog(@"删除键");
    }
    return YES;
}
- (CAAnimation *)lsv_makeShakeAnimation {
    
    CAKeyframeAnimation * shake = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    [shake setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [shake setDuration:LSVShakeAnimationDuration];
    [shake setValues:@[ @(-20), @(20), @(-20), @(20), @(-10), @(10), @(-5), @(5), @(0) ]];
    
    return shake;
}
- (void)lockScreenPincodeView:(JKLLockScreenPincodeView *)lockScreenPincodeView pincode:(NSString *)pincode {
    if (pincode) {
        //        CAAnimation * shake = [self lsv_makeShakeAnimation];
        ////        [view1.layer addAnimation:shake forKey:@"shake"];
        [view1 initPincode];
        //
        if (changePasBool == YES&& isFirst == NO) {
            gengGaiMiMa = pincode;
            if ([gengGaiMiMa isEqualToString:_info.account]) {
                self.titleLable.text = @"请输入新密码";
                xin = NO;
            }else{
                if (xin == NO) {
                    secondMima = pincode;
                    self.titleLable.text = @"请确认密码";
                    isFirst = YES;
                    xin = YES;
                }else{
                    [SVProgressHUD showErrorWithStatus:@"密码错误"];
                    return;
                }
                
            }
        }else if (isFirst == YES) {
            zhongjianMima = pincode;
            
            NSLog(@"zhongjianMima = %@",zhongjianMima);
            [self textFieldDidEndEditing:textF];
            
        }
        else if (isFirst == NO) {
            secondMima = pincode;
                self.titleLable.text = @"请确认密码";
                NSLog(@"secondMima = %@",secondMima);
            isFirst = YES;
        }        
        
        textF.text = @"";
        
        //        [self lsv_unlockScreenSuccessful:pincode];
    }
    else {
        [self lsv_unlockScreenFailure];
    }
    
}
- (void)lsv_unlockScreenFailure {
    // make shake animation
    CAAnimation * shake = [self lsv_makeShakeAnimation];
    [view1.layer addAnimation:shake forKey:@"shake"];
    [view1 setEnabled:NO];
    //    [_subtitleLabel setText:NSLocalizedStringFromTable(@"Pincode Not Match Title", @"JKLockScreen", nil)];
    
    dispatch_time_t delayInSeconds = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(LSVShakeAnimationDuration * NSEC_PER_SEC));
    dispatch_after(delayInSeconds, dispatch_get_main_queue(), ^(void){
        [view1 setEnabled:YES];
        [view1 initPincode];
        
    });
    
}

- (void)viewWillAppear:(BOOL)animated {
    PeepPasswordViewController * PPV;
    [super viewWillAppear:animated];
    [PPV viewWillAppear:animated];
//    digitInput.placeHolderCharacter = @"";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

