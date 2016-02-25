//
//  CommonUtils.m
//  SinaWeibo
//
//  Created by Kevin Su on 14-7-29.
//  Copyright (c) 2014年 com.kevin. All rights reserved.
//

#import "CommonUtils.h"

@implementation CommonUtils

//计算view的最右侧x
CGFloat VIEW_XPOS(CGRect rect)
{
    return rect.origin.x + rect.size.width;
}

//计算view的最下侧y
CGFloat VIEW_YPOS(CGRect rect)
{
    return rect.origin.y + rect.size.height;
}

//隐藏键盘
void HIDE_KEYBOARD(UIView *p)
{
    if (p.isFirstResponder)
    {
        [p resignFirstResponder];
    }
    for (UIView *subView in p.subviews)
    {
        HIDE_KEYBOARD(subView);
    }
}

//渲染控件阴影
void VIEW_RENDER(UIView *p,UIColor *color)
{
    [p setBackgroundColor:color];
    p.layer.shadowOffset = CGSizeMake(0, 0);
    p.layer.shadowColor = [UIColor blackColor].CGColor;
    p.layer.shadowOpacity = 0.5;
    p.layer.shadowPath = [UIBezierPath bezierPathWithRect:p.bounds].CGPath;
}

//创建文件夹
BOOL APP_CREATEFOLDER(NSString *path)
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                         withIntermediateDirectories:YES
                                                          attributes:nil
                                                               error:NULL];
    }
    return YES;
}

//创建文件
BOOL APP_CREATEFILE(NSString *path)
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        return [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    }
    return YES;
}

//删除文件
BOOL APP_DELETEFILE(NSString *path)
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    return YES;
}

//拷贝文件
BOOL APP_COPYFILE(NSString *f,NSString *t)
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:f])
    {
        return [[NSFileManager defaultManager] copyItemAtPath:f toPath:t error:nil];
    }
    return NO;
}

//移动文件
BOOL APP_MOVEFILE(NSString *f,NSString *t)
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:f])
    {
        return [[NSFileManager defaultManager] moveItemAtPath:f toPath:t error:nil];
    }
    return NO;
}

//文件夹下的所有文件
NSArray* APP_LISTFILES(NSString *path)
{
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
}

//系统可用内存
CGFloat SYS_FREEMOMERY()
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t vmInfo = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),HOST_VM_INFO,(host_info_t)&vmStats,&vmInfo);
    if (kernReturn != KERN_SUCCESS)
    {
        return  NSNotFound;
    }
    
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t info = TASK_BASIC_INFO_COUNT;
    kern_return_t kern = task_info(mach_task_self(),
                                   TASK_BASIC_INFO, (task_info_t)&taskInfo, &info);
    if (kern != KERN_SUCCESS)
    {
        return  NSNotFound;
    }
    return ((vm_page_size * vmStats.free_count) / 1024.0) / 1024.0;
}

//设备网络状态
BOOL SYS_NETSTATE()
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    SCNetworkReachabilityRef defaultRouteReachability =
    SCNetworkReachabilityCreateWithAddress(NULL, (struct
                                                  sockaddr*)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability,&flags);
    CFRelease(defaultRouteReachability);
    if (!didRetrieveFlags)
    {
        return -1;
    }
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? true : false;
}

//设备网络地址
NSString* SYS_NETADDRESS()
{
    struct ifaddrs* addrs = NULL;
    NSMutableDictionary * result = [NSMutableDictionary dictionary];
    
    BOOL success = (getifaddrs(&addrs) == 0);
    if (success)
    {
        const struct ifaddrs* cursor = addrs;
        while (cursor != NULL)
        {
            NSMutableString* ip;
            if (cursor->ifa_addr->sa_family == AF_INET)
            {
                const struct sockaddr_in* dlAddr = (const struct sockaddr_in*)cursor->ifa_addr;
                const uint8_t* base = (const uint8_t*)&dlAddr->sin_addr;
                ip = [NSMutableString stringWithCapacity:0];
                for (int i = 0; i < 4; i++)
                {
                    if (i != 0)
                        [ip appendFormat:@"."];
                    [ip appendFormat:@"%d", base[i]];
                }
                [result setObject:(NSString*)ip forKey:[NSString stringWithFormat:@"%s", cursor->ifa_name]];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    
    NSString* localIP = [result objectForKey:@"en0"];
    if (!localIP)
    {
        localIP = [result objectForKey:@"en1"];
    }
    if (!localIP)
    {
        localIP = @"0.0.0.0";
    }
    
    return localIP;
}

//图片缩放(等比)
UIImage* IMG_IMGZOOM(UIImage *originImage,CGFloat w,CGFloat h)
{
    if(originImage)
    {
        int width = originImage.size.width;
        int height = originImage.size.height;
        
        if (w != 0 && h == 0)
        {
            height = (height * w) / width;
            width = w;
        }
        if (h != 0 && w == 0)
        {
            width = (width * h) / height;
            height = h;
        }
        
        CGSize size = CGSizeMake(width, height);
        
        UIGraphicsBeginImageContext(size);
        [originImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
    
    return nil;
}

//修剪图片
UIImage* IMG_IMGTRIM(UIImage *originImage,CGSize subSize,CGRect subRect)
{
//    NSLog(@"image %f %f %f %f %f %f", subSize.width, subSize.height, subRect.origin.x, subRect.origin.y, subRect.size.width, subRect.size.height);
    CGImageRef imageRef = originImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subRect);
//    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, CGRectMake(280, 340, 240, 240));
    UIGraphicsBeginImageContext(subSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, subRect, subImageRef);
    UIImage* returnImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();//返回裁剪的部分图像
    return returnImage;
}

//截屏
UIImage* UTIL_SCREENSHOT()
{
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
    {
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    }
    else
    {
        UIGraphicsBeginImageContext(imageSize);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow * window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
            CGContextTranslateCTM(context, -[window bounds].size.width*[[window layer] anchorPoint].x, -[window bounds].size.height*[[window layer] anchorPoint].y);
            [[window layer] renderInContext:context];
            CGContextRestoreGState(context);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//定义navigation titleview
UIView* NAV_TITLE(NSString* s,CGRect f)
{
    UILabel *title = [[UILabel alloc] init];
    [title setText:s];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setTextColor:[UIColor whiteColor]];
    [title setFont:[UIFont boldSystemFontOfSize:18]];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setFrame:f];
    return title;
}

//定义导航视图
void NAV_INIT(UIViewController *vc ,NSString *title, NSString *left ,SEL leftObj, NSString *right, SEL rightObj)
{
    
    if(left != nil){
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 8, 30, 18)];
        UIImageView *leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 17)];
        leftImgView.image = [UIImage imageNamed:left];
        [button addSubview:leftImgView];
        [button addTarget:vc.self action:leftObj forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        vc.navigationItem.leftBarButtonItem = leftBarBtnItem;
    }

    if(right != nil){
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(220, 10, 80, 20)];
        UILabel *titleTxt = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
        titleTxt.text = right;
        [titleTxt setFont:[UIFont systemFontOfSize:15.0f]];
        titleTxt.textColor = [UIColor whiteColor];
        titleTxt.textAlignment = NSTextAlignmentRight;
        [button addSubview:titleTxt];
        [button addTarget:vc.self action:rightObj forControlEvents:UIControlEventTouchUpInside];
        
        [titleTxt setBackgroundColor:[UIColor clearColor]];
        [button setBackgroundColor:[UIColor clearColor]];
        UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        vc.navigationItem.rightBarButtonItem = rightBtnItem;
    }

    if(title != nil){
        UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(110, 8, 100, 17)];
        titleView.text = title;
        [titleView setFont:[UIFont systemFontOfSize:18.0f]];
        [titleView setTextColor:[UIColor whiteColor]];
        titleView.textAlignment = NSTextAlignmentCenter;
        [titleView setBackgroundColor:[UIColor clearColor]];
        vc.navigationItem.titleView = titleView;
    }

}

//手机号码校验
BOOL VERIFY_PHONE(NSString* p)
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:p] == YES)
        || ([regextestcm evaluateWithObject:p] == YES)
        || ([regextestct evaluateWithObject:p] == YES)
        || ([regextestcu evaluateWithObject:p] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//邮箱地址校验
BOOL VERIFY_EMAIL(NSString* p)
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:p];
}

//金额校验
BOOL VERIFY_PRICE(NSString* p)
{
    NSString *priceRegex = @"^(([0-9]|([1-9][0-9]{0,9}))((\\.[0-9]{1,2})?))$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", priceRegex];
    return [emailTest evaluateWithObject:p];
}

//邮政编码校验
BOOL VERIFY_ZIPCODE(NSString* p)
{
    NSString *zipCodeRegex = @"[1-9]d{5}(?!d)";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", zipCodeRegex];
    return [emailTest evaluateWithObject:p];
}

//身份证号码校验
BOOL VERIFY_IDENTITY(NSString* p)
{
    if (!p || [p length] == 0)
    {
        return NO;
    }
    NSString *identityRegex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",identityRegex];
    return [identityCardPredicate evaluateWithObject:p];
}

//姓名校验
BOOL VERIFY_SINGLE(NSString* p)
{
    if (!p || [p length] == 0)
    {
        return NO;
    }
    NSString *singleRegex = @"^([\u4e00-\u9fa5]+|([a-zA-Z]+\\s?)+)$";
    NSPredicate *singleCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",singleRegex];
    return [singleCardPredicate evaluateWithObject:p];
}

//密码校验
BOOL VERIFY_PASSWORD(NSString* p)
{
    if (!p || [p length] == 0)
    {
        return NO;
    }
    NSString *singleRegex = @"^[\\@A-Za-z0-9\\!\\#\\$\\%\\^\\&\\*\\.\\~]{6,22}$";
    NSPredicate *singleCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",singleRegex];
    return [singleCardPredicate evaluateWithObject:p];
}

//显示圆形头像
UIImageView *SHOW_CIRCLE_IMAGE(UIImageView *view, NSInteger borderWidth, UIColor *borderColor){
    [view.layer setCornerRadius:CGRectGetHeight([view bounds]) / 2];
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = borderWidth;
    view.layer.borderColor = [borderColor CGColor];
    return view;
}

//计算Label高度
//CGSize COUNTVIEWSIZE(NSString *content, UIFont *font, CGFloat width, CGFloat height){
//    
//    // 計算出顯示完內容需要的最小尺寸
//    if(ICIsObjectEmpty(content)){
//        
//        return CGSizeMake(width, height);
//    }
//    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(width, 1000.0f) lineBreakMode:NSLineBreakByWordWrapping];
//    return size;
//}
@end
