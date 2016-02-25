//
//  RootViewController.m
//  Yongai
//
//  Created by arron on 14/11/10.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "RootViewController.h"
#import "LoginNavViewController.h"

@interface RootViewController ()
{
    BOOL bShowLogin;
}
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BubbleNavigationController"];
    self.leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftViewController"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideTabBarWithAnimationDuration:) name:Notify_HideBottom object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTabBarWithAnimationDuration:) name:Notify_ShowBottom object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLeft) name:Notify_showLeftView object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showRootView:) name:Notify_showRootView object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoginView) name:Notify_showLoginView object:nil];
    
    // 关闭手势
    [self setEnableGesture:NO];
}
- (void)showLeft
{
    [self showLeftController:YES];
}


// 登录
-(void)showLoginView
{
    bShowLogin = YES;
    LoginNavViewController *loginVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNavSB"];
    
    [self presentViewController:loginVC animated:YES completion:nil];
}


-(void)showRootView:(NSNotification *)notification
{
    NSNumber *number = [notification object];
    [self showRootController:number.boolValue];
}

//显示TabBar通用方法
- (void)showTabBarWithAnimationDuration:(NSNotification*)notifaction
{
    if (self.tabBarController.tabBar.hidden == NO)
    {
        return;
    }
    UIView *contentView;
    if ([[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
        
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    
    else
        
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = NO;
}

//隐藏TabBar通用方法
- (void)hideTabBarWithAnimationDuration:(NSNotification*)notifaction
{
        if (self.tabBarController.tabBar.hidden == YES) {
            return;
        }
        UIView *contentView;
        if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
            contentView = [self.tabBarController.view.subviews objectAtIndex:1];
        else
            contentView = [self.tabBarController.view.subviews objectAtIndex:0];
        contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
        self.tabBarController.tabBar.hidden = YES;
}

@end
