//
//  MyRankViewController.m
//  Yongai
//
//  Created by myqu on 14/11/6.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MyRankViewController.h"
#import "GoldRuleViewController.h"
#import "MyGoldViewController.h"
#import "ChartRuleViewController.h"
#import "GTMBase64.h"
@interface MyRankViewController ()
{
    NSString * exprice;
    NSArray * expriceArray;
    NSMutableArray * mutableExpriceArray;
    NSMutableDictionary * mutaDic;
    NSString * guiDingEXP;
    int chaExp;
    NSString * dengji;
    NSString * jinBiString;
    NSString * content;
}

@end

@implementation MyRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BJCLOLR;
     NAV_INIT(self, @"我的等级", @"common_nav_back_icon", @selector(backAction), nil, nil);
    mutableExpriceArray  = [[NSMutableArray alloc] init];
    mutaDic = [[NSMutableDictionary alloc] init];
    [self createRequest];
    [self createJibi];
   
}

- (void)createRequest
{
    [[TTIHttpClient shareInstance] goldruleRequestWithtype:@"1"
                                           withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
                                               
                                               jinBiString = [response.result objectForKey:@"rank_gold"];
                                               NSString * str = [response.result objectForKey:@"gold_rule"];
                                               NSLog(@"金币规则%@",str);
                                               [self createMyInfo];
                                               
                                           } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
                                               
                            
                                           }];



    
}
- (void)createMyInfo
{
        [[TTIHttpClient shareInstance] userInfoRequestWithsid:nil withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
            exprice = [response.result objectForKey:@"exp"];
            expriceArray = [response.result objectForKey:@"exp_rank"];
            for (NSDictionary * dict in expriceArray) {
                 NSString * str = [self base64Decode:dict[@"descript"]];
                NSString * string = [self base64Decode:dict[@"name"]];
                NSDictionary * dict1 = [[NSDictionary alloc] initWithObjectsAndKeys:str,@"descript",dict[@"exp"],@"exp",dict[@"id"],@"id",string,@"name", nil];
                [mutableExpriceArray addObject:dict1];
            }
             [self createInterFace];
        } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
            
        }];
}
- (void)createJibi
{
    [[TTIHttpClient shareInstance] goldruleRequestWithtype:@"1"
                                           withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
                                               
                                               content = [response.result objectForKey:@"gold_rule"];
                                           } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
                                               
                                               
                                           }];

}
- (NSString *)base64Decode:(NSString *)base64String
{
    if(base64String == nil)
        return nil;
    
    NSData *decodedData = [GTMBase64 decodeData:[base64String dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    return decodedString;
}
- (void)createInterFace
{
    NSLog(@"%@",jinBiString);
    NSString * xianyouJinbi = g_userInfo.pay_points;
    int exprce1 = exprice.intValue;
    int a = jinBiString.intValue;
    int b = g_userInfo.pay_points.intValue;
    for (int i= 0;i< mutableExpriceArray.count;i++) {
        NSDictionary * dict = mutableExpriceArray[i];
        NSString * descript = dict[@"descript"];
        NSString * exp = dict[@"exp"];
        NSString * idStr = dict[@"id"];
        NSString * name = dict[@"name"];
        if (i+1 < mutableExpriceArray.count) {
            NSDictionary * dict2 = mutableExpriceArray[i+1];
            NSString * exp2 = dict2[@"exp"];
            int exprce2 = exp2.intValue;
            int exprice0 = exp.intValue;
            if (exprce1 < 0) {
                guiDingEXP = [NSString stringWithFormat:@"%d",exprce2];
                dengji = idStr;
                chaExp =  -exprce1 +  exprce2;
            }
            else if (exprce1 >= exprice0 && exprce1 <= exprce2) {
                guiDingEXP = [NSString stringWithFormat:@"%d",exprce2];
                dengji = idStr;
                chaExp = exprce2 - exprce1;
            }
            
        }
        
        NSLog(@"%@",descript);
        NSLog(@"%@",name);
    }
    UIScrollView * mySv = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    mySv.backgroundColor = BJCLOLR;
    CGFloat headW = 95;
    UIImageView * headView = [[UIImageView alloc] initWithFrame:CGRectMake((UIScreenWidth-headW)/2, 20, headW, headW)];
    [headView setImageWithURL:[NSURL URLWithString:g_userInfo.user_photo] placeholderImage:[UIImage imageNamed:Default_UserHead]];
    headView.layer.masksToBounds = YES;
    headView.layer.cornerRadius = headW/2;
    [mySv addSubview:headView];
    UILabel * nameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 20)];
    nameLable.center = CGPointMake(headView.center.x, headView.center.y+headW/2+nameLable.frame.size.height);
    nameLable.text = g_userInfo.nickname;
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.font = font(19);
    nameLable.textColor = BLACKTEXT;
    [mySv addSubview:nameLable];
    UIImageView * grayView = [[UIImageView alloc] initWithFrame:CGRectMake(10, nameLable.frame.size.height+nameLable.frame.origin.y+15, UIScreenWidth-20, 140)];
    grayView.userInteractionEnabled =  YES;
    grayView.backgroundColor = RGBACOLOR(213,204,197, 1);
    grayView.layer.masksToBounds = YES;
    grayView.layer.cornerRadius =5;
    [mySv addSubview:grayView];
    CGFloat grayJianGe = 15;
    CGFloat labelWith = (grayView.frame.size.width-3*grayJianGe)/2;
    UIImageView * huang = [[UIImageView alloc] initWithFrame:CGRectMake(grayView.frame.size.width/2-grayView.frame.size.height-10,-30,grayView.frame.size.height-20,grayView.frame.size.height-20)];
    huang.image = [UIImage imageNamed:@"皇冠"];
    huang.hidden = YES;
    [grayView addSubview:huang];
    for (int i=0; i<6; i++) {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(grayJianGe+i/3*(labelWith+grayJianGe),grayJianGe+i%3*(20+grayJianGe), labelWith-10, 20)];
        imageView.backgroundColor = BJCLOLR;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 10;
        UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
        lable.text = @"金币等级";
        lable.tag = 100+i;
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = TEXTCOLOR;
        lable.font = [UIFont systemFontOfSize:13];
        lable.layer.masksToBounds = YES;
        lable.layer.cornerRadius = 10;
        UIImageView * image = [[UIImageView alloc]initWithFrame:lable.frame];
        if (![g_userInfo.user_rank isEqualToString:@"2"]) {
            if (i==0) {
             lable.text = @"金币等级：赤贫会员";
            }
            if (i==1) {
                lable.text = [NSString stringWithFormat:@"%@/%@",xianyouJinbi,jinBiString];
                CGFloat c  = lable.frame.size.width/a;
                image.frame = CGRectMake(0, 0, lable.frame.size.width-c*(a-b), lable.frame.size.height);
                image.backgroundColor = RGBACOLOR(255, 251, 131, 1);
            }
            if (i==2) {
                
                imageView.backgroundColor = [UIColor clearColor];
                lable.font = [UIFont systemFontOfSize:11];
                lable.textColor = BLACKTEXT;
                lable.text = [NSString stringWithFormat:@"距皇冠会员还差%d金币",a-b];
            }
        }else{
            huang.hidden = NO;
            if (i==1 ||i== 0) {
                lable.hidden = YES;
                imageView.hidden = YES;
            }
            if (i==2) {
                imageView.backgroundColor = [UIColor clearColor];
                lable.textColor = BLACKTEXT;
                huang.center = CGPointMake(lable.center.x+10,grayView.frame.size.height/2-30);
                lable.font = [UIFont systemFontOfSize:11];
                lable.text = @"您已经是皇冠会员啦~";
            }
        }
        
        if (i==3) {
            lable.text = [NSString stringWithFormat:@"经验等级：LV%@",dengji];
        }
        
        if (i==5) {
            imageView.backgroundColor = [UIColor clearColor];
            lable.textColor = BLACKTEXT;
            lable.font = [UIFont systemFontOfSize:11];
            lable.text = [NSString stringWithFormat:@"距LV%d还差%d经验",dengji.intValue+1,chaExp];
        }
        
        if (i==4) {
            image.backgroundColor = RGBACOLOR(194, 254, 129, 1);
            CGFloat number = lable.frame.size.width/guiDingEXP.intValue;
            image.frame = CGRectMake(0, 0, lable.frame.size.width-number*chaExp, lable.frame.size.height);
            lable.text = [NSString stringWithFormat:@"%@/%@",exprice,guiDingEXP];
        }
        [imageView addSubview:image];
        [image addSubview:lable];
        [grayView addSubview:imageView];
    }
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, grayView.frame.size.height -30,labelWith, 20);
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitle:@"金币等级说明" forState:UIControlStateNormal];
    [btn setTitleColor:beijing forState:UIControlStateNormal];
    UIEdgeInsets titleSet  = UIEdgeInsetsMake(0,-labelWith/2+30, 0,0);
    btn.titleEdgeInsets = titleSet;
    [btn setImage:[UIImage imageNamed:@"三角"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(jinbiXaingxin) forControlEvents:UIControlEventTouchUpInside];
    btn.imageEdgeInsets = UIEdgeInsetsMake(3, labelWith/2+45,3,10);

    [grayView addSubview:btn];
    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(10+labelWith+grayJianGe, grayView.frame.size.height -30,labelWith, 20);
//    btn1.backgroundColor = BJCLOLR;
    btn1.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn1 setTitle:@"经验等级说明" forState:UIControlStateNormal];
    [btn1 setTitleColor:beijing forState:UIControlStateNormal];
    btn1.titleEdgeInsets = UIEdgeInsetsMake(0, -labelWith/2+30, 0, 0);
    [btn1 setImage:[UIImage imageNamed:@"三角"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(jingyanXaingxin) forControlEvents:UIControlEventTouchUpInside];
    btn1.imageEdgeInsets = UIEdgeInsetsMake(3, labelWith/2+45,3,10);
    
    [grayView addSubview:btn1];
    UILabel * aiyaLable = [[UILabel alloc] initWithFrame:CGRectMake(0,UIScreenHeight/2+70, UIScreenWidth, 20)];
    aiyaLable.textColor = beijing;
    aiyaLable.textAlignment = NSTextAlignmentCenter;
    aiyaLable.text = @"哎呀，金币还不够，快去赚金币~";
    aiyaLable.font = [UIFont systemFontOfSize:16];
    [mySv addSubview:aiyaLable];
    UIImageView * myGold = [[UIImageView alloc] initWithFrame:CGRectMake((UIScreenWidth-150)/2,aiyaLable.frame.origin.y+aiyaLable.frame.size.height+10, 150, 35)];
    myGold.backgroundColor = beijing;
    myGold.userInteractionEnabled = YES;
    myGold.layer.masksToBounds = YES;
    myGold.layer.cornerRadius = myGold.frame.size.height/2;
    [mySv addSubview:myGold];
    UILabel * myGoldLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 35)];
    myGoldLabel.text = @"我的金币";
    myGoldLabel.textAlignment = NSTextAlignmentCenter;
    myGoldLabel.textColor = [UIColor whiteColor];
    myGoldLabel.font = font(21);
    [myGold addSubview:myGoldLabel];
    UIImageView * sanJiaoView = [[UIImageView alloc] initWithFrame:CGRectMake(115, 10, 15, 15)];
    sanJiaoView.image = [UIImage imageNamed:@"三角形"];
    [myGold addSubview:sanJiaoView];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = myGold.frame;
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [mySv addSubview:button];
    if (UIScreenWidth>320) {
        mySv.contentSize = CGSizeMake(0, UIScreenHeight+20);
    }else{
      mySv.contentSize = CGSizeMake(0, UIScreenHeight+50);
    }
    
    mySv.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mySv];
}
- (void)buttonAction
{
    MyGoldViewController *ruleVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"MyGoldViewController"];
    [self.navigationController pushViewController:ruleVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)jinbiXaingxin
{
    GoldRuleViewController *ruleVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"GoldRuleViewController"];
    ruleVC.type = ExplainType_GoldRule;
    ruleVC.content = content;
    [self.navigationController pushViewController:ruleVC animated:YES];
}
- (void)jingyanXaingxin{
    ChartRuleViewController *ruleVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"ChartRuleViewController"];
    ruleVC.titleStr = @"经验规则";
//    ruleVC.type = ExplainType_RankRule;
    [self.navigationController pushViewController:ruleVC animated:YES];
}
- (IBAction)howtoGetGoldBtnClick:(id)sender
{
    MyGoldViewController *ruleVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"MyGoldViewController"];
    [self.navigationController pushViewController:ruleVC animated:YES];
}

- (IBAction)rankExplainBtnClick:(id)sender
{
    GoldRuleViewController *ruleVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"GoldRuleViewController"];
    ruleVC.type = ExplainType_RankRule;
    [self.navigationController pushViewController:ruleVC animated:YES];
}
@end
