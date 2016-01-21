//
//  WGHTabBarViewController.m
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/13.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHTabBarViewController.h"

@interface WGHTabBarViewController ()<WGHTabBarDelegate>

@end

@implementation WGHTabBarViewController


// tabbar
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    WGHFindMainTableViewController *findVC = [[WGHFindMainTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self addChildVc:findVC title:@"发现" image:[UIImage imageNamed:@"wgh_tabbar_find×32"] selectedImage:[UIImage imageNamed:@"wgh_tabbar_find×32_1"]];
    
    
    WGHBroadcastMainTableViewController *broadcastVC =[[WGHBroadcastMainTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self addChildVc:broadcastVC title:@"广播" image:[UIImage imageNamed:@"wgh_tabbar_guangbo×32"] selectedImage:[UIImage imageNamed:@"wgh_tabbar_guangbo×32_1"]];
    
    WGHHotListMainTableViewController *hotListVC = [[WGHHotListMainTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self addChildVc:hotListVC title:@"榜单" image:[UIImage imageNamed:@"wgh_tabbar_bangdan×32"] selectedImage:[UIImage imageNamed:@"wgh_tabbar_bangdan×32_1"]];
    
    
    WGHUserMainViewController *userVC = [[WGHUserMainViewController alloc] initWithStyle:UITableViewStyleGrouped];
    userVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"wgh_tabbar_user×32"] selectedImage:[UIImage imageNamed:@"wgh_tabbar_user×32_1"]];
    [self addChildViewController:userVC];
    
    WGHTabBar *tabBar = [[WGHTabBar alloc] init];
    
    tabBar.translucent = NO;
    tabBar.tintColor = [UIColor colorWithRed:1.000 green:0.300 blue:0.156 alpha:1.000];
    
    // 遵循协议
    tabBar.delegate = self;
    [self setValue:tabBar forKeyPath:@"tabBar"];
    
}

// 代理方法
- (void)tabBarDidClickCircleButton:(UIButton *)tabBar {
    
    
    NSLog(@"%s",__FUNCTION__);
    
}


- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
    // 设置子控制器的文字
    childVc.navigationItem.title = title;
    // 设置子控制器的图片
    childVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selectedImage];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    
    nav.navigationBar.tintColor = [UIColor colorWithRed:1.000 green:0.304 blue:0.156 alpha:1.000];
        
    [nav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:1.000 green:0.304 blue:0.156 alpha:1.000],UITextAttributeTextColor,[UIFont systemFontOfSize:18],UITextAttributeFont,nil]];
    
    nav.navigationBar.alpha = 0;
//    nav.navigationBar.translucent = NO;
    
    [self addChildViewController:nav];
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
