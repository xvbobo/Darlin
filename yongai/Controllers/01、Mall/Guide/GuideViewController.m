//
//  GuideViewController.m
//  Yongai
//
//  Created by Kevin Su on 14/12/1.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "GuideViewController.h"
#import "YongaiYabbarController.h"
#import "UIImageView+AFNetworking.h"
@interface GuideViewController ()
{
     NSInteger isGetAds; //是否取到广告业
    UIImageView *imageView;
}

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *image_1;
    NSString *image_2;
    NSString *image_3;
    NSString *image_4;
    NSString *image_5;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    if(width == 320){
        
        if(height == 480){
            
            //4,4s
            image_2 = @"引导页02-320×480";
            image_5 = @"引导页05-320×480";
        }else{
            
            //5,5s
            
            image_2 = @"引导页02-640×1136";
            image_5 = @"引导页05-640×1136";
        }
    }else if(width == 375){
        
        //6
        
        image_2 = @"引导页02-750×1334";
        image_5 = @"引导页05-750×1334";
    }else{
        
        //6+
        
        image_2 = @"引导页02-1242×2208";
        
        image_5 = @"引导页05-1242×2208";
    }
    
//    self.page_1 = [UIImage imageNamed:image_1];
    self.page_2 = [UIImage imageNamed:image_2];
//    self.page_3 = [UIImage imageNamed:image_3];
//    self.page_4 = [UIImage imageNamed:image_4];
    self.page_5 = [UIImage imageNamed:image_5];
    NSUserDefaults * ud = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstLaunch"];
    NSLog(@"%@",ud);
    
//    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
//        //第一次启动
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
//        [self showIntroWithCrossDissolve];
//    }else{
        yongaiVC = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"YongaiYabbarController"];
        yongaiVC.tabBar.barTintColor = RGBACOLOR(169,0,11, 1);
        yongaiVC.tabBar.tintColor = [UIColor whiteColor];
        [self.navigationController pushViewController:yongaiVC animated:NO];
//    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showIntroWithCrossDissolve {
//    EAIntroPage *page1 = [EAIntroPage page];
//    page1.bgImage = _page_1;
    EAIntroPage *page2 = [EAIntroPage page];
    page2.bgImage = _page_2;
//    EAIntroPage *page3 = [EAIntroPage page];
//    page3.bgImage = _page_3;
//    EAIntroPage *page4 = [EAIntroPage page];
//    page4.bgImage = _page_4;
    EAIntroPage *page5 = [EAIntroPage page];
    page5.bgImage = _page_5;
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page2,page5]];
    intro.pageControl.currentPageIndicatorTintColor = RGBACOLOR(224, 224, 224, 1);
//    pageControl.pageIndicatorTintColor = [UIColor grayColor];
//    intro.pageControl.pageIndicatorTintColor = RGBACOLOR(224, 224, 224, 1);
//    intro.pageControl.backgroundColor = RGBACOLOR(224, 224, 224, 1);
    if(self.view.frame.size.height  == 480.0)
        intro.pageControlY = 25.0;
    else if(self.view.frame.size.height == 568.0)
        intro.pageControlY = 30.0;
    else
        intro.pageControlY = 40.0;
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.0];
    
}
#pragma mark ---  EAIntroDelegate
- (void)introDidFinish {
   
    yongaiVC = [[UIStoryboard storyboardWithName:@"Yongai" bundle:nil] instantiateViewControllerWithIdentifier:@"YongaiYabbarController"];
    yongaiVC.tabBar.barTintColor = RGBACOLOR(66,59,63, 1);
    yongaiVC.tabBar.tintColor = beijing;
   
   
     [self.navigationController pushViewController:yongaiVC animated:YES];
    
}


@end
