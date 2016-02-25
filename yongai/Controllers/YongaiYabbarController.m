//
//  YongaiYabbarController.m
//  Yongai
//
//  Created by Kevin Su on 14/11/19.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "YongaiYabbarController.h"
#import "MobClick.h"
@interface YongaiYabbarController ()<CHDigitInputDelegate>
{
    NSMutableString *peepStr;// 数字密码
}

@property (strong, nonatomic) NSMutableArray *passowordArray;

@end

@implementation YongaiYabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.selectedIndex = 2;
    self.tabBarController.tabBar.tintColor = beijing;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterStateChange) name:@"NSNotificationWillEnter" object:nil];
    _passowordArray = [NSMutableArray arrayWithObjects:@"1", @"2", @"3", @"4", nil];
    peepStr = [NSMutableString string];
    
    digitInput = [[CHDigitInput alloc] initWithNumberOfDigits:4];
    CGFloat x = UIScreenWidth / 2 - 167 / 2;
    CGFloat y = 215;
    digitInput.frame = CGRectMake(x, y, 167, 47);
    
    digitInput.delegate = self;
    digitInput.digitBackgroundImage = [UIImage imageNamed:@"PeepPasswordViewController_texifield"];
    digitInput.placeHolderCharacter = @"";
    digitInput.digitViewBackgroundColor = [UIColor clearColor];
    digitInput.digitViewHighlightedBackgroundColor = [UIColor clearColor];
    
    digitInput.digitViewTextColor = [UIColor blackColor];
    digitInput.digitViewHighlightedTextColor = [UIColor redColor];
    [digitInput redrawControl];
    
    [self.peepView addSubview:digitInput];
    [digitInput addTarget:self action:@selector(didEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSelectIndex:) name:Notify_UpdateSelectIndex object:nil];
    }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notify_UpdateSelectIndex object:nil];
}

-(void)updateSelectIndex:(NSNotification *)notify
{
    NSString *index = [notify object];
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
    self.tabBarController.selectedIndex = index.intValue;
}


- (void)enterStateChange {

    DLOG(@"NSNotificationWillEnter");
    
    //digitInput.
    [digitInput redrawControl];
    [self.view addSubview:self.peepView];
    [digitInput becomeFirstResponder];
    self.peepView.hidden = NO;
}

-(void)didEndEditing:(id)sender
{
    if (_passowordArray.count < 4) {
        
        [SVProgressHUD showErrorWithStatus:@"密码输入不完整！"];
        return;
    }
    
    [peepStr setString:@""];
    [self.passowordArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [peepStr appendString:obj];
    }];
    
    UserInfo *info = [[LocalStoreManager shareInstance] getValueFromDefaultWithKey:DefaultKey_PeepPassword];
    if ([info.account isEqualToString:peepStr]) {
        
        digitInput.placeHolderCharacter = @"";
        
        //[self.peepView removeFromSuperview];
        self.peepView.hidden = YES;
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"防偷窥数字密码错误！"];
        digitInput.placeHolderCharacter = @"";
    }
}

#pragma mark - CHDigitInputDelegate

- (void)valueChangeWithvalue:(NSString *)value withIndex:(NSInteger)index
{
    DLOG(@"%@ %ld", value, index);
    [self.passowordArray replaceObjectAtIndex:index withObject:value];
}

#pragma mark - getter

- (PeepView *)peepView {

    if (_peepView == nil) {
        
//        _peepView = [[[NSBundle mainBundle] loadNibNamed:@"PeepView" owner:self options:nil] lastObject];
        _peepView = [[PeepView alloc] init];
        _peepView.backgroundColor = BJCLOLR;
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 64)];
        image.backgroundColor = beijing;
        [_peepView addSubview:image];
        UIImageView * image1 = [[UIImageView alloc] initWithFrame:CGRectMake(40,64+70, UIScreenWidth-80, UIScreenHeight/4)];
        image1.backgroundColor = [UIColor whiteColor];
        UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, image1.frame.size.width-40, 20)];
        lable.text = @"请输入防偷窥密码";
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = BLACKTEXT;
        lable.font = [UIFont systemFontOfSize:18];
        [image1 addSubview:lable];
        UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(lable.frame.origin.x, lable.frame.origin.y+lable.frame.size.height+10, lable.frame.size.width, 0.5)];
        line.backgroundColor = LINE;
        [image1 addSubview:line];
        [_peepView addSubview:image];
        [_peepView addSubview:image1];
        _peepView.frame = self.view.bounds;
//        _peepView.frame = CGRectMake(0,64, UIScreenWidth, UIScreenHeight-64);
    }
    return _peepView;
}

@end
