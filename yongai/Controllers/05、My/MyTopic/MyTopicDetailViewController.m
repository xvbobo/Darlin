//
//  MyTopicDetailViewController.m
//  Yongai
//
//  Created by wangfang on 14/11/14.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "MyTopicDetailViewController.h"
#import "MyTopicDetailViewCell.h"
#import "JuBaoViewController.h"
#import "CommonHelper.h"
#import "DXFaceView.h"
#import "Masonry.h"
#import "DeletePictuerViewController.h"
#import "IQKeyboardManager.h"
#import "MyInfoViewController.h"
#import "LoginNavViewController.h"
#import "BuChongViewController.h"
#import "HisTopicViewController.h"
#import "QFControl.h"
#import "M80AttributedLabel.h"
#import "PostMenuDetailController.h"
#import "TTIFont.h"
#import "NSDate+Utils.h"
#import "MyTopicViewController.h"
#import "MyGoldViewController.h"
#import "DaShangViewController.h"

static NSString *TopicDetailViewCell = @"MyTopicDetailViewCell";

@interface MyTopicDetailViewController ()< UIActionSheetDelegate, UIImagePickerControllerDelegate, DXFaceDelegate, UINavigationControllerDelegate, MyTopicDetailTopViewDelegate, UIAlertViewDelegate,UITextViewDelegate,QFControlDelegate>
{
    UIView *_maskView;
    NSInteger _pressNum;
    BOOL bShowFace; // 是否显示笑脸的标示
    UIImagePickerController *imagePicker;
    BOOL bShowDeletePictuer;// 是否显示照片详情页面表示
    UIImage *pictureImage;// 保存拍照后的照片
    UIButton * huifuBtn;
    CGFloat cellHeight;
    PostListModel *postInfo; // 帖子信息
    NSMutableArray  *postArr; // 回复列表
    MyTopicDetailViewController * MTP;
    CGSize contentSize;
    
    NSInteger g_Page;
    NSString *searchOrder; //  默认为1  1全部:all   2只看楼主：myself   3最新回复：new 4只看图片：picture
    
    NSString  *replyTag; //选择当前回复的cell索引
    
    BOOL _wasKeyboardManagerEnabled;
    BbsModel * bbsInfo;
    MyTopicDetailViewCell  *g_DetailCell;
    int textViewW;
    UILabel * chatlabel;
    NSString * huiFu1;
    NSString * huiFu2;
//    TopicDetailCell  *g_DetailCell;
    UIView *qianDaoView; // 浮层视图
    UIImageView * qiandaoBj;//签到背景
    UILabel * qiandaoLB;
//    UIImageView * shengjiView;//升级背景
    NSString * shengJiStr;
    int countnumber;
    BOOL Al;
    NSString * sexName;
    NSString * sex;
    M80AttributedLabel * mLable;
    MyTopicDetailViewCell *cell;
    NSMutableArray * subDictArr;
    UIImageView * dashangView ;//打赏
    UIImageView * dashangImage;
    UIImageView * huifuImageView;
    UILabel * huifuLabelLouzhu;
    UIImageView * huiFuLine;
    UILabel * shijianLabel;
    NSMutableArray * dashangArr;
    UILabel * dashangLabel;
    UIButton * jubaoBtn;//举报
    BOOL dashangYOrN;
    UIImageView * line;
    CGFloat daShangViewHeight;
    FCXRefreshHeaderView *headerView;
    FCXRefreshFooterView *footerView;
    NSInteger  lastNum;
    BOOL xianshijuHua;
    UIImageView * juhauView;
    UIActivityIndicatorView *flower;//菊花视图
    UILabel * jiaZai;
    NSString * fromnotepage;
}
@property(nonatomic ,strong)  DXFaceView *faceView;  // 笑脸;

@end

@implementation MyTopicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    subDictArr = [[NSMutableArray alloc] init];
    jiaZai = [[UILabel alloc] initWithFrame:CGRectMake((UIScreenWidth - 100)/2, 20, 200, 20)];
    jiaZai.font = [UIFont systemFontOfSize:15];
    jiaZai.textColor = TEXT;
    jiaZai.text = @"正在用力加载，请骚等~";
    flower = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
              UIActivityIndicatorViewStyleGray];
    [flower startAnimating];
    juhauView = [[UIImageView alloc] initWithFrame:CGRectMake(0, UIScreenHeight - 170, UIScreenWidth, 60)];
    juhauView.backgroundColor = BJCLOLR;
    flower.frame = CGRectMake(jiaZai.frame.origin.x-50,10, 40,40);
    [juhauView addSubview:jiaZai];
    [juhauView addSubview:flower];
    [self.view insertSubview:juhauView aboveSubview:_myTableView];
   sexName = @"0";
    if ([g_userInfo.sex isEqualToString:@"0"]) {
        sex = @"2";
    }else{
        sex = g_userInfo.sex;
    }
    xianshijuHua = YES;
    mLable = [[M80AttributedLabel alloc] init];
    line = [[UIImageView alloc] init];
    [self createDaShang];
    dashangArr = [[NSMutableArray alloc] init];
    qianDaoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
//    dashangYOrN = YES;
    qianDaoView.alpha = 0;
    qianDaoView.backgroundColor = QDBJ;
    qiandaoBj = [[UIImageView alloc] initWithFrame:CGRectMake(20, (UIScreenHeight-UIScreenWidth-40)/2, UIScreenWidth-40, UIScreenWidth-40)];
    qiandaoBj.image = [UIImage imageNamed:@"圈贡献"];
    qiandaoLB = [[UILabel alloc] initWithFrame:CGRectMake(50, qiandaoBj.frame.size.height/4*3-30, qiandaoBj.frame.size.width-100, 30)];
    qiandaoLB.textColor = [UIColor whiteColor];
    qiandaoLB.font = [UIFont systemFontOfSize:17];
    qiandaoLB.textAlignment = NSTextAlignmentCenter;
    [qiandaoBj addSubview:qiandaoLB];
    textViewW = UIScreenWidth - (375-260);
    huiFu2 = @"";
    chatlabel = [[UILabel alloc] init];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    self.navigationController.navigationBar.barTintColor = beijing;
    huifuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    huifuBtn.backgroundColor = [UIColor redColor];
    g_DetailCell = [[[UINib nibWithNibName:@"MyTopicDetailViewCell" bundle:nil] instantiateWithOwner:[self class] options:nil] objectAtIndex:0];
    NAV_INIT(self, nil, @"common_nav_back_icon", @selector(backAction), nil, nil);
    _pressNum = 1;
//    _myTableViewH.constant = UIScreenHeight - 120;
    _myTableView.backgroundColor = BJCLOLR;
    _myTableView.contentSize = CGSizeMake(0, UIScreenHeight);
    self.view.backgroundColor = BJCLOLR;
    // 笑脸
    self.faceView = [[DXFaceView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
    [self.faceView setDelegate:self];
    self.faceView.backgroundColor = [UIColor lightGrayColor];
    self.faceView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:self.faceView];
    
    // 相机
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.myTableView.backgroundColor = [UIColor clearColor];
    
    // 接收删除图片通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteChoosePicture) name:@"DeletePictureNotification" object:nil];
    
    postArr = [[NSMutableArray alloc] init];
    self.chatTextView = [[UITextView alloc ] initWithFrame:CGRectMake(0, 0, textViewW,30)];
    self.chatTextView.translatesAutoresizingMaskIntoConstraints = NO;
    self.chatTextView.font = [UIFont systemFontOfSize:15];
    self.chatTextView.layer.masksToBounds = YES;
    self.chatTextView.layer.borderWidth = 1;
    self.chatTextView.layer.borderColor = LINE.CGColor;
    self.chatTextView.layer.cornerRadius = 10;
    self.chatTextView.inputAccessoryView = [[UIView alloc] init];
    self.chatTextView.enablesReturnKeyAutomatically = YES;
    self.chatTextView.keyboardType = UIKeyboardAppearanceDefault;
    self.chatTextView.returnKeyType = UIReturnKeySend;
    self.chatTextView.selectedRange = NSMakeRange(0, 0);
    self.chatTextView.delegate = self;
    
    [self.chatBootm addSubview:self.chatTextView];
    [self requestdaShang];
    contentSize.width = self.view.frame.size.width - 10*2;
    searchOrder = @"all";
     g_Page = 1;
    if (self.pageT) {
//        g_Page = 0;
        g_Page = self.pageT.integerValue;
        fromnotepage = @"1";
        countnumber = 0;
//        for (int i=0; i< self.pageT.intValue; i++) {
//            g_Page++;
            [self requestTableDataWithPage:g_Page];
//        }
    }else{
        fromnotepage = @"0";
        [self requestTableDataWithPage:g_Page];
    }
//    self.pageT = nil;
    
    /*
     all 全部
     new 最新
     myself 只看楼主
     picture 只看图片
     */
    
    [self createSletment];
    [self createRightBtn];
    
    
    // 键盘通知
    [self registerForKeyboardNotifications];
    
    //点击屏幕任意位置取消键盘
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressed)];
    [self.myTableView addGestureRecognizer:tapGesture];
    tapGesture.cancelsTouchesInView = NO;
    //创建刷新
    [self addRefreshView];
}
- (void)addRefreshView {
    
    __weak __typeof(self)weakSelf = self;
    
    //下拉刷新
    headerView = [self.myTableView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf refreshComments];
    }];
    
    //上拉加载更多
//    [self.myTableView.tableFooterView addSubview:footerView];
    
    if (self.number.intValue > 25) {
        footerView = [self.myTableView addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
            //        [weakSelf loadMoreComments];
        }];
        
        //自动刷新
        footerView.autoLoadMore = YES;
    }
    
}
#pragma mark -- 监听滚动事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    if (UIScreenHeight+scrollView.contentOffset.y > scrollView.contentSize.height-64)
    {
//        if (g_Page < 1) {
//            [footerView endRefresh];
//            return;
//        }

        [self loadMoreComments];
    
    }
    
    
    
}
- (void)requestdaShang
{
    [[TTIHttpClient shareInstance] bbsPostRequestWithTid:self.tid withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        dashangArr = [response.result objectForKey:@"result"];
        [self updatedaShang:dashangArr];
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
}
#pragma mark -- 创建打赏
- (void)createDaShang
{
   
    dashangView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 220)];
    line.backgroundColor = LINE;
    [dashangView addSubview:line];
    dashangView.backgroundColor = [UIColor whiteColor];
    dashangView.userInteractionEnabled = YES;
    UIButton * dashang = [UIButton buttonWithType:UIButtonTypeCustom];
    dashang.tag = 200;
    dashang.frame = CGRectMake((UIScreenWidth-65)/2,0, 65, 65);
    [dashang setImage:[UIImage imageNamed:@"打赏"] forState:UIControlStateNormal];
    [dashang setImage:[UIImage imageNamed:@"打赏成功"] forState:UIControlStateSelected];
    [dashang addTarget:self action:@selector(dashang:) forControlEvents:UIControlEventTouchUpInside];
    [dashangView addSubview:dashang];
    dashangImage = [QFControl createUIImageFrame:dashang.frame withname:@"打赏"];
    [dashangView addSubview:dashangImage];
    dashangLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,dashang.frame.origin.y+75, UIScreenWidth, 20)];
    dashangLabel.textAlignment = NSTextAlignmentCenter;
    
    dashangLabel.font = [UIFont systemFontOfSize:13];
    [dashangView addSubview:dashangLabel];
    CGFloat jiange = 10;
    CGFloat with = (UIScreenWidth - jiange*7-20)/8;
    for (int i =0; i< 16; i++) {
        UIImageView * buttonPeople = [[UIImageView alloc] init];
        buttonPeople.frame = CGRectMake(10+i%8*(with+jiange), dashangLabel.frame.origin.y+dashangLabel.frame.size.height+10+i/8*(with+jiange), with, with);
        buttonPeople.hidden = YES;
        buttonPeople.layer.masksToBounds = YES;
        buttonPeople.layer.cornerRadius = buttonPeople.frame.size.width/2;
        buttonPeople.tag = 100+i;
        [dashangView addSubview:buttonPeople];
    }
    shijianLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, dashangView.frame.size.height-30, 150, 20)];
//    shijianLabel.text = @"2015-08-27 13:49";
    shijianLabel.font = [UIFont systemFontOfSize:13];
    shijianLabel.textColor = TEXTCOLOR;
    [dashangView addSubview:shijianLabel];
    jubaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    jubaoBtn.frame = CGRectMake(UIScreenWidth - 75,shijianLabel.frame.origin.y,70,20);
    jubaoBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [jubaoBtn setTitle:@"举报" forState:UIControlStateNormal];
    [jubaoBtn setTitleColor:beijing forState:UIControlStateNormal];
    jubaoBtn.titleEdgeInsets = UIEdgeInsetsMake(0,-60, 0,0);
    [jubaoBtn addTarget:self action:@selector(jubaoAction) forControlEvents:UIControlEventTouchUpInside];
    [jubaoBtn setImage:[UIImage imageNamed:@"举报92"] forState:UIControlStateNormal];
    jubaoBtn.imageEdgeInsets = UIEdgeInsetsMake(2,19,2,35);
    [dashangView addSubview:jubaoBtn];

    huifuLabelLouzhu = [[UILabel alloc] initWithFrame:CGRectMake(10, 240, 200, 40)];
    huifuLabelLouzhu.textColor = BLACKTEXT;
     dashangView.hidden = YES;
}
- (void)jubaoAction
{
    if(g_LoginStatus == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"登录后才可举报帖子"];
        [self showLoginView];
        return;
    }
    JuBaoViewController * juBao = [[UIStoryboard storyboardWithName:@"my" bundle:nil]  instantiateViewControllerWithIdentifier:@"JuBao"];
    juBao.tid = _tid;
    [self.navigationController pushViewController:juBao animated:YES];
}
- (void)dashang:(UIButton*)btn
{
    if(g_LoginStatus == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"登录后才可打赏"];
        [self showLoginView];
        return;
    }
    if (g_userInfo.pay_points.intValue < 2) {
        CGRect frame = CGRectMake(40, (UIScreenHeight - 150)/2, UIScreenWidth - 80, 150);
        UIImageView * image = [[UIImageView alloc] initWithFrame:frame];
        image.layer.masksToBounds = YES;
        image.layer.cornerRadius = 5;
        image.userInteractionEnabled = YES;
        UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height/4, frame.size.width, frame.size.height/7)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = font(20);
        lable.text = @"您的金币不够哟~";
        lable.textColor = BLACKTEXT;
        [image addSubview:lable];
        CGFloat buttonW = (frame.size.width - 80)/2;
        for (int i=0; i< 2; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 3;
            button.frame = CGRectMake(30+i*(buttonW+20), lable.frame.origin.y+lable.frame.size.height+20,buttonW , frame.size.height/3-10);
            if (i==0) {
                [button setTitle:@"好吧" forState:UIControlStateNormal];
                button.backgroundColor = TEXT;
            }else{
                [button setTitle:@"去赚金币" forState:UIControlStateNormal];
                button.backgroundColor = beijing;
            }
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(dashangbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [image addSubview:button];
        }

        image.backgroundColor = [UIColor whiteColor];
        QFControl * qf = [[QFControl alloc] init];
        qf.delegate  = self;
        [UIView animateWithDuration:1.5 animations:^{
            qianDaoView.alpha = 1;
        }];
        [qianDaoView addSubview:image];
        [self.navigationController.view addSubview:qianDaoView];

       
    }else{
    [[TTIHttpClient shareInstance] bbsPostRequestWithTid:self.tid withFid:nil withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
        dashangImage.hidden = YES;
        btn.selected = YES;
        [self requestdaShang];
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
    }

}
#pragma mark -QFControl代理
- (void)dashangbuttonClick:(UIButton *)btn
{
    if ([btn.titleLabel.text isEqualToString:@"好吧"]) {
        qianDaoView.alpha = 0;
    }else{
        //去赚金币
        qianDaoView.alpha = 0;
        MyGoldViewController *goldVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyGoldViewController"];
        goldVC.hidesBottomBarWhenPushed = YES;
        goldVC.myTitle = @"我的金币";
        [self.navigationController pushViewController:goldVC animated:YES];
    }
}
#pragma mark -- 更新打赏
- (void)updatedaShang:(NSMutableArray *)array
{
     dashangView.hidden = NO;
    if (dashangArr.count < 7){
        dashangView.frame = CGRectMake(0, 0, UIScreenWidth, 170);
        huifuLabelLouzhu.frame = CGRectMake(10, 178, 200, 20);
//        daShangViewHeight = 170;
    }else{
       dashangView.frame = CGRectMake(0, 0, UIScreenWidth, 220);
        huifuLabelLouzhu.frame = CGRectMake(10, 228, 200, 20);
        daShangViewHeight = 240;
    }
    if (dashangArr.count == 0) {
        dashangLabel.text = @"赏是一种态度";
        dashangLabel.textColor = BLACKTEXT;
    }else{
     dashangLabel.text = [NSString stringWithFormat:@"%lu人打赏",(unsigned long)dashangArr.count];
        dashangLabel.textColor = beijing;
    }
     line.frame =CGRectMake(0, dashangView.frame.size.height, UIScreenWidth, 0.5);
    shijianLabel.frame = CGRectMake(10, dashangView.frame.size.height-25, 150, 20);
    jubaoBtn.frame = CGRectMake(UIScreenWidth - 75,shijianLabel.frame.origin.y,70,20);
    NSInteger arraycount;
    if (array.count < 16) {
        arraycount = array.count;
    }else{
        arraycount = 16;
    }
    if (array.count!=0) {
        for (int i = 0; i<arraycount; i++) {
            NSDictionary * dict = array[i];
            UIImageView * image = (UIImageView*)[dashangView viewWithTag:100+i];
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = [[dict objectForKey:@"user_id"]intValue];
            btn.frame = image.frame;

            if (i == 15) {
                image.backgroundColor = [UIColor whiteColor];
                image.layer.borderColor = [UIColor orangeColor].CGColor;
                image.layer.borderWidth = 1;
                UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, image.frame.size.width, image.frame.size.height)];
                lable.text = @"更多";
                lable.textAlignment = NSTextAlignmentCenter;
                if (UIScreenWidth > 320) {
                    lable.font = [UIFont systemFontOfSize:14];
                }else{
                    lable.font = [UIFont systemFontOfSize:12];
                }
                
                lable.textColor = [UIColor orangeColor];
                [image addSubview:lable];
                btn.tag = 15;
            }else{
            [image setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"user_photo"]] placeholderImage:[UIImage imageNamed:Default_UserHead]];
            }
            [btn addTarget:self action:@selector(buttonPeopleAction:) forControlEvents:UIControlEventTouchUpInside];
            [dashangView addSubview:btn];
            
            image.hidden = NO;

    }
    }
}
- (void)buttonPeopleAction:(UIButton *)peoplebtn
{
    
    if(!g_LoginStatus)
    {
        [self showLoginView];
        return;
    }
     NSString * user_id = [NSString stringWithFormat:@"%ld",(long)peoplebtn.tag];
    if (peoplebtn.tag == 15) {
        //收礼排行榜
        DaShangViewController * daShangSc = [[DaShangViewController alloc] init];
        daShangSc.tid = self.tid;
        daShangSc.array = dashangArr;
        [self.navigationController pushViewController:daShangSc animated:YES];
    }else if ([user_id isEqualToString:g_userInfo.uid]) {
        MyTopicViewController *topicVC = [[UIStoryboard storyboardWithName:@"my" bundle:nil] instantiateViewControllerWithIdentifier:@"MyTopicViewController"];
        topicVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:topicVC animated:YES];
    }
    else{
    HisTopicViewController *topicVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"HisTopicViewController"];
    topicVC.userId = user_id;
    [self.navigationController pushViewController:topicVC animated:YES];
    }
}
- (void)createRightBtn
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0,50, 30);
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitle:@"分享" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(shareBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}
- (void)createSletment
{
    UIFont * font = [UIFont systemFontOfSize:16];
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"全部",@"楼主",@"图片",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake(0.0, 0.0, 170, 30.0);
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor whiteColor];
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,  font,UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
    [segmentedControl setTitleTextAttributes:dic forState:UIControlStateNormal];
    [segmentedControl addTarget:self  action:@selector(indexDidChangeForSegmentedControl:)
               forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:segmentedControl];
    
    
    
}
- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *) segmentedControl
{
   
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
        {
            searchOrder = @"all";

        }
            break;
        case 1:
        {
            searchOrder = @"myself";

        }
            break;
        case 2:
        {
            searchOrder = @"picture";

        }
            break;
        default:
            break;
    }
    g_Page = 1;
    [self requestTableDataWithPage:g_Page];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    MyTopicDetailViewController * MyTopic;
//   [[NSNotificationCenter defaultCenter] postNotificationName:Notify_HideBottom object:nil];
    if (self.pageT == nil) {
        [self refreshComments];
        [self initTableDataWithPage:1];
    }
    
    [super viewWillAppear:animated];
    [MyTopic viewWillAppear:animated];
}
-(void)initTableDataWithPage:(NSInteger)page
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [[TTIHttpClient shareInstance] circleInfoRequestWithFid:_fid
                                              withOrderType:nil
                                                   withPage:[NSString stringWithFormat:@"%ld",(long)page]
                                                 withTag_id:nil
                                                withVersion:nil
                                            withSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
         if(page == 1)
         {
             bbsInfo = [response.responseModel objectForKey:@"info"];
             self.isJoic = bbsInfo.is_join;

         }
         
     } withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         
     }];
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
    if(_bShowTabBar)
        [[NSNotificationCenter defaultCenter] postNotificationName:Notify_ShowBottom object:nil];
    [[NSThread currentThread] cancel];
//    NSLog(@"%@",[NSThread currentThread]);
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
//
    [UIView animateWithDuration:0.4 animations:^{
        
        [self.view layoutIfNeeded];
    }];
//
  
}

-(void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.myTableView.mas_bottom);
            make.left.equalTo(self.view.mas_left).offset(0);
            make.right.equalTo(self.view.mas_right).offset(0);
            make.bottom.equalTo(self.view.mas_bottom).offset(0);
            
            //make.height.equalTo(@57);
        }];
  
    
    [self.view setNeedsUpdateConstraints];

    [UIView animateWithDuration:0.4 animations:^{
        
        [self.view layoutIfNeeded];
    }];
}

- (void)backAction {
    if ([_string isEqualToString:@"泡友圈"]) {
        _MyBlock(self.isJoic);
        [self.navigationController popViewControllerAnimated:YES];;
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
   
    
}

-(void)tapPressed
{
    bShowFace = YES;
    [self showSmileView:nil];
    [self.view endEditing:YES];
}

-(void)requestTableDataWithPage:(NSInteger)page
{
    __weak FCXRefreshHeaderView *weakHeaderView = headerView;
    __weak FCXRefreshFooterView *weakFooterView = footerView;
    //    [weakFooterView startRefresh];
    if (self.number.intValue < 26) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    }
    if (lastNum == self.number.intValue/25+1 || lastNum == self.number.intValue/25) {
        footerView.hidden = YES;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    }else {
//        juhauView.hidden = NO;
        footerView.hidden = NO;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    }
    
    [[TTIHttpClient shareInstance] bbsPostRequestWithTid:self.tid
                                                withPage:[NSString stringWithFormat:@"%ld", (long)page]
                                         withSearchOrder:searchOrder
                                                 withFid:self.fid
                                        withFromnotepage:fromnotepage
                                         withSucessBlock:^(TTIRequest *request, TTIResponse *response)
     {
        
         NSMutableArray *postList = [response.responseModel objectForKey:@"post_info"];
             juhauView.hidden = YES;
         self.quanString = [[response.result objectForKey:@"thread_info"]objectForKey:@"forum_name"];
         [postList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
          {
              PostDetailModel *model = (PostDetailModel *)obj;
              g_DetailCell.info = model;
              model.contentHeight = [g_DetailCell getCellHeightByInfo];
              NSLog(@"%@",model.contentHeight);
          }];
         
         if(page == 1)
         {
             postInfo = [response.responseModel objectForKey:@"thread_info"];
             shijianLabel.text = [NSDate dateFormTimestampStringByFormatter:@"yyyy-MM-dd HH:mm" timeStamp:postInfo.addtime];
             sexName = postInfo.sex_chose;
             [postArr removeAllObjects];
            postArr = postList;
         }
         else if(postList.count != 0)
         {
             NSRange range;
             range.location = 0;
             range.length = (g_Page-1)*25;
             if (postArr.count!=0&& postArr.count == range.length) {
                  postArr =[NSMutableArray arrayWithArray:[postArr subarrayWithRange:range]];
             }
             [postArr addObjectsFromArray:postList];
         }
         
         // 没有请求购数据时，下次仍然从当前页开始（－－因为请求时会 ＋＋）
         
         if ([fromnotepage isEqualToString:@"1"]) {
             postInfo = [response.responseModel objectForKey:@"thread_info"];
         }

         if(self.myTableView.tableHeaderView == nil)
         {
             UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.topView.frame.size.width, self.topView.frame.size.height)];
             [view addSubview:self.topView];
             self.myTableView.tableHeaderView = view;
         }
         if (postArr.count < 25) {
             lastNum = page ;
             footerView.hidden = YES;
         }else {
             
             footerView.hidden = NO;
         }
          [_myTableView reloadData];
         if ([fromnotepage isEqualToString:@"1"]) {
             fromnotepage = @"0";
             [self  scrollTo_tableView];
         }
         [weakHeaderView endRefresh];
         [weakFooterView endRefresh];
//         if (self.pageT == nil) {
//             if (postArr.count < 25) {
//                 lastNum = page ;
//                 footerView.hidden = YES;
//             }else {
//                 
//                 footerView.hidden = NO;
//             }
//              [_myTableView reloadData];
//             [weakHeaderView endRefresh];
//             [weakFooterView endRefresh];
//         }else{
//             if (page == self.pageT.integerValue) {
////                 footerView.hidden = YES;
//                 [_myTableView reloadData];
//                 [self  scrollTo_tableView];
//                 [weakHeaderView endRefresh];
//                 [weakFooterView endRefresh];
//             }else{
//                 g_Page++;
//                 [self requestTableDataWithPage:
//                  self.pageT.intValue - 1];
//             }
//             
 
//         }
         
     } withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
         [SVProgressHUD showErrorWithStatus:response.error_desc];
     }];
    
}
- (void)scrollTo_tableView
{
    if (self.dingwei) {
        int a = self.dingwei;
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:a inSection:0];
        if (indexPath != nil && a  < postArr.count) {
            [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle  animated:NO];
//            [_myTableView reloadData];
        }else{
            return;
        }
        
    }
   

   
}
- (void)shareBtn {
    
    UIImage *image = [UIImage imageNamed:@"share_Default"];
    [self shareUrlWithMsg:postInfo.message withTitle:postInfo.subject withImage:image];
}

// 生成分享连接
- (void)shareUrlWithMsg:(NSString *)msg withTitle:(NSString *)title withImage:(UIImage *)img {
    
    [[TTIHttpClient shareInstance] updateVersionRequestWithnow_version:[CommonHelper version]
                                                       withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
                                                           
                                                           if ([response.result isKindOfClass:[NSDictionary class]]) {
                                                               
                                                               NSString * url = [response.result objectForKey:@"url"];
                                                               
                                                               [CommonHelper shareSdkWithContent:msg
                                                                                       withTitle:title
                                                                                       withImage:img
                                                                                         withUrl:url];
                                                           }
                                                           
                                                       } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
                                                           
                                                       }];
}

- (void)deleteChoosePicture {
    
    bShowDeletePictuer = NO;
    pictureImage = nil;
    [self.pictureButton setBackgroundImage:[UIImage imageNamed:@"MyTopicDetail_picture"] forState:UIControlStateNormal];

}

- (IBAction)showSmileView:(id)sender {
    
    if(bShowFace == NO)
    {
        [self.chatTextView resignFirstResponder];
        
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.myTableView.mas_bottom);
            make.left.equalTo(self.view.mas_left).offset(0);
            make.right.equalTo(self.view.mas_right).offset(0);
            make.bottom.equalTo(self.view.mas_bottom).offset(-200);
        }];
        
        [self.view setNeedsUpdateConstraints];
        
        [UIView animateWithDuration:0.4 animations:^{
            [self.view layoutIfNeeded];
        }];
        
        bShowFace = YES;
        self.faceView.frame = CGRectMake(0, self.view.frame.size.height-200, self.view.frame.size.width, 200);
    }
    else
    {
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.myTableView.mas_bottom);
            make.left.equalTo(self.view.mas_left).offset(0);
            make.right.equalTo(self.view.mas_right).offset(0);
            make.bottom.equalTo(self.view.mas_bottom).offset(0);
        }];
        
        [self.view setNeedsUpdateConstraints];
        
        [UIView animateWithDuration:0.4 animations:^{
            [self.view layoutIfNeeded];
        }];
        
        bShowFace = NO;
        self.faceView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 0);
    }
    
}


#pragma mark --- DXFace   Delegate <FacialViewDelegate>
- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete
{
    NSString *chatText = self.chatTextView.text;
    
    if (!isDelete && str.length > 0) {
        self.chatTextView.text = [NSString stringWithFormat:@"%@%@",chatText,str];
    }
    else {
        if (chatText.length >= 2)
        {
            NSString *subStr = [chatText substringFromIndex:chatText.length-2];
            if ([(DXFaceView *)self.faceView stringIsFace:subStr]) {
                self.chatTextView.text = [chatText substringToIndex:chatText.length-2];
                
                return;
            }
        }
        
        if (chatText.length > 0) {
            self.chatTextView.text = [chatText substringToIndex:chatText.length-1];
        }
    }
    
}
- (void)sendFace
{
    NSRange range = NSRangeFromString(@"");
    [self textView:self.chatTextView shouldChangeTextInRange:range replacementText:@"\n"];
}

/**
 *  点击拍照按钮的事件
 *
 */
- (IBAction)showPictureView:(id)sender {
    if (![g_userInfo.rank_name isEqualToString:@"高级会员"]) {
        [SVProgressHUD showErrorWithStatus:@"只有高级会员才能使用"];
    }else{
        
    if (bShowDeletePictuer == NO) {
        
        DLOG(@"拍照");
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册中取", nil];
        [sheet showInView:self.view];
    }
    else// 照片详情
    {
        DeletePictuerViewController *pictureVC = [[UIStoryboard storyboardWithName:@"my" bundle:nil] instantiateViewControllerWithIdentifier:@"DeletePictuerViewController"];
        pictureVC.image = pictureImage;
        pictureVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pictureVC animated:YES];
    }
        
    }

}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: // 拍照
        {
            BOOL isCameraSupport = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
            if(isCameraSupport)
            {
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:NULL];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"不支持拍照"];
            }
        }
            break;
        case 1: // 从相册中取
        {
            BOOL isPhotosAlbumSupport = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            
            if(isPhotosAlbumSupport)
            {
                imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                [self presentViewController:imagePicker animated:YES completion:NULL];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"不支持相册读取"];
            }
        }
            break;
        case 2: //取消
        {
        }
            break;
        default:
            break;
    }
}
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    //指定用户选择的媒体类型
    if ([mediaType isEqualToString:UIImagePickerControllerMediaType ]) //kUTTypeMovie
    {
        
    }
    // 原始图片
    else if([mediaType isEqualToString:@"public.image"] && imagePicker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum)
    {
        //        UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
        [imagePicker dismissViewControllerAnimated:YES completion:nil];
    }
    
    // 当来数据来源是照相机
    else if([mediaType isEqualToString:@"public.image"] && imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
        
        //  如果是拍照的照片，则需要手动保存到本地，系统不会自动保存拍照成功后的照片
        UIImageWriteToSavedPhotosAlbum(orgImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
        [imagePicker dismissViewControllerAnimated:YES completion:nil];
    }
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImageOrientation imageOrientation = image.imageOrientation;
    if(imageOrientation != UIImageOrientationUp)
    {
        UIGraphicsBeginImageContext(image.size);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    CGSize  imgSize;
    imgSize.height = (image.size.height*self.view.frame.size.width )/ image.size.width;
    imgSize.width = self.view.frame.size.width;
    
    pictureImage = [self imageWithImageSimple:image scaledToSize:imgSize];
    
    
//    pictureImage = image;
    [self.pictureButton setBackgroundImage:image forState:UIControlStateNormal];
    
    bShowDeletePictuer = YES;
    
    // 设置因调用相册时的状态栏颜色改变
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark -- 压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

// 用户选择取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
    
    // 设置因调用相册时的状态栏颜色改变
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

// 保存照片成功后的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo{
    
    NSLog(@"saved..");
}

-(void)showCenterView
{
    if([postInfo.user_id isEqualToString:g_userInfo.uid])
    {
        MyInfoViewController *myInfoVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyInfoViewController"];
        myInfoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myInfoVC animated:YES];
    }
    else
    {
        if(g_LoginStatus == 0)
        {
            [SVProgressHUD showErrorWithStatus:@"登录后才可查看Ta的资料"];
            [self showLoginView];
            return;
        }
        else
        {
            if ([self.fid isEqualToString:@"32"]) {
                [SVProgressHUD showSuccessWithStatus:@"匿名区不开放此功能"];
                return;
            }
            HisTopicViewController *topicVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"HisTopicViewController"];
            topicVC.userId = postInfo.user_id;
            [self.navigationController pushViewController:topicVC animated:YES];
        }
    }
}

-(void)showCenterView:(id)sender
{
    if(g_LoginStatus == 0)
    {
        
        [SVProgressHUD showErrorWithStatus:@"登录后才可查看他人信息"];
        [self showLoginView];
        return;
    }

    UIButton *button = (UIButton *)sender;
    
    PostDetailModel *info = [postArr objectAtIndex:button.tag];
    
    if([info.user_id isEqualToString:g_userInfo.uid])
    {
        MyInfoViewController *myInfoVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyInfoViewController"];
        myInfoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myInfoVC animated:YES];
    }
    else
    {
        if ([self.fid isEqualToString:@"32"]) {
            [SVProgressHUD showSuccessWithStatus:@"匿名区不开放此功能"];
            return;
        }
        HisTopicViewController *topicVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"HisTopicViewController"];
        topicVC.userId = info.user_id;
        [self.navigationController pushViewController:topicVC animated:YES];
    }
}

-(void)showOtherCenterView:(id)sender
{
    if(g_LoginStatus == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"登录后才可查看他人信息"];
        [self showLoginView];
        return;
    }

    UIButton *button = (UIButton *)sender;
    
    PostDetailModel *info = [postArr objectAtIndex:button.tag];
    if([info.subPost.user_id isEqualToString:g_userInfo.uid])
    {
        MyInfoViewController *myInfoVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyInfoViewController"];
        myInfoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myInfoVC animated:YES];
    }
    else
    {
        if ([self.fid isEqualToString:@"32"]) {
            [SVProgressHUD showSuccessWithStatus:@"匿名区不开放此功能"];
            return;
        }
        HisTopicViewController *topicVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"HisTopicViewController"];
        topicVC.userId = info.subPost.user_id;
        [self.navigationController pushViewController:topicVC animated:YES];
    }
    
}

#pragma mark - UITableViewDataSource


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PostDetailModel *info = [postArr objectAtIndex:indexPath.row];
    CGFloat height = info.contentHeight.floatValue;
    return height;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return postArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    cell = [self getCellFromIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userHeadImgButton.tag = indexPath.row;
    cell.huiFuBtn.tag = indexPath.row;
//    cell.backgroundColor = beijing;
    //    cell.shaFaLabelDown.text = cell.shaFaLabelUp.text;
    [cell.huiFuBtn addTarget:self action:@selector(huiFuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.userHeadImgButton addTarget:self action:@selector(showCenterView:) forControlEvents:UIControlEventTouchUpInside];
    cell.replyHeadImgButton.tag = indexPath.section;
    [cell.replyHeadImgButton addTarget:self action:@selector(showOtherCenterView:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
//    }
}
#pragma mark -- 回复按钮
- (void)huiFuBtnClick:(UIButton*)btn
{

    huiFu2 = self.chatTextView.text;
    if(g_LoginStatus == 0)
    {
       
            [SVProgressHUD showErrorWithStatus:@"登录后才可发回复"];
            [self showLoginView];
        return;
    }
    
    PostDetailModel *info = [postArr objectAtIndex:btn.tag];
    replyTag = info.pid;
    if (huiFu1) {
        self.chatTextView.text = [self.chatTextView.text stringByReplacingOccurrencesOfString:huiFu1 withString:[NSString stringWithFormat:@"@%@:",info.nickname]];
        huiFu1 = [NSString stringWithFormat:@"@%@:",info.nickname];
    }else{
        huiFu1 = [NSString stringWithFormat:@"@%@:",info.nickname];
        self.chatTextView.text = [huiFu1 stringByAppendingString:huiFu2];
    }
   
    [self.chatTextView becomeFirstResponder];
    [_myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:btn.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
   
}
#pragma mark - UITableViewDelegate
// 把Cell复用逻辑写在一个方法里
- (MyTopicDetailViewCell*)getCellFromIndexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"MyTopicDetailViewCell";
    cell = [_myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[[UINib nibWithNibName:@"MyTopicDetailViewCell" bundle:nil] instantiateWithOwner:[self class] options:nil] objectAtIndex:0];
    }
    if (indexPath.row == 0) {
        
        cell.shaFaLabelUp.text = @"沙发";
    }else if (indexPath.row == 1){
        cell.shaFaLabelUp.text = @"板凳";
        
    }else if (indexPath.row == 2){
        cell.shaFaLabelUp.text = @"地板";
    }else{
        cell.shaFaLabelUp.text = [NSString stringWithFormat:@"%ld楼",indexPath.row];
    }
    if (indexPath.row == postArr.count-1) {
        cell.line2.layer.borderWidth = 0;
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 0.5)];
        image.backgroundColor = LINE;
        [cell.line2 addSubview:image];
    }

    // 这里把数据设置给Cell
    if (postArr.count != 0) {
        PostDetailModel *info = [postArr objectAtIndex:indexPath.row];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:cell.shaFaLabelUp.text, info.pid, nil];
        [subDictArr addObject:dict];
        cell.subDictArray = subDictArr;
        cell.user_id = self.userid;
        cell.info = info;
    }
    return cell;
}
#pragma mark - TopicDetailMenuDelegate
#pragma mark - getter

- (MyTopicDetailTopView *)topView {
   
    if (_topView == nil) {
        
        _topView = [[[NSBundle mainBundle] loadNibNamed:@"MyTopicDetailTopView" owner:self options:nil] lastObject];
        _topView.dashangView.backgroundColor = BJCLOLR;
        if (postArr.count != 0) {
            huifuLabelLouzhu.text = [NSString stringWithFormat:@"全部回帖（%@）",self.number];
            huifuLabelLouzhu.font = [UIFont systemFontOfSize:13];
        }
        [_topView.dashangView addSubview:dashangView];
        _topView.count = dashangArr.count;
        [_topView.dashangView addSubview:huifuLabelLouzhu];
        _topView.delegate = self;
        if (postInfo) {
            [_topView setPostInfo:postInfo];
        }
        
        [_topView.nameBtn addTarget:self action:@selector(nameBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _topView.tieziName.text = [NSString stringWithFormat:@"%@ >>",self.quanString];
        CGFloat tieZiW = [TTIFont calWidthWithText:_topView.tieziName.text font:[UIFont systemFontOfSize:13] limitWidth:21]+10;
        _topView.tieziName.textAlignment = NSTextAlignmentCenter;
        _topView.tieziName.layer.masksToBounds = YES;
        _topView.tieziName.layer.cornerRadius = 4;
        _topView.tiziNameW.constant = tieZiW;
        _topView.tieziName.font = [UIFont systemFontOfSize:13];
        _topView.tieziName.backgroundColor = RGBACOLOR(255, 168, 140, 1);
        _topView.tieziName.textColor = [UIColor whiteColor];
        self.userid = postInfo.user_id;
        CGFloat with = [TTIFont calWidthWithText:self.number font:[UIFont systemFontOfSize:18] limitWidth:25];
        _topView.rightDownViewW.constant = 20+with;
        UILabel * huiLable;
        if (huiLable == nil) {
            huiLable = [[UILabel alloc] initWithFrame:CGRectMake(20,0, with, 25)];
            huiLable.textColor = beijing;
            huiLable.text = self.number;
            huiLable.font = [UIFont systemFontOfSize:14];
        }

        if([postInfo.user_id isEqualToString:g_userInfo.uid])
        {
            huifuBtn.hidden = YES;
            _topView.sendMessageBtn.hidden = YES;
            _topView.reportStatusLabel.hidden = YES;
            _topView.reportBtn.hidden = YES;
        }
        CGFloat height1 = [TTIFont calHeightWithText:postInfo.subject font:font(18.5) limitWidth:UIScreenWidth-20];
        mLable.font = font(18.5);
        mLable.textColor = TEXTCOLOR;
        mLable.numberOfLines = 0;
        mLable.frame = CGRectMake(0, 0, UIScreenWidth-20,height1+40);
        NSString * subject =[ConvertToCommonEmoticonsHelper convertToSystemEmoticons:postInfo.subject];
        if ([sexName isEqualToString:@"1"]) {
            [mLable appendImage:[UIImage imageNamed:@"男性回复"] maxSize:CGSizeMake(70, 150)];
            [mLable appendText: subject];
        }else if ([sexName isEqualToString:@"2"]){
            [mLable appendImage:[UIImage imageNamed:@"女性回复"] maxSize:CGSizeMake(70, 150)];
            [mLable appendText: subject];
        }else{
            [mLable appendText: subject];
        }
        [_topView.titleLabel addSubview:mLable];
        //更新UIView的layout过程和Autolayout
        [_topView setNeedsUpdateConstraints];
        [_topView updateConstraintsIfNeeded];
        [_topView setNeedsLayout];
        [_topView layoutIfNeeded];
        
        CGFloat height = [_topView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        _topView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
        [_topView.headImgButton addTarget:self action:@selector(showCenterView) forControlEvents:UIControlEventTouchUpInside];
        
//        DLOG(@"------SettopViewHeight: %f", height);
    }
    
    return _topView;
}
- (void)nameBtnAction
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"my" bundle:nil];
    PostMenuDetailController *PostMenuDetailVC = [board instantiateViewControllerWithIdentifier:@"PostMenuDetailController"];
    PostMenuDetailVC.fid = self.fid;
    [self.navigationController pushViewController:PostMenuDetailVC animated:YES];
}
#pragma mark - 更新 MyTopic TopView 高度

//-(void)updateTopViewHeight
//{
//    CGFloat height = [_topView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    _topView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
//    [_myTableView setTableHeaderView:_topView];
//}

#pragma mark - MyTopicDetailTopViewDelegate
#pragma mark - UITextFieldDelegate
-(void)showLoginView
{
    //判断用户是否登录
    LoginNavViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNavSB"];
    [self presentViewController:loginViewController animated:YES completion:nil];
    return;
}
-(void)joinBtnClick
{
    if(g_LoginStatus == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"登录后才可加入圈子"];
        [self showLoginView];
        return;
    }
    [[TTIHttpClient shareInstance] addCircleRequestWithFid:_fid
                                           withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
                                               
                                               self.isJoic = @"1";
                                            [SVProgressHUD showSuccessWithStatus:@"加入圈子成功"];
                                               
                                           } withFailedBlock:^(TTIRequest *request, TTIResponse *response)
     {
//         [SVProgressHUD showErrorWithStatus:response.error_desc];
     }];
//    [self initTableDataWithPage:1];
//    if([bbsInfo.is_join isEqualToString:@"1"])
//    {
//        [[TTIHttpClient shareInstance] cancleCircleRequestWithFid:_fid
//                                                  withSucessBlock:^(TTIRequest *request, TTIResponse *response)
//         {
//             self.isJoic = @"0";
//             
//         } withFailedBlock:^(TTIRequest *request, TTIResponse *response)
//         {
//             [SVProgressHUD showErrorWithStatus:response.error_desc];
//         }];
//    }
//    else
//    {
//        [[TTIHttpClient shareInstance] addCircleRequestWithFid:_fid
//                                               withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
//                                                   
//                                                   self.isJoic = @"1";
//                                                   [SVProgressHUD showSuccessWithStatus:@"加入圈子成功"];
//                                               } withFailedBlock:^(TTIRequest *request, TTIResponse *response)
//         {
//             [SVProgressHUD showErrorWithStatus:response.error_desc];
//         }];
//    }
}

#pragma mark --- 回复帖子
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //隐藏键盘
    [self.chatTextView becomeFirstResponder];
}
- (void)textViewDidChange:(UITextView *)textView
{
     self.chatTextView. frame = CGRectMake (0 , 0 ,textViewW , self.chatTextView. contentSize . height );
    self.bootmVIewH.constant = 57+self.chatTextView.contentSize.height - 30;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //    self.chatTextView.selectedRange = NSMakeRange(10,0);
    NSString * ver = VERSION;
    if ([text length]== 0) {
        //删除键
        if (textView.selectedRange.location -1 < huiFu1.length) {
            replyTag = nil;
            huiFu1 = nil;
        }
        NSLog(@"删除键");
    }
   
    if([text isEqualToString:@"\n"]) {
        if (huiFu1) {
            self.chatTextView.text = [self.chatTextView.text stringByReplacingOccurrencesOfString:huiFu1 withString:@""];
            huiFu1 = @"";
            huiFu2 = @"";
        }
        
        DLOG(@"--- 发送 ---");
        [self.chatTextView resignFirstResponder];
        bShowFace = YES;
        [self showSmileView:nil];
        
        if(g_LoginStatus == 0)
        {
            [SVProgressHUD showErrorWithStatus:@"登录后才可回复帖子"];
            [self showLoginView];
        }
        else if(self.chatTextView.text.length == 0 )
        {
            [SVProgressHUD showErrorWithStatus:@"请输入回复内容"];
        }else if(sexName){
            if([sexName isEqualToString:@"0"] || [sexName isEqualToString:sex]||[postInfo.user_id isEqualToString:g_userInfo.uid])
            {
                if ([self.isJoic isEqualToString:@"0"])// 判断是否加入当前圈子
                {
                    [self createAlertView];
                }else if (self.isJoic == nil)
                {
                    [self createAlertView];
                }
                else
                {
                    NSString *content = [ConvertToCommonEmoticonsHelper convertToCommonEmoticons:self.chatTextView.text];
                    [[TTIHttpClient shareInstance] addBbsRequestWithFid:self.fid
                                                                withTid:self.tid
                                                                withPup:replyTag
                                                            withSubject:nil
                                                            withMessage:content
                                                            withPhotos0:pictureImage
                                                            withPhotos1:nil
                                                            withPhotos2:nil
                                                            withPhotos3:nil
                                                            withPhotos4:nil
                                                            withPhotos5:nil
                                                            withPhotos6:nil
                                                            withPhotos7:nil
                                                            withTag_ids:nil
                                                            withVersion:ver
                                                         withSex_Choose:nil
                                                        withSucessBlock:^(TTIRequest *request, TTIResponse *response)
                     {
                         replyTag = nil;
                        NSString * str = response.error_desc;
                         NSRange range = [str rangeOfString:@"LV"];
                         if (range.length == 2) {
                             //可以升级
                             NSArray * arrar = [str componentsSeparatedByString:@"LV"];
                             NSString * shengJiStr = [NSString stringWithFormat:@"恭喜您，升为LV%@",arrar[0]];
                             NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc ] initWithString:shengJiStr];
                             NSRange range1 = [shengJiStr rangeOfString:[NSString stringWithFormat:@"LV%@",arrar[0]]];
                             NSRange redRange = NSMakeRange(range1.location, range1.length);
                             [string1 addAttribute:NSForegroundColorAttributeName value:beijing range:redRange];
                             UILabel * lable = [[UILabel alloc] init];
                             [lable setAttributedText:string1];
                             UIImageView *shengjiView = [QFControl createUIImageFrame:CGRectMake(30, (UIScreenHeight-UIScreenWidth+100)/2, UIScreenWidth-60, UIScreenHeight/3) imageName:@"升级" withStr1:string1 withStr: @"您可到个人中心“我的等级”页面查看详情" withStr3:@"么么哒~"];
                             [UIView animateWithDuration:1.5 animations:^{
                                 qianDaoView.alpha = 1;
                             }];
                             [qianDaoView addSubview:shengjiView];
                         }else if (![response.error_desc isEqualToString:@"分"]) {
                             qiandaoBj.image = [UIImage imageNamed:@"圈贡献"];
                             qiandaoLB.text = [NSString stringWithFormat:@"恭喜~月贡献加%@",response.error_desc];
                             [UIView animateWithDuration:1.5 animations:^{
                                 qianDaoView.alpha = 1;
                             }];
                             [qianDaoView addSubview:qiandaoBj];
                         }
                         
                         [self.navigationController.view addSubview:qianDaoView];
                         if (range.length == 2) {
                             [self performSelector:@selector(hideView) withObject:nil afterDelay:2.5];
                         }else{
                             [self performSelector:@selector(hideView) withObject:nil afterDelay:1.5];
                         }

                         [self deleteChoosePicture];
                         self.chatTextView.text = @"";
                         huiFu1 = nil;
                         huiFu2 = @"";
                         self.chatTextView.frame = CGRectMake(0, 0, textViewW, 30);
                         g_Page++;
                         [self refreshComments];
                     } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {

                     }];
                }
            }else{
                if ([sexName isEqualToString:@"1"]) {
                    [SVProgressHUD showErrorWithStatus:@"抱歉，该贴仅限男性回复哦~"];
                }else{
                     [SVProgressHUD showErrorWithStatus:@"抱歉，该贴仅限女性回复哦~"];
                }
                
            }
 
            }
            
        }
     
    return YES;

}

- (void)createAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"您需要先加入圈子哟~"
                                                       delegate:self
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:@"加入圈子", nil];
        Al = YES;
    [alertView show];
}

- (void)hideView
{
    [UIView animateWithDuration:1.5 animations:^{
        qianDaoView.alpha = 0;
    }];
}
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
        {
            if (Al == NO) {
                MyInfoViewController *myInfoVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyInfoViewController"];
                myInfoVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myInfoVC animated:YES];
            }else{
                [self joinBtnClick];
            }
            
        }
            break;
            
        default:
            break;
    }
}

-(void)refreshComments
{
    g_Page = 1;
    countnumber=0;
    [self requestTableDataWithPage:g_Page];
   
}

-(void)loadMoreComments
{
    if (lastNum == self.number.intValue/25+1 || lastNum == self.number.intValue/25) {
        [footerView endRefresh];
        return;
    }else{
    countnumber = 0;
    g_Page++;
    [self requestTableDataWithPage:g_Page];
    }

}

@end
