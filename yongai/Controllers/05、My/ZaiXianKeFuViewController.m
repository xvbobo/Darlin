//
//  ZaiXianKeFuViewController.m
//  com.threeti
//
//  Created by alan on 15/10/8.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "ZaiXianKeFuViewController.h"
//#import "leftView.h"
//#import "RightView.h"
#import "KeFuCell.h"
#import "TTIFont.h"
#import "ShangPinConnectView.h"
#import "MCProductDetailViewController.h"
#import "DXFaceView.h"
@interface ZaiXianKeFuViewController ()<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,KeFuCellDelegate,DXFaceDelegate,UIAlertViewDelegate>{
    UIButton * sendBtn;
    UITextView *chatTextView;
    UIView * bottomView;
    int textViewW;
    UITableView * myTableView;
    NSMutableArray *messageList;
    UIImageView * imageView;
    NSString * linenum;
    NSString * insertLineNum;//插入的linenum
    NSString * insertTime;//插入的时间
    NSTimer *timer;//计时器
    ShangPinConnectView * shangPinView;
    BOOL send;
    FCXRefreshFooterView * FooterView;
    FCXRefreshHeaderView * HeaderView;
    int page;
    UIImageView * juhauView;
    UIActivityIndicatorView *flower;//菊花视图
    UILabel * jiaZai;
    BOOL hidden;
    BOOL LianJie;
    BOOL isFirst;
    BOOL Up;
    BOOL bShowFace;//是否显示表情
    CGFloat TableViewHeight;
    CGFloat _oldOffset;
    NSMutableArray * cachArray;
    NSUserDefaults * UD;
    NSMutableArray * NewCacharray;
    BOOL isCach;//是否使用缓存
    BOOL isuseCach;
    NSThread* myThread;
    BOOL isFirstOnTime;
    NSArray * dataSoure;
     BOOL reload;//刷新最后一行
    BOOL isFirstSend;
}
@property(nonatomic ,strong)  DXFaceView *faceView;  // 笑脸;
@end

@implementation ZaiXianKeFuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    cachArray = [[NSMutableArray alloc] init];
    jiaZai = [[UILabel alloc] initWithFrame:CGRectMake((UIScreenWidth - 100)/2, 20, 200, 20)];
    jiaZai.font = [UIFont systemFontOfSize:15];
    jiaZai.textColor = TEXT;
    LianJie = NO;
    isFirst = YES;
    isCach = NO;
    reload = NO;
    isFirstSend = YES;
    _oldOffset = 0;
    isuseCach = YES;
    isFirstOnTime = YES;
    TableViewHeight = UIScreenHeight - 125;
    jiaZai.text = @"正在用力加载，请骚等~";
    UD  = [NSUserDefaults standardUserDefaults];
    //表情
    self.faceView = [[DXFaceView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
    [self.faceView setDelegate:self];
    self.faceView.backgroundColor = [UIColor lightGrayColor];
    self.faceView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:self.faceView];
    flower = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
              UIActivityIndicatorViewStyleGray];
    flower.frame = CGRectMake((UIScreenWidth- 40)/2,10, 40,40);
    send = NO;
    page = 0;
    NSString * string;
    if ([self.keFuZaiXian isEqualToString:@"获取成功"]) {
        string = @"客服悠悠(在线)";
    }else if ([self.keFuZaiXian isEqualToString:@"客服下线"]){
        string = @"客服悠悠(下线)";
    }else{
        string = @"客服悠悠(离开)";
    }
     NAV_INIT(self,string, @"common_nav_back_icon", @selector(back), nil, nil);
    self.view.backgroundColor = BJCLOLR;
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, UIScreenHeight- 125, UIScreenWidth, 60)];
    bottomView.userInteractionEnabled = YES;
    bottomView.backgroundColor = BJCLOLR;
    
    
    if (self.goodsInfo != nil) {
        shangPinView = [[ShangPinConnectView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 125)];
        [shangPinView UpdateGoodsMessage:self.goodsInfo];
        [shangPinView.lianJieBtn addTarget:self action:@selector(lianJieBtnAction) forControlEvents:UIControlEventTouchUpInside];
         shangPinView.backgroundColor = [UIColor whiteColor];
        
    }else{
//        shangPinView.hidden = YES;
    }
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, UIScreenWidth,TableViewHeight) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.backgroundColor = BJCLOLR;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.tableHeaderView = [[UIImageView alloc] init];
    myTableView.tableHeaderView.backgroundColor = beijing;
    messageList = [[NSMutableArray alloc] init];
    [self.view addSubview:myTableView];
    [self.view addSubview:bottomView];
    [self createBottomView];
    linenum = @"0";
    [self registerForKeyboardNotifications];
    [self getDataSoureWithPage];//获取数据源
    
    // Do any additional setup after loading the view.


}
- (void)getDataSoureWithPage
{
    NewCacharray = [[NSMutableArray alloc] init];
     dataSoure = [UD objectForKey:g_userInfo.uid];
    if (dataSoure.count != 0) {
        isCach = YES;
        if (dataSoure.count > 20) {
            NSArray * array = [dataSoure subarrayWithRange:NSMakeRange(dataSoure.count - 20, 20)];
            NSArray * array1 = [dataSoure subarrayWithRange:NSMakeRange(0, dataSoure.count - 20)];
            [NewCacharray addObjectsFromArray:array1];
            [messageList addObjectsFromArray:array];
        }else{
            [messageList addObjectsFromArray:dataSoure];
        }
        linenum = [NSString stringWithFormat:@"%@",[[messageList lastObject] objectForKey:@"linenum"]];
        NSLog(@"dasoure = %@",dataSoure);
        if (self.goodsInfo != nil && send == NO) {
            NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1234",@"shuzi", nil];
            [messageList addObject:dict];
        }else{
            NSLog(@"没有商品链接");
        }
        [myTableView reloadData];
        [self  scrollTo_tableView];
//        [self createRefreshOnTime];
    }else{
         isuseCach = NO;
        isCach = NO;
        if (messageList.count == 0) {
            if (self.goodsInfo != nil) {
                NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1234",@"shuzi", nil];
                [messageList addObject:dict];
                [myTableView reloadData];
//                [self createRefreshOnTime];
            }else{
                NSLog(@"没有商品链接");
            }
           [self refreshDadaWith:[NSString stringWithFormat:@"%d",page]];
        }else{
            NSLog(@"%@",messageList);
        }
       
       
    }
    
    [self createRefreshOnTime];
    
}
#pragma -- mark 下拉加载数据
- (void)loadMoreData
{
    isCach = YES;
    NSLog(@"%@",NewCacharray);
    page ++;
    if (NewCacharray.count >19) {
        NSArray * muArray = [NewCacharray subarrayWithRange:NSMakeRange(NewCacharray.count - 20, 20)];
        NSMutableArray * muArray1 = [[NSMutableArray alloc] initWithArray:muArray];
        [muArray1 addObjectsFromArray:messageList];
        messageList = muArray1;
        [myTableView reloadData];
        [NewCacharray removeObjectsInArray:muArray];
        [flower stopAnimating];
        [self createLocation];//定位滚动
        
        [UIView animateWithDuration:3 animations:^{
            juhauView.alpha = 0;
        }];
    }else{
        NSString * str = [NSString stringWithFormat:@"%d",page];
        [self refreshDadaWith:str];
    }
    
   
   
}
- (void)createLocation2:(NSArray *) array
{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:messageList.count - 20*page inSection:0];
    [myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop  animated:NO];
}
- (void)createLocation
{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:20 inSection:0];
    [myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop  animated:NO];
}
- (void)refreshDadaWith:(NSString *)pg
{
    [flower startAnimating];
       [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [[TTIHttpClient shareInstance] shuxinLiaotian:g_userInfo.uid withlinenum:linenum withPage:pg withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
            NSMutableArray * array = [[NSMutableArray alloc] initWithArray:[response.result objectForKey:@"result"]];
            if (array.count > 0) {
                if (isCach == YES) {
                    [array addObjectsFromArray:messageList];
                    messageList = array;
                    [myTableView reloadData];
                    if (array.count > 19) {
                        [self createLocation];
                    }else{
                        [self createLocation2:array];
                    }
                    
                }else if(isCach == NO){

                }
                
            }else{
                if (array.count < 1) {
                    page -- ;
                    flower.hidden = YES;
                    return ;
    
                }else{

                }
               
            }
            [flower stopAnimating];
            
        } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
            NSLog(@"%@",response.error_desc);
            return ;
        }];
 }
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [chatTextView resignFirstResponder];
 }

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <5) {
        NSLog(@"到达顶部");
        [flower startAnimating];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 50) {
        [flower startAnimating];
//        [UIView animateWithDuration:3 animations:^{
            [self loadMoreData];
//        }];
        
    }
}

#pragma mark -- 即时刷新
- (void)createRefreshOnTime
{

    timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    //添加一个子线程
    myThread = [[NSThread alloc] initWithTarget:self
                                       selector:@selector(myThreadMainMethod)
                                         object:nil];
     [myThread start];

}
- (void)timerFired
{
    [self myThreadMainMethod];
}
- (void)myThreadMainMethod
{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    
    [[TTIHttpClient shareInstance] shuxinLiaotian:g_userInfo.uid withlinenum:linenum withPage:@"0" withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        NSMutableArray * array = [response.result objectForKey:@"result"];
        if (array != nil) {
            linenum = [NSString stringWithFormat:@"%@",[[array lastObject] objectForKey:@"linenum"]];
            NSString * lastNumbel = [NSString stringWithFormat:@"%@",[[messageList lastObject] objectForKey:@"linenum"]];
            if ([linenum isEqualToString:@"2"]) {
                isCach = YES;
            }
            for (NSDictionary * dict in array) {
                NSString * numeLine1 = [dict objectForKey:@"linenum"];
                for (int i = 0; i < messageList.count; i++) {
                    NSDictionary * dict2 = messageList[i];
                    NSString * numeLine2 = [dict2 objectForKey:@"linenum"];
                    NSString * time = [dict2 objectForKey:@"charu"];
                    if (numeLine1.intValue == numeLine2.intValue || [time isEqualToString:@"yes"] ) {
                        if (![[dict2 objectForKey:@"shuzi"] isEqualToString:@"1234"]) {
                            [messageList removeObjectAtIndex:i];
                        }else{
                            NSLog(@"1234");
                        }
                        
                    }else{
                        NSLog(@"%@",dict2);
                    }
                }
            }
            [messageList addObjectsFromArray:array];
            
            for (NSDictionary * dict in array) {
                if ([[dict objectForKey:@"ifself"]isEqualToString:@"0"]) {
                    [myTableView reloadData];
                    [self fasongXiaoXiXianshi];
                }else{
                   
                    if (isFirstSend == YES) {
                        [myTableView reloadData];
                         [self  scrollTo_tableView];
                        isFirstSend = NO;
                    }else{
                         NSLog(@"不滚动");
                    }
//
                  }
            }
           
            return ;

//            if ([linenum isEqualToString:insertLineNum]|| [linenum isEqualToString:lastNumbel]) {
//                //                [messageList removeLastObject];
//                [messageList addObjectsFromArray:array];
//                [myTableView reloadData];
//                [self  scrollTo_tableView];
//                return ;
//            }else{
//                int a = [[[messageList lastObject]objectForKey:@"linenum"] intValue];
//                int b = [[[array lastObject]objectForKey:@"linenum"] intValue];
//                if (a == b) {
//                    return;
//                }else{
//                    [messageList addObjectsFromArray:array];
//                    [myTableView reloadData];
//                    [self  scrollTo_tableView];
//                }
//
//                
//            }
            
        }else{
            NSLog(@"没有新消息");
            return;
            
        }
        if (dataSoure.count == 0) {
            if (isFirst == YES) {
                if (self.goodsInfo != nil && send == NO) {
                    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1234",@"shuzi", nil];
                    [messageList addObject:dict];
                    Up=  YES;
                    [myTableView reloadData];
                    [self  scrollTo_tableView];
                    
                }else{
                    NSLog(@"没有商品链接");
                }
                
                isFirst = NO;
            }else{
                NSLog(@"不是第一次进入");
            }

        }
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        return ;
    }];

}

- (void)scrollTo_tableView
{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:messageList.count-1 inSection:0];
    [myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom  animated:NO];
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (messageList.count < 20) {
        return 0;
    }else{
         return 40;
    }
   
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return flower;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return messageList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   //右边是用户，左边是客服
    NSDictionary * message = [messageList objectAtIndex:indexPath.row];
    if ([message objectForKey:@"shuzi"]) {
        NSString * cellStr = @"cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell addSubview:shangPinView];
        return cell;
    }else{

    
    static NSString * kefuCell = @"kefucell";
    KeFuCell * cell = [tableView dequeueReusableCellWithIdentifier:kefuCell];
    if (cell == nil) {
        cell = [[KeFuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kefuCell];
        
    }
    cell.backgroundColor = BJCLOLR;
    NSLog(@"%ld,%ld",messageList.count,indexPath.row);
            if (messageList.count - 1 == indexPath.row && send == YES) {
                NSLog(@"菊花");
                cell.shuaXin = YES;
                send = NO;
            }else{
                cell.shuaXin = NO;
            }
        cell.delegate = self;
//        if (reload == YES) {
            [cell cellWithMessage:message withIndex:[NSString stringWithFormat:@"%ld",indexPath.row] andTimeStr:insertTime];
//        }else{
//            [cell cellWithMessage:message withIndex:[NSString stringWithFormat:@"%ld",indexPath.row] andTimeStr:nil];
//        }
    
    return cell;
    }
}
- (void)goodsAction:(UIButton *)button
{
    MCProductDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"MCProductDetailViewController"];
    detailVC.gid = [NSString stringWithFormat:@"%ld",button.tag];
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    ZaiXianKeFuViewController * zaiXain;
    [timer setFireDate:[NSDate distantPast]];//开启计时器
    [super viewWillAppear:animated];
    [zaiXain viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    ZaiXianKeFuViewController * zaiXain;
    [super viewWillDisappear:animated];
    [zaiXain viewWillDisappear:animated];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * message = [messageList objectAtIndex:indexPath.row];
       NSString * time = [message objectForKey:@"time"];
    NSString * str = [message objectForKey:@"content"];
    if (![time rangeOfString:@"hidden"].location) {
        hidden = YES;
    }else{
        hidden = NO;
    }
    if ([[message objectForKey:@"shuzi"] isEqualToString:@"1234"]) {
        return 125;
    }
    if ([str  rangeOfString:@"price"].location != NSNotFound){
        if (hidden == YES) {
            return 100;
        }else{
          return 130;
        }
        
    }else{
//        NSLog(@"%f",);
        CGFloat screenH = self.view.frame.size.height;
        CGFloat height = [TTIFont calHeightWithText:str font:[UIFont systemFontOfSize:17] limitWidth:UIScreenWidth - 130];
        if (screenH > 480) {
            if (hidden == YES) {
                return height + 20;
            }else if (hidden == NO){
                return height + 50;
            }else{
                return height + 40;
            }

        }else{
            if (hidden == YES) {
                return height + 40;
            }else{
                return height + 60;
            }

        }
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [chatTextView resignFirstResponder];
}
- (void)back
{
   
    [self createRedPoint];//请求未读消
    [timer invalidate];//取消计时器
    [timer setFireDate:[NSDate distantFuture]];//关闭计时器
    [myThread cancel];
    NSLog(@"%@",messageList);
    for (int i = 0; i< messageList.count; i++) {
        NSDictionary * dict = [messageList objectAtIndex:i];
        NSString * time = [dict objectForKey:@"time"];
        if ([[dict objectForKey:@"shuzi"] isEqualToString:@"1234"]) {
            [messageList removeObjectAtIndex:i];
        }else if (time == nil){
            
            [messageList removeObjectAtIndex:i];
        }
    }
    //    if (isCach) {
    [UD setObject:messageList forKey:g_userInfo.uid];
    [UD synchronize];
    //    }

    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createRedPoint
{
    [[TTIHttpClient shareInstance] getUnReadMessageWithUserid:g_userInfo.uid withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
    }];
}
#pragma 输入框
- (void)createBottomView
{
    textViewW = UIScreenWidth - 40;//UItextView的宽度
    chatTextView = [[UITextView alloc ] initWithFrame:CGRectMake(20,15, textViewW,35)];
    chatTextView.translatesAutoresizingMaskIntoConstraints = NO;
    chatTextView.font = [UIFont systemFontOfSize:15];
    chatTextView.layer.masksToBounds = YES;
    chatTextView.layer.borderWidth = 1;
    chatTextView.layer.borderColor = LINE.CGColor;
    chatTextView.layer.cornerRadius = chatTextView.frame.size.height/2-5;
    chatTextView.inputAccessoryView = [[UIView alloc] init];
    chatTextView.enablesReturnKeyAutomatically = YES;
    chatTextView.keyboardType = UIKeyboardAppearanceDefault;
    chatTextView.returnKeyType = UIReturnKeySend;
    chatTextView.selectedRange = NSMakeRange(0, 0);
    chatTextView.delegate = self;
    UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 0.5)];
    line.backgroundColor= LINE;
    [bottomView addSubview:line];
    [bottomView addSubview:chatTextView];
}
- (void)faceClick
{
    NSLog(@"发送表情");
}
#pragma mark - KeyboardNotifications

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardwillChangeFrame:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark -- 弹出键盘
-(void)keyboardwillChangeFrame:(NSNotification *)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    int keyBoardHeight = kbSize.height;
    bottomView.frame = CGRectMake(0, UIScreenHeight-250-130, UIScreenWidth, 60);
    myTableView.frame = CGRectMake(0, 0, UIScreenWidth, TableViewHeight - keyBoardHeight);
    [self.view setNeedsUpdateConstraints];
    //
    [UIView animateWithDuration:1 animations:^{
       
        [self.view layoutIfNeeded];
        if (messageList.count != 0) {
            [self scrollTo_tableView];
        }
//        [self scrollTo_tableView];
    }];
    //
    
}
-(void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    
    bottomView.frame = CGRectMake(0, UIScreenHeight- 125, UIScreenWidth, 60);
    myTableView.frame = CGRectMake(0, 0, UIScreenWidth, TableViewHeight);
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.4 animations:^{
        
        [self.view layoutIfNeeded];
    }];
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    
    chatTextView.frame = CGRectMake (20 , 15 ,textViewW ,31+abs(30 - (int)chatTextView. contentSize.height));
     bottomView.frame = CGRectMake(0, UIScreenHeight-250-130-abs(30 - (int)chatTextView. contentSize.height)+4, UIScreenWidth,TableViewHeight+abs(30 - (int)chatTextView. contentSize.height));
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

        if ([text isEqualToString:@"\n"]) {
            isCach = YES;
            [self SendMessage];
             return NO;
        }
    return YES;
}
- (void)SendMessage
{
    
    if (LianJie == YES) {
        chatTextView.text = self.shangPinMessage;
    }
    if (chatTextView.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请入输入内容"];
        return;
    }else{
        send = YES;
        
        NSMutableDictionary * lastObj = [messageList lastObject];
        if ([lastObj objectForKey:@"shuzi"]&& messageList.count != 1) {
            lastObj = [messageList objectAtIndex:messageList.count-2];
        }
        NSString * str = [NSString stringWithFormat:@"%@",[lastObj objectForKey:@"linenum"]];
        if (str.intValue == 0) {
            insertLineNum = [NSString stringWithFormat:@"%d",str.intValue+2];
        }else{
            insertLineNum = [NSString stringWithFormat:@"%d",str.intValue+1];
        }
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@\n",chatTextView.text],@"content",@"1",@"ifself",insertLineNum,@"linenum",@"yes",@"charu", nil];
        [messageList addObject:dict];
        
        [myTableView reloadData];
        [self fasongXiaoXiXianshi];
        
        if (LianJie == NO) {
            chatTextView.frame = CGRectMake (20 , 15 ,textViewW ,35 );
            bottomView.frame = CGRectMake(0, UIScreenHeight-250-130, UIScreenWidth, 60);
        }
        LianJie = NO;
        
        //        }
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [[TTIHttpClient shareInstance] kefuChat:g_userInfo.uid withcontent:chatTextView.text withNick_name:g_userInfo.nickname withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
             NSString * timeStr = [NSString stringWithFormat:@"%@",response.error_desc];
            insertTime = timeStr;
            [SVProgressHUD dismiss];
        } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
            [messageList removeLastObject];
            [myTableView reloadData];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"发送失败，请检查网络状况"
                                                               delegate:self
                                                      cancelButtonTitle:@"知道了"
                                                      otherButtonTitles:nil, nil];
           
            [alertView show];
        }];
        chatTextView.text = @"";
    }
    
    
}
- (void)fasongXiaoXiXianshi
{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:messageList.count-1 inSection:0];
    [myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom  animated:YES];
}
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [chatTextView resignFirstResponder];
}

- (void)lianJieBtnAction
{
    if (self.goodsInfo != nil) {
        self.shangPinMessage = [NSString stringWithFormat:@"goods_id=%@;goods_name=%@;img_url=%@;price=%@;market_price=%@",self.goodsInfo.goods_id,self.goodsInfo.goods_name,self.goodsInfo.img_url,self.goodsInfo.price,self.goodsInfo.market_price];
        LianJie = YES;
        [self SendMessage];
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

@end
