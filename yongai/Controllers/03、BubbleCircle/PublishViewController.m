//
//  PublishViewController.m
//  Yongai
//
//  Created by myqu on 14/11/17.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "PublishViewController.h"
#import "CommonTextView.h"
#import "DXFaceView.h"
#import "QBImagePickerController.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "DeletePictuerViewController.h"
#import "CommonHelper.h"
#import "WebViewController.h"
#import "SlidingViewManager.h"
#import "MyPageControl.h"
#define space 10  
@interface PublishViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate , DXFaceDelegate, QBImagePickerControllerDelegate,UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    IBOutlet UIView *textViewBgView;
    UIImagePickerController *imagePicker;
    
    IBOutlet UITextField *subjectTextFiled;
    CommonTextView *inputTextView;
    BOOL bShowFace; // 是否显示笑脸的标示
    NSMutableArray * tag_ids;
       MyPageControl * myPageControl;
    NSMutableArray  *imageArr;
     NSArray * imageList;
    BOOL _isOpen;
    BOOL _isFirst;
    UIButton *currentShowBtn; //当前选择放大的图片
    IBOutlet NSLayoutConstraint *lineTwoButtonRatio;
    UIScrollView * biaoQianScrollerView;
    UIImageView * BQView;
    UIImageView * xiaoView;//笑脸
    SlidingViewManager *svm;
       BOOL  bPublishing;
    UIButton * btn;
    BOOL isFirst;
    NSMutableArray * btnArray;
    NSString * ver;
    NSString * sex_choose;
    UIAlertView *alertView;
    
}
@property(nonatomic ,strong)  DXFaceView *faceView;  // 笑脸;

// 内容高度的约束  原 228 ＝ 140（编辑框高度）＋ 88（图片高度）
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *FuViewH;
@property (weak, nonatomic) IBOutlet UIView *imageBView;

- (IBAction)showDespInfoBtnAction:(id)sender;


@end

@implementation PublishViewController
- (void)viewDidLayoutSubviews
{
   
    self.BGScroller.contentSize = CGSizeMake(UIScreenWidth, UIScreenHeight+10);
    self.BGScroller.showsHorizontalScrollIndicator = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
   alertView = [[UIAlertView alloc] initWithTitle:nil message:@"现在是审核时段，您发布的帖子将在审核通过后显示~"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
    ver = VERSION;
    sex_choose = @"0";
        self.xiaImageH.constant = 100;
     self.imageBView.userInteractionEnabled = YES;
    imageArr = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    NAV_INIT(self, @"发帖", @"common_nav_back_icon", @selector(back), @"发布", @selector(publishAction0));
    btnArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = BJCLOLR;
    [self.sheQubtn setTitleColor:RGBACOLOR(253, 110, 16, 1) forState:UIControlStateNormal];
    self.xuanZhongTop.constant = 12;
    self.xuanZhongLable.hidden = YES;
//    self.titleTF.text = @"明确的标题会有更多人看哦~";
    self.titleTF.placeholder = @"明确的标题会有更多人看哦~";
    [self.titleTF setValue:TEXT forKeyPath:@"_placeholderLabel.textColor"];
    self.titleTF.font = font(17);
    self.titleTF.textColor = TEXT;
    self.titleTF.delegate = self;
    _isOpen = NO;
    isFirst = YES;
    imageList = [[NSArray alloc ] init];

    [self createBiaoQianView];
    tag_ids = [[NSMutableArray alloc ] init];
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    self.faceView = [[DXFaceView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
    
    [self.faceView setDelegate:self];
    self.faceView.backgroundColor = [UIColor lightGrayColor];
    self.faceView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:self.faceView];
    [self createLable];
    [self createSexView];
    // 接收删除图片通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteChoosePicture) name:@"DeletePictureNotification" object:nil];
   UIButton *xiaoViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    xiaoViewBtn.frame = CGRectMake(10, 0, 30, 30);
    [xiaoViewBtn setBackgroundImage:[UIImage imageNamed:@"MyTopicDetail_smile"] forState:UIControlStateNormal];
    [xiaoViewBtn addTarget:self action:@selector(xiaoViewBtn) forControlEvents:UIControlEventTouchUpInside];
   //    xiaoView.hidden = YES;
    [self initView];
    [self viewDidLayoutSubviews];
   
}
- (void)xiaoViewBtn
{
    
    if(bShowFace == NO)
    {
        bShowFace = YES;
        self.faceView.frame = CGRectMake(0, self.view.frame.size.height-200, self.view.frame.size.width, 200);
    }
    else
    {
        bShowFace = NO;
        [UIView animateWithDuration:0.5 animations:^{
            xiaoView.frame = CGRectMake(0,self.view.frame.size.height, UIScreenWidth,40);
            self.faceView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 0);
        }];
    }

}
- (void)viewWillAppear:(BOOL)animated
{
//    [SVProgressHUD showErrorWithFaBuStatus:@"现在是审核时段，您发布的帖子将在审核通过后显示~"];
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[TTIHttpClient shareInstance] userInfoRequestWithsid:nil withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
//        [SVProgressHUD dismiss];
        if ([g_userInfo.verify_config isEqualToString:@"1"]) {
          [SVProgressHUD showErrorWithFaBuStatus:@"现在是审核时段，您发布的帖子将在审核通过后显示~"];
        }
            
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
            
        }];
    PublishViewController * pu;
    [super viewWillAppear:animated];
    [pu viewWillAppear:animated];

}
- (void)createLable
{
    self.xuanZhongLable.font = font(16);
    self.xuanZhongLable.textColor = TEXT;
    UILabel * label = [[UILabel alloc ] initWithFrame:CGRectMake(10,13, UIScreenWidth - 100, 30)];
    UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, UIScreenWidth, 0.5)];
    line.backgroundColor = LINE;
    [self.labelVIew addSubview:line];
    UIImageView * line2 = [[UIImageView alloc] initWithFrame:CGRectMake(0,50, UIScreenWidth, 0.5)];
    line2.backgroundColor = LINE;
    [self.labelVIew addSubview:line2];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:@"选择标签（ 必选/支持多选 ）"];
    NSRange grayRange = NSMakeRange(4,11);
    NSRange grayRange1 = NSMakeRange(0, 4);
    [noteStr addAttribute:NSForegroundColorAttributeName value:TEXT range:grayRange];
    [noteStr addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(108, 97, 85, 1)  range:grayRange1];
    [noteStr addAttribute:NSFontAttributeName value:font(17) range:grayRange];
    [noteStr addAttribute:NSFontAttributeName value:font(17)  range:grayRange1];
    [label setAttributedText:noteStr] ;
    UIImageView * imageJianTou = [[UIImageView alloc ] initWithFrame:CGRectMake(UIScreenWidth-30, 16, 10, 20)];
    imageJianTou.image = [UIImage imageNamed:@"箭头1"];
    [_labelVIew addSubview:imageJianTou];
    [_labelVIew addSubview:label];
}
#pragma mark--创建性别标签
- (void)createSexView
{
     UILabel * label = [[UILabel alloc ] initWithFrame:CGRectMake(10,8, UIScreenWidth - 100, 30)];
    label.font = font(17);
    label.textColor = BLACKTEXT;
    self.sexView.userInteractionEnabled = YES;
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:@"指定回复人性别（ 可选 ）"];
    NSRange grayRange = NSMakeRange(7,6);
    NSRange grayRange1 = NSMakeRange(0, 7);
    [noteStr addAttribute:NSForegroundColorAttributeName value:TEXT range:grayRange];
    [noteStr addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(108, 97, 85, 1)  range:grayRange1];
    [noteStr addAttribute:NSFontAttributeName value:font(17) range:grayRange];
    [noteStr addAttribute:NSFontAttributeName value:font(17)  range:grayRange1];
    [label setAttributedText:noteStr] ;
    [self.sexView addSubview:label];
    for (int i = 0; i< 2; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(UIScreenWidth/4*3+i*50-10, 15, 15, 15);
        button.selected = NO;
        button.tag = 250+i;
        [button addTarget:self action:@selector(sexButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"性别未选中"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"性别选中"] forState:UIControlStateSelected];
        UILabel * sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.origin.x+button.frame.size.width+2, 13, 20, 20)];
        if (i==0) {
            sexLabel.text=  @"男";
        }else
        {
            sexLabel.text = @"女";
        }
        sexLabel.font = [UIFont systemFontOfSize:17];
        [self.sexView addSubview:sexLabel];
        [self.sexView addSubview:button];
    }
}
- (void)sexButton:(UIButton*)sexBtn
{
    UIButton * button1 = (UIButton *)[self.sexView viewWithTag:250];
    UIButton * button2 = (UIButton *)[self.sexView viewWithTag:251];
    if (sexBtn.tag == 251) {
        button1.selected = NO;
        if (sexBtn.selected == YES) {
            sexBtn.selected = NO;
            sex_choose =@"0";
        }else{
            sexBtn.selected = YES;
            sex_choose =@"2";
        }
    }else{
        button2.selected = NO;
        if (sexBtn.selected == YES) {
            sexBtn.selected = NO;
            sex_choose =@"0";
        }else{
            sexBtn.selected = YES;
            sex_choose =@"1";
        }
    }
    
}
//创建标签
- (void)createBiaoQianView
{
    BQView = [[UIImageView alloc ] initWithFrame:CGRectMake(0, UIScreenHeight-270, UIScreenWidth, 270)];
    BQView.userInteractionEnabled = YES;
//    BQView.hidden = YES;
    BQView.backgroundColor = BJCLOLR;
//    [self.view addSubview:BQView];
    
    UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame  = CGRectMake(10, 5, 70, 30);
    [cancleBtn setBackgroundImage:[UIImage imageNamed:@"取消-1"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [BQView addSubview:cancleBtn];
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame  = CGRectMake(UIScreenWidth-80, 5, 70, 30);
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"确认-1"] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [BQView addSubview:sureBtn];
    biaoQianScrollerView = [[UIScrollView alloc ] initWithFrame:CGRectMake(0, BQView.frame.size.height - 230, UIScreenWidth, 200)];
    biaoQianScrollerView.showsVerticalScrollIndicator = YES;
    biaoQianScrollerView.pagingEnabled = YES;
    int btnW = (UIScreenWidth - 4*space)/3;
    
        for (int i = 0; i < _biaoQianArr.count; i++) {
            NSDictionary * dict = _biaoQianArr[i];
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(space+(i/3)*(btnW+space), 15+50*(i%3), btnW, 40);
            btn.tag =[[dict objectForKey:@"tag_id"]integerValue];
            [btn setBackgroundImage:[UIImage imageNamed:@"标签分类1"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"选中标签1"] forState:UIControlStateSelected];
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 5;
            btn.selected = NO;
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn setTitle:[dict objectForKey:@"tag_name"] forState:UIControlStateNormal];
            [btn setTitleColor:TEXT forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(biaoQianClik:) forControlEvents:UIControlEventTouchUpInside];
            [biaoQianScrollerView addSubview:btn];
            
        }
    biaoQianScrollerView.contentSize = CGSizeMake(UIScreenWidth*(1+_biaoQianArr.count/9), 0);
    biaoQianScrollerView.delegate = self;
    biaoQianScrollerView.backgroundColor = [UIColor whiteColor];
    [BQView addSubview:biaoQianScrollerView];
    myPageControl = [[MyPageControl alloc ] initWithFrame:CGRectMake(0, biaoQianScrollerView.frame.origin.y+biaoQianScrollerView.frame.size.height, UIScreenWidth, 30)];
    myPageControl.backgroundColor = [UIColor whiteColor];
    myPageControl.numberOfPages = (1+_biaoQianArr.count/9);
    myPageControl.currentPage = 0;
    myPageControl.tag = 201;
    [BQView addSubview:myPageControl];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int current = scrollView.contentOffset.x/UIScreenWidth;
    
    //根据scrollView 的位置对page 的当前页赋值
    UIPageControl *page = (UIPageControl *)[self.view viewWithTag:201];
    page.currentPage = current;
    
}

- (void)cancleBtnAction
{
    for (btn in btnArray) {
        if (btn.selected == YES) {
            btn.selected = NO;
        }
    }
    [btnArray removeAllObjects];
    [tag_ids removeAllObjects];
    if (tag_ids.count!= 0) {
        self.xuanZhongLable.hidden = NO;
    }else{
        self.xuanZhongLable.hidden = YES;
    }

    [svm slideViewOut];
}
- (void)sureBtnAction
{
    if (tag_ids.count!= 0) {
        self.xuanZhongLable.hidden = NO;
    }else{
        self.xuanZhongLable.hidden = YES;
    }
    [svm slideViewOut];
}
- (void)biaoQianClik:(UIButton * )button
{
    if (button.selected == YES) {
        button.selected = NO;
        [tag_ids removeObject:button];
        if (tag_ids) {
            [tag_ids removeObject:[NSString stringWithFormat:@"%ld",button.tag]];
        }
    }else{
        button.selected = YES;
        [btnArray addObject:button];
        [tag_ids addObject:[NSString stringWithFormat:@"%ld",button.tag]];
    }
}
//是否收起标签
- (IBAction)buttonAction:(UIButton *)sender {
    svm = [[SlidingViewManager alloc] initWithInnerView:BQView containerView:self.view];
    [svm slideViewIn];
}
-(void)back
{
    [btnArray removeAllObjects];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)ShowImgDetailView:(id)sender
{
    currentShowBtn = (UIButton *)sender;
    UIImage * pictureImage;
    if (currentShowBtn.tag == 300) {
        pictureImage = imageArr[0];
    }
    if (currentShowBtn.tag == 301) {
        pictureImage = imageArr[1];
    }
    if (currentShowBtn.tag == 302) {
        pictureImage = imageArr[2];
    }
    if (currentShowBtn.tag == 303) {
        pictureImage = imageArr[3];
    }
    if (currentShowBtn.tag == 304) {
        pictureImage = imageArr[4];
    }
    if (currentShowBtn.tag == 305) {
        pictureImage = imageArr[5];
    }
    if (currentShowBtn.tag == 306) {
        pictureImage = imageArr[6];
    }
    if (currentShowBtn.tag == 307) {
        pictureImage = imageArr[7];
    }
    // 照片详情
    DeletePictuerViewController *pictureVC = [[UIStoryboard storyboardWithName:@"my" bundle:nil] instantiateViewControllerWithIdentifier:@"DeletePictuerViewController"];
    pictureVC.image = pictureImage;
    pictureVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pictureVC animated:YES];
}

- (void)deleteChoosePicture {
    
    NSInteger index = currentShowBtn.tag - 300;
    
    [imageArr removeObjectAtIndex:index];
    currentShowBtn = nil;
    [self.imageBView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setImageButtonByArr:imageArr];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)initView
{
    inputTextView = [[CommonTextView alloc] initWithFrame:CGRectMake(5,2, self.view.frame.size.width-10,173)];
    inputTextView.delegate = self;
    inputTextView.font = font(16);
    inputTextView.placeholderColor = TEXT ;
    inputTextView.placeholder = @"小编吐血提示：咱可以没有节操，但咱不能直接发QQ、微信、手机号，更不能直接写约炮、约P，露点照那就更不可以了。所有发布违规内容的用户将被禁言或直接封设备。";
    [self.centerView addSubview:inputTextView];
}
- (IBAction)showSmileView:(id)sender {
    
    // UIButton *btn = (UIButton *)sender;
    NSLog(@"笑脸");
    isFirst = YES;
    if(bShowFace == NO)
    {
        bShowFace = YES;
        self.faceView.frame = CGRectMake(0, self.view.frame.size.height-200, self.view.frame.size.width, 200);
    }
    else
    {
        bShowFace = NO;
        self.faceView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 0);
    }
}

- (IBAction)showPictureView:(id)sender {
    
    NSLog(@"拍照");
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册中取", nil];
    [sheet showInView:self.view];
}

#pragma mark ---   UIActionSheet  Delegate

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
                QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.allowsMultipleSelection = YES;
                imagePickerController.maximumNumberOfSelection = 8;
                
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
                [self presentViewController:navigationController animated:YES completion:NULL];
                
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

- (void)dismissImagePickerController
{
    if (self.presentedViewController)
    {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

#pragma mark - QBImagePickerControllerDelegate

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    DLOG(@"*** qb_imagePickerController:didSelectAssets:");
    NSLog(@"%@", assets);
    
    [imageArr removeAllObjects];
    for(int i=0 ;i< [assets count]; i++)
    {
        ALAsset *asset = [assets objectAtIndex:i];
        UIImage *sourceImg =[self fullResolutionImageFromALAsset:asset];
        
        UIImageOrientation imageOrientation = sourceImg.imageOrientation;
        if(imageOrientation != UIImageOrientationUp)
        {
            UIGraphicsBeginImageContext(sourceImg.size);
            [sourceImg drawInRect:CGRectMake(0, 0, sourceImg.size.width, sourceImg.size.height)];
            sourceImg = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        CGSize  imgSize;
        imgSize.height = (sourceImg.size.height*self.view.frame.size.width )/ sourceImg.size.width;
        imgSize.width = self.view.frame.size.width;
        
        UIImage *img = [self imageWithImageSimple:sourceImg scaledToSize:imgSize];
        
        
        [imageArr addObject:img];
    }
    [self setImageButtonByArr:imageArr];
    
    [self dismissImagePickerController];
}

-(void)setImageButtonByArr:(NSMutableArray *)arr
{
    int imageWith = (UIScreenWidth - 50)/4;
    if (arr.count > 4) {
        self.FuViewH.constant = 447+imageWith;
    }else{
        self.FuViewH.constant = 437;
    }
    
    for (int i =0 ; i<imageArr.count; i++) {
        UIButton * imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * image = arr[i];
        imageBtn.frame = CGRectMake(10+i%4*(imageWith+10),i/4*(imageWith+10), imageWith, imageWith);
        imageBtn.tag = 300+i;
        [imageBtn setImage:image forState:UIControlStateNormal];
        [imageBtn addTarget:self action:@selector(ShowImgDetailView:) forControlEvents:UIControlEventTouchUpInside];
       
        [self.imageBView addSubview:imageBtn];
    }

}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    DLOG(@"*** qb_imagePickerControllerDidCancel:");
    
    [self dismissImagePickerController];
}

-(UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset
{
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullResolutionImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef
                                       scale:assetRep.scale
                                 orientation:(UIImageOrientation)assetRep.orientation];
    return img;
}

#pragma mark ---  UIImagePickerController  Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    // 当来数据来源是照相机
    if([mediaType isEqualToString:@"public.image"] && imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
        
        //  如果是拍照的照片，则需要手动保存到本地，系统不会自动保存拍照成功后的照片
        UIImageWriteToSavedPhotosAlbum(orgImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
        [imagePicker dismissViewControllerAnimated:YES completion:nil];
    }
    
    UIImage *sourceImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImageOrientation imageOrientation = sourceImg.imageOrientation;
    if(imageOrientation != UIImageOrientationUp)
    {
        UIGraphicsBeginImageContext(sourceImg.size);
        [sourceImg drawInRect:CGRectMake(0, 0, sourceImg.size.width, sourceImg.size.height)];
        sourceImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    CGSize  imgSize;
    imgSize.height = (sourceImg.size.height*self.view.frame.size.width )/ sourceImg.size.width;
    imgSize.width = self.view.frame.size.width;
    
    UIImage *img = [self imageWithImageSimple:sourceImg scaledToSize:imgSize];
    
    
    // 拍照更新
    NSUInteger count = [imageArr count];
    if(count == 8)
        [imageArr replaceObjectAtIndex:count-1 withObject:img];
    else
        [imageArr insertObject:img atIndex:count];
    [self  setImageButtonByArr:imageArr];
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

// 保存照片成功后的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo{
    
    NSLog(@"saved..");
}

#pragma mark --- DXFace   Delegate <FacialViewDelegate>

- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete
{
    
        NSString *chatText = inputTextView.text;
        if (!isDelete && str.length > 0) {
            inputTextView.text = [NSString stringWithFormat:@"%@%@",chatText,str];
        }
        else {
            if (chatText.length >= 2)
            {
                NSString *subStr = [chatText substringFromIndex:chatText.length-2];
                if ([(DXFaceView *)self.faceView stringIsFace:subStr]) {
                    inputTextView.text = [chatText substringToIndex:chatText.length-2];
                    return;
                }
            }
            
            if (chatText.length > 0) {
                inputTextView.text = [chatText substringToIndex:chatText.length-1];
            }
        }
    
    
}
- (void)sendFace
{
    [self  showSmileView:nil];
}

#pragma mark --- 发布

-(void)publishAction0
{
    NSString * string;
       if ([self.titleTF.text isEqualToString:@"明确的标题会有更多人看哦~"]) {
        string = @"";
    }
    if(ICIsStringEmpty(self.titleTF.text)||[string isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入标题"];
        return;
    }
    else if ([CommonHelper validateSpace:self.titleTF.text])
    {
        [SVProgressHUD showErrorWithStatus:@"标题不能为空"];
        return;
    }
    else if (ICIsStringEmpty(inputTextView.text))
    {
        [SVProgressHUD showErrorWithStatus:@"请输入正文"];
        return;
    }
    else if ([CommonHelper validateSpace:inputTextView.text])
    {
        [SVProgressHUD showErrorWithStatus:@"正文不能为空"];
        return;
    }else if (tag_ids.count == 0||btnArray.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择标签"];
        return;
    }
    NSString * titleTF = [self.titleTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (titleTF.length < 2) {
        [SVProgressHUD showErrorWithStatus:@"标题至少需要2个汉字或4个字母哟~"];
        return;
    }
    NSString * zhengwen = [inputTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (zhengwen.length < 6) {
        [SVProgressHUD showErrorWithStatus:@"正文至少需要6个汉字或12个字母哟~"];
        return;
    }

    UIImage *img0;
    if(imageArr.count > 0)
        img0= [imageArr objectAtIndex:0];
    
    UIImage *img1;
    if(imageArr.count > 1)
        img1 = [imageArr objectAtIndex:1];
    
    UIImage *img2;
    if(imageArr.count > 2)
        img2= [imageArr objectAtIndex:2];
    
    UIImage *img3;
    if(imageArr.count > 3)
        img3= [imageArr objectAtIndex:3];
    
    UIImage *img4;
    if(imageArr.count > 4)
        img4 = [imageArr objectAtIndex:4];
    
    UIImage *img5;
    if(imageArr.count > 5)
        img5= [imageArr objectAtIndex:5];
    
    UIImage *img6;
    if(imageArr.count > 6)
        img6= [imageArr objectAtIndex:6];
    
    UIImage *img7;
    if(imageArr.count > 7)
        img7 = [imageArr objectAtIndex:7];
    
    if(bPublishing == YES)
        return;
    else
        bPublishing = YES;
    
    NSString *title = [ConvertToCommonEmoticonsHelper convertToCommonEmoticons:self.titleTF.text];
    NSString *content = [ConvertToCommonEmoticonsHelper convertToCommonEmoticons:inputTextView.text];
    [[TTIHttpClient shareInstance] addBbsRequestWithFid:_fid
                                                withTid:nil
                                                withPup:nil
                                            withSubject:title
                                            withMessage:content
                                            withPhotos0:img0
                                            withPhotos1:img1
                                            withPhotos2:img2
                                            withPhotos3:img3
                                            withPhotos4:img4
                                            withPhotos5:img5
                                            withPhotos6:img6
                                            withPhotos7:img7
                                             withTag_ids:tag_ids
                                            withVersion:ver
                                         withSex_Choose:sex_choose
                                        withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
                                            bPublishing = NO;
//                                            [UIView animateWithDuration:2 animations:^{
                                                [self back];
//                                            }];
                                            
                                            
    } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
        
        bPublishing = NO;
        [SVProgressHUD showErrorWithStatus:response.error_desc];
    }];
}

- (IBAction)showDespInfoBtnAction:(id)sender
{
    WebViewController *webVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"WebViewController"];
    webVC.bShowBbsRule = YES;
    [self.navigationController pushViewController:webVC animated:YES];
  
}

@end
