//
//  ChatViewController.m
//  Yongai
//
//  Created by wangfang on 14/11/13.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "ChatViewController.h"
#import "MyMessageViewCell.h"
#import "RightChatViewCell.h"
#import "LeftChatViewCell.h"
#import "TTIFont.h"
#import "IQKeyboardManager.h"
#import "Masonry.h"
#import "MyInfoViewController.h"
#import "HisTopicViewController.h"
@interface ChatViewController ()<UITextFieldDelegate>
{
    int  g_page;
    NSMutableArray *messageList;
    BOOL _wasKeyboardManagerEnabled;
    BOOL ret;
    FCXRefreshHeaderView *headerView;
    FCXRefreshFooterView *footerView;
}
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ret = NO;
    NAV_INIT(self, self.message.nickname, @"common_nav_back_icon", @selector(backAction), nil, nil);
    messageList = [[NSMutableArray alloc] init];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.backgroundColor =BJCLOLR;
    self.view.backgroundColor = BJCLOLR;
//    //点击屏幕任意位置取消键盘
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressed)];
    [self.view addGestureRecognizer:tapGesture];
    tapGesture.cancelsTouchesInView = NO;
//
    g_page = 1;
    if (_message.message_id) {
      [self initTableDataWithPage:g_page];
    }
    // don't want to add automatic toolbar over keyboard
    self.textField.inputAccessoryView = [[UIView alloc] init];
    self.textField.enablesReturnKeyAutomatically = YES;
//    // 键盘通知
    [self registerForKeyboardNotifications];
    self.view.backgroundColor = BJCLOLR;
    self.footerView.backgroundColor = BJCLOLR;
//    [self addRefreshView];
}
- (void)addRefreshView {
    
    __weak __typeof(self)weakSelf = self;
    
    //下拉刷新
    headerView = [self.myTableView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
         [weakSelf loadMoreComments];
//        [weakSelf refreshComments];
    }];
    
    //上拉加载更多
    footerView = [self.myTableView addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
//                [weakSelf loadMoreComments];
    }];
    
    //自动刷新
    footerView.autoLoadMore = YES;
}
#pragma mark -- 监听滚动事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y ==-60 ||(scrollView.contentOffset.y>-70&& scrollView.contentOffset.y<0))
    {
        if (self.meStr == nil) {
             [self refreshComments];
        }
      
        
    }
    if (UIScreenHeight+scrollView.contentOffset.y > scrollView.contentSize.height)
    {
        if (self.meStr == nil) {
          [self loadMoreComments];
        }

        
        
    }
    
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
//    [[IQKeyboardManager sharedManager] setEnable:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
}

-(void)tapPressed
{
    [self.view endEditing:YES];
}

#pragma mark - KeyboardNotifications

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardwillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}



-(void)keyboardwillChangeFrame:(NSNotification *)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    int keyBoardHeight = kbSize.height;
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.myTableView.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-keyBoardHeight);
        
    }];
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
        ret = YES;
//        if (_message.message_id) {
//            [self scrollToBottom_tableView];
//        }
//
    }];
}

-(void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.myTableView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        
        //make.height.equalTo(@50);
    }];
    
    
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.4 animations:^{
        
        [self.view layoutIfNeeded];
    }];
}
// 我的消息内容
- (void)initTableDataWithPage:(int)page
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[TTIHttpClient shareInstance] messagecontentRequestWithMessageid:_message.message_id
                                                             withpage:[NSString stringWithFormat:@"%d",page]
                                                      withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
                                                          if(page == 1)
                                                          {
                                                              NSArray * array = response.responseModel;
                                                              if ([array count] != 0) {
                                                                  
                                                                  [messageList removeAllObjects];
                                                                  [messageList addObjectsFromArray: response.responseModel];
                                                                  
                                                                  [_myTableView reloadData];
                                                                  [self scrollToBottom_tableView];
                                                                                                                                }
                                                          }
                                                          else
                                                          {
                                                              NSArray * array = [[NSArray alloc] initWithArray:
                                                              response.responseModel];
                                                          if ([array count] == 0) {
                                                                  
                                                                  g_page--;
                                                              }
                                                              else
                                                              {
                                                                  messageList = [[array arrayByAddingObjectsFromArray:messageList]mutableCopy];                                                                  
                                                                  [_myTableView reloadData];
                                                              }
                                                              
                                                          }
                                                          [headerView endRefresh];
                                                          [footerView endRefresh];
                                                        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
        return;
    }];
    
}

- (void)backAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 点击用户头像， 查看对方用户的个人中心
- (void)headBtn:(id)sender {

    UIButton *button = (UIButton *)sender;
    MessageContentModel *model = [messageList objectAtIndex:button.tag];
    
    HisTopicViewController *otherVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HisTopicViewController"];
    otherVC.hidesBottomBarWhenPushed = YES;
    otherVC.userId = model.mesc_user;
    [self.navigationController pushViewController:otherVC animated:YES];
}

// 显示个人资料
-(void)UesrHeadClicked
{
    MyInfoViewController *infoVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"MyInfoViewController"];
    infoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:infoVC animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [messageList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageContentModel *model = [messageList objectAtIndex:indexPath.row];
    
    // 判断是否是当前用户发送的消息
    if ([model.mesc_user isEqualToString:g_userInfo.uid]) {
        
        RightChatViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RightChatViewCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = BJCLOLR;
        [cell updateCellWithMessage:model];
        
        [cell.headButton addTarget:self action:@selector(UesrHeadClicked) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    else
    {
        LeftChatViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftChatViewCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = BJCLOLR;
        
        [cell updateCellWithMessage:model];
        
        cell.headButton.tag = indexPath.row;
        [cell.headButton addTarget:self action:@selector(headBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageContentModel *model = [messageList objectAtIndex:indexPath.row];
    int h ;
    if ([model.mesc_display isEqualToString:@"1"]) {
        //没时间
        h= 0;
    }else{
        h = 22;
    }
    int height = 0;
    int with = UIScreenWidth - 55 - 60;
    height = [TTIFont calHeightWithText:model.mesc_content font:[UIFont systemFontOfSize:18] limitWidth:with] + 44 +17;
    if (model.mesc_content) {
        return height - h;
    }else
    {
        return 84;
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
     [textField resignFirstResponder];

}
#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"]) {
        ret  = YES;
        DLOG(@"--- 发送 ---");
//        [SVProgressHUD dismiss];
//        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [[TTIHttpClient shareInstance] messageSendRequestWithTo_user:_message.user_id
                                                        withtcontent:textField.text
                                                     withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
                                                         _message.message_id = [response.result objectForKey:@"message_id"];
                                                         [self initTableDataWithPage:1];
                                                          self.textField.text = @"";
                                                        
        } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
            
        }];
         textField.text = @"";
    }
   
    return YES;
}
- (void)refreshComments{
    
    g_page ++;
    [self initTableDataWithPage:g_page];
   
}

- (void)loadMoreComments{
    
    g_page = 1;
    [self initTableDataWithPage:g_page];
    
}

// 滑动到tableview底部
-(void)scrollToBottom_tableView
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[messageList count]-1 inSection:0];
    [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom  animated:ret];
}

@end
