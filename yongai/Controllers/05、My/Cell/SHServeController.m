//
//  SHServeController.m
//  com.threeti
//
//  Created by alan on 15/10/29.
//  Copyright © 2015年 com.threeti.yongai. All rights reserved.
//

#import "SHServeController.h"
#import "SHServeGoodsCell.h"
#import "RetureMoneyWayCell.h"
#import "ApplyForNumCell.h"
#import "QDetailCell.h"
#import "UpDatePicCell.h"
#import "QBImagePickerController.h"
#import "DeletePictuerViewController.h"
#import "SuccessPViewController.h"
#import "ReturnBackViewController.h"
#import "CommonTextView.h"
@interface SHServeController () <UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,QBImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>

@end

@implementation SHServeController{
    UILabel * numLabel;
    int number;
    int tagNumber;//上传图片Btn点击次数
    CGFloat width;
    UITableView * myTableView;
    BOOL hiden;
    UIScrollView * myScrollView;
    UIImageView * imageView1;
    UIImageView * imageview2;
    UIImageView * imageview3;
    UIImageView * imageview4;
    UIImageView * imageview5;
    UITextView * TETView;
     NSMutableArray  *imageArr;
    UIImagePickerController *imagePicker;
     UIButton *currentShowBtn; //当前选择放大的图片
    NSString * serveType;
    CGFloat scroViewContenSizeH;
    UIButton * photoBtn;
    UIImageView * headImage;
    UIImageView * lineViewBottom;
    UILabel * labelBottom;
    UILabel * textViewLable;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NAV_INIT(self,@"申请售后服务", @"common_nav_back_icon", @selector(back), nil, nil);
    hiden = NO;
    number = 1;
    serveType = @"1";
    imageArr = [[NSMutableArray alloc] init];
    self.view.backgroundColor = BJCLOLR;
    [self createMytableView];
    [self createBottomView];
    [self addBackgroundImage];//服务类型
    [self createApply];//申请数量
    [self createQDetail];//问题描述
    [self createUpdatePic];//上传图片
    // 接收删除图片通知
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteChoosePicture) name:@"DeletePictureNotification" object:nil];
}
- (void)createBottomView
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, UIScreenHeight-76-45, UIScreenWidth, 60);
    [btn setTitle:@"提交申请" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = beijing;
    [btn addTarget:self action:@selector(NextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
#pragma mark -- 提交申请
- (void)NextAction
{
    UIImage *img0;
    if(imageArr.count > 0)
        img0= [imageArr objectAtIndex:0];
    
    UIImage *img1;
    if(imageArr.count > 1)
        img1 = [imageArr objectAtIndex:1];
    
    UIImage *img2;
    if(imageArr.count > 2)
        img2= [imageArr objectAtIndex:2];
    
    
//    "goods_id" = 337;
//    "order_id" = 3398;
//    "order_sn" = 2015102731515;
//    "product_id" = 747;
//    "service_type" = 1;
//    "user_id" = 27579;
    //service_type：售后服务类型 默认为0即无售后，1为退货 2为换货 3为维修
    if ([self.order_Status isEqualToString:@"3"]) {
        serveType = @"4";
    }
    if ([self.order_Status isEqualToString:@"4"]) {
        NSString * string = [TETView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string isEqualToString:@""] ) {
            [SVProgressHUD showErrorWithStatus:@"请描述您的问题所在"];
            return;
        }
        [[TTIHttpClient shareInstance] postSHServeWithuser_id:g_userInfo.uid withorder_sn:self.order_sn withgoods_id:self.model.goods_id withproduct_id:self.model.product_id  withAmount_apply:[NSString stringWithFormat:@"%d",number] withMessage:serveType withOrder_id:self.order_id withPhotos0:img0 withPhotos1:img1 withPhotos2:img2 withdescript:TETView.text withSucessBlock:^(TTIRequest *request, TTIResponse *response) {
            //成功后跳转页面
            SuccessPViewController * success = [[SuccessPViewController alloc] init];
            NSDictionary  * dict = response.result;
            success.serveType = serveType;
            success.dictType = dict;
            [self.navigationController pushViewController:success animated:YES];
            
        } withFailedBlock:^(TTIRequest *request, TTIResponse *response) {
            
        }];

    }
}
- (void)createMytableView
{

    SHServeGoodsCell * cell = [[SHServeGoodsCell alloc]init];
    [cell initWithModel:self.model];
    RetureMoneyWayCell * cell2 = [[RetureMoneyWayCell alloc] init];
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight-76-45)];
    myScrollView.backgroundColor = BJCLOLR;
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, UIScreenWidth, 100)];
    imageView.backgroundColor = [UIColor whiteColor];
    [imageView addSubview:cell];
    [myScrollView addSubview:imageView];
    imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 110, UIScreenWidth, 100)];
    imageView1.userInteractionEnabled = YES;
    imageView1.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:imageView1];
    imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 210, UIScreenWidth, 150)];
    imageview2.backgroundColor = [UIColor whiteColor];
    [imageview2 addSubview:cell2];
    [myScrollView addSubview:imageview2];
    imageview3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageview2.frame.origin.y+imageview2.frame.size.height, UIScreenWidth, 120)];
    imageview3.userInteractionEnabled = YES;
    imageview3.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:imageview3];
    imageview4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageview3.frame.origin.y+imageview3.frame.size.height, UIScreenWidth, 120)];
    imageview4.backgroundColor = [UIColor whiteColor];
    imageview4.userInteractionEnabled = YES;
    [myScrollView addSubview:imageview4];
    imageview5 = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageview4.frame.origin.y+imageview4.frame.size.height, UIScreenWidth, 140)];
    imageview5.backgroundColor = [UIColor whiteColor];
    imageview5.userInteractionEnabled = YES;
    [myScrollView addSubview:imageview5];
    scroViewContenSizeH = imageView.frame.size.height+imageView1.frame.size.height+imageview2.frame.size.height+imageview3.frame.size.height+imageview4.frame.size.height+imageview5.frame.size.height+60;
    myScrollView.contentSize = CGSizeMake(0,scroViewContenSizeH);
    [self.view addSubview:myScrollView];
   
}
#pragma  mark -- 服务类型
- (void)addBackgroundImage
{
    UIImageView * lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 10)];
    lineView.backgroundColor = BJCLOLR;
    lineView.layer.borderColor = LINE.CGColor;
    lineView.layer.borderWidth = 0.5;
    [imageView1 addSubview:lineView];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 100, 20)];
//    label.backgroundColor = BJCLOLR;
    label.text = @"服务类型";
    label.textColor = BLACKTEXT;
    label.font = font(14);
    [imageView1 addSubview:label];
    CGFloat leftJian = 10;
    CGFloat Width = (UIScreenWidth - 10*4)/3;
    NSArray * array = @[@"退货",@"换货",@"维修"];
    for (int i = 0; i< 3; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(leftJian+i*(Width+ 10), label.frame.origin.y+label.frame.size.height+10, Width,Width/4);
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
//        btn.backgroundColor = BJCLOLR;
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setTitleColor:BLACKTEXT forState:UIControlStateNormal];
        [btn setTitleColor:beijing forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"mc_spec_button_bgimage"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"spec_button_selected"] forState:UIControlStateSelected];
        btn.tag = 100+i;
        if (i == 0) {
            btn.selected = YES;
        }
        [btn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [imageView1 addSubview:btn];
    }

}
#pragma mark -- 申请数量
- (void)createApply
{
    number = 1;
    UIImageView * lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 10)];
    lineView.backgroundColor = BJCLOLR;
    lineView.layer.borderColor = LINE.CGColor;
    lineView.layer.borderWidth = 0.5;
    [imageview3 addSubview:lineView];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 100, 20)];
    label.text = @"申请数量";
    label.textColor = BLACKTEXT;
    label.font = font(14);
    [imageview3 addSubview:label];
    CGFloat leftJian = 10;
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(leftJian, label.frame.origin.y+label.frame.size.height+10, 30, 30);
    [btn setBackgroundImage:[UIImage imageNamed:@"减号"] forState:UIControlStateNormal];
//    [btn setTitle:@"➖" forState:UIControlStateNormal];
//    btn.backgroundColor = BJCLOLR;
    btn.tag = 100;
    [btn addTarget:self action:@selector(action1:) forControlEvents:UIControlEventTouchUpInside];
    [imageview3 addSubview:btn];
    numLabel = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.origin.x+btn.frame.size.width+5, btn.frame.origin.y, 30, 30)];
    numLabel.text = @"1";
    numLabel.layer.borderColor = LINE.CGColor;
    numLabel.layer.borderWidth = 0.5;
    numLabel.textAlignment = NSTextAlignmentCenter;
    [imageview3 addSubview:numLabel];
    UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(numLabel.frame.origin.x+numLabel.frame.size.width+5 ,btn.frame.origin.y, 30, 30);
    btn2.tag = 101;
    [btn2 setBackgroundImage:[UIImage imageNamed:@"加号"] forState:UIControlStateNormal];
//    [btn2 setTitle:@"➕" forState:UIControlStateNormal];
//    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    btn2.backgroundColor = beijing;
    [btn2 addTarget:self action:@selector(action1:) forControlEvents:UIControlEventTouchUpInside];
    [imageview3 addSubview:btn2];
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(leftJian, btn.frame.size.height+btn.frame.origin.y+5, UIScreenWidth - 50, 30)];
    label1.text =[NSString stringWithFormat:@"您最多可提交数量为%@个",self.model.goods_number];// @"您最多可提交数量为1个";
    label1.textColor = TEXT;
    label1.font = [UIFont systemFontOfSize:13.0];
    [imageview3 addSubview:label1];
}
#pragma  mark -- 问题描述
- (void)createQDetail
{
    UIImageView * lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 10)];
    lineView.backgroundColor = BJCLOLR;
    lineView.layer.borderColor = LINE.CGColor;
    lineView.layer.borderWidth = 0.5;
    [imageview4 addSubview:lineView];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 100, 20)];
    label.text = @"问题描述";
    label.textColor = BLACKTEXT;
    label.font = font(14);
    [imageview4 addSubview:label];
    TETView = [[UITextView alloc] initWithFrame:CGRectMake(10, label.frame.origin.y+label.frame.size.height+10, UIScreenWidth - 80, 60)];
    TETView.font = [UIFont systemFontOfSize:13.0];
    TETView.layer.masksToBounds = YES;
    TETView.layer.cornerRadius = 5;
    TETView.layer.borderWidth = 0.5;
    TETView.delegate  = self;
    TETView.layer.borderColor = LINE.CGColor;
    [imageview4 addSubview:TETView];
}
#pragma mark -- 上传图片
- (void)createUpdatePic
{
    
    tagNumber = 0;
    width = (UIScreenWidth - 50)/4-5;
   lineViewBottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 10)];
    lineViewBottom.backgroundColor = BJCLOLR;
    lineViewBottom.layer.borderColor = LINE.CGColor;
    lineViewBottom.layer.borderWidth = 0.5;
    [imageview5 addSubview:lineViewBottom];
    labelBottom = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 150, 20)];
    labelBottom.text = @"上传图片(最多上传三张)";
    labelBottom.textColor = BLACKTEXT;
    labelBottom.font = font(14);
    [imageview5 addSubview:labelBottom];
    photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    photoBtn.frame  =CGRectMake(10, labelBottom.frame.origin.y+labelBottom.frame.size.height+10, width, width);
    photoBtn.layer.masksToBounds = YES;
    photoBtn.layer.cornerRadius = width/2;
    [photoBtn setBackgroundImage:[UIImage imageNamed:@"上传图片"] forState:UIControlStateNormal];
    [photoBtn addTarget:self action:@selector(action2:) forControlEvents:UIControlEventTouchUpInside];
    photoBtn.backgroundColor = BJCLOLR;
    [imageview5 addSubview:photoBtn];
}
#pragma mark -- 申请数量点击
- (void)action1:(UIButton *)button
{
    UIButton * btn2 = (UIButton*)[imageview3 viewWithTag:101];
    if (button.tag == 100) {
        //－
        btn2.enabled = YES;
        if (number != 1) {
            number -- ;
            numLabel.text = [NSString stringWithFormat:@"%d",number];
        }
        
    }else if (button.tag == 101){
        //加
        
        if (number == self.model.goods_number.intValue) {
//            number = 1;
            btn2.enabled = NO;
            return;
        }
        number ++;
        numLabel.text = [NSString stringWithFormat:@"%d",number];
    }
}

#pragma mark -- 服务点击
- (void)action:(UIButton *) button
{
    CGFloat h;
    for (int i =0; i< 3; i++) {
        UIButton * btn = (UIButton *)[imageView1 viewWithTag:100+i];
        btn.selected = NO;
    }
    serveType = [NSString stringWithFormat:@"%ld",button.tag - 100 +1];
    button.selected  = YES;
    if (button.tag != 100) {
        imageview2.hidden = YES;
        h = 150;
        imageview2.frame = CGRectMake(0, 210, UIScreenWidth, 0);
    }else{
        
        h = 0 ;
        imageview2.hidden = NO;
        imageview2.frame = CGRectMake(0, 210, UIScreenWidth, 150);
    }
    imageview3.frame = CGRectMake(0, imageview2.frame.origin.y+imageview2.frame.size.height, UIScreenWidth, 120);
    imageview4.frame =  CGRectMake(0, imageview3.frame.origin.y+imageview3.frame.size.height, UIScreenWidth, 120);
    imageview5.frame =  CGRectMake(0, imageview4.frame.origin.y+imageview4.frame.size.height, UIScreenWidth, 140);
    myScrollView.contentSize = CGSizeMake(0, scroViewContenSizeH- h);
    NSLog(@"%@",button.titleLabel.text);
}
#pragma mark -- 上传点击
- (void)action2:(UIButton *)button
{
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
                imagePickerController.maximumNumberOfSelection = 3-imageArr.count;
                
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
#pragma mark - QBImagePickerControllerDelegate

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    DLOG(@"*** qb_imagePickerController:didSelectAssets:");
    NSLog(@"%@", assets);
    
//    [imageArr removeAllObjects];
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
- (void)dismissImagePickerController
{
    if (self.presentedViewController)
    {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}
#pragma mark-- 从相册返回接受图片数组
-(void)setImageButtonByArr:(NSMutableArray *)arr
{
    int imageWith = (UIScreenWidth - 50)/4;
    int count;
    if (arr.count > 3) {
        count = 3;
//        self.FuViewH.constant = 447+imageWith;
    }else{
//        self.FuViewH.constant = 437;
        count = (int)imageArr.count;
    }
    
    for (int i =0 ; i<count; i++) {
        UIButton * imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * image = arr[i];
        imageBtn.frame = CGRectMake(10+i%4*(imageWith+10),50, imageWith, imageWith);
        imageBtn.tag = 300+i;
        [imageBtn setImage:image forState:UIControlStateNormal];
        [imageBtn addTarget:self action:@selector(ShowImgDetailView:) forControlEvents:UIControlEventTouchUpInside];
        
        [imageview5 addSubview:imageBtn];
    }
    if (imageArr.count < 3) {
        [self reloadPhotoBtn];
    }
    
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
    
        // 照片详情
    DeletePictuerViewController *pictureVC = [[UIStoryboard storyboardWithName:@"my" bundle:nil] instantiateViewControllerWithIdentifier:@"DeletePictuerViewController"];
    pictureVC.image = pictureImage;
    pictureVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pictureVC animated:YES];
}
#pragma mark -- 更新照片按钮
- (void)reloadPhotoBtn
{
    if (imageArr.count > 0) {
        photoBtn.frame  =CGRectMake(10+(width+15)*imageArr.count,photoBtn.frame.origin.y, width, width);
    }else{
        photoBtn.frame  =CGRectMake(10,photoBtn.frame.origin.y, width, width);
    }
    [imageview5 addSubview:lineViewBottom];
    [imageview5 addSubview:labelBottom];
    [imageview5 addSubview:photoBtn];
}
- (void)deleteChoosePicture {
    
    NSInteger index = currentShowBtn.tag - 300;
    
    [imageArr removeObjectAtIndex:index];
    currentShowBtn = nil;
    [imageview5.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setImageButtonByArr:imageArr];
    
        [self reloadPhotoBtn];
    
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


- (void)back
{
    if ([self.formTitle isEqualToString:@"确认收货"]) {
        NSArray * ctrlArray = self.navigationController.viewControllers;
        [self.navigationController popToViewController:[ctrlArray objectAtIndex:1] animated:YES];
    }else{
      [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
