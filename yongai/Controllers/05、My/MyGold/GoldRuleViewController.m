//
//  GoldRuleViewController.m
//  Yongai
//
//  Created by myqu on 14/11/6.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "GoldRuleViewController.h"

@interface GoldRuleViewController ()
{
    IBOutlet UITextView *contentTextView;
    GoldModel *goldInfo;
}
@end

@implementation GoldRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BJCLOLR;
    if(self.type == ExplainType_GoldRule)
        NAV_INIT(self, @"金币规则", @"common_nav_back_icon", @selector(backAction), nil, nil);
    else if(self.type == ExplainType_RankRule)
        NAV_INIT(self, @"等级说明", @"common_nav_back_icon", @selector(backAction), nil, nil);
    
     contentTextView.text = _content;
    contentTextView.textColor = BLACKTEXT;
    contentTextView.font = [UIFont systemFontOfSize:14.5];
    contentTextView.backgroundColor = BJCLOLR;
    
    if(self.type == ExplainType_RankRule)
        [self requestRankData];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)setContent:(NSString *)content
{
    _content = content;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/**
 *  请求等级说明信息
 */
-(void)requestRankData
{
    [[TTIHttpClient shareInstance] descriptionwithSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        _content = [response.result objectForKey:@"content"];
        contentTextView.text = _content;
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
    }];
}
@end
