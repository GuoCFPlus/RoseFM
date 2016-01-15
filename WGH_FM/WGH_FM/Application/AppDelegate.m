//
//  AppDelegate.m
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/13.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self.window setRootViewController:[WGHTabBarViewController new]];
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"is_scroll"]) {
        [self.window setRootViewController:[MainScrollViewController new]];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"is_scroll"];
    }
    
    
//    // Override point for customization after application launch.
//    //初始化Reachability对象
//    Reachability *reachability = [Reachability reachabilityForInternetConnection];
//    //判断网络状态
//    if ([reachability currentReachabilityStatus] == NotReachable) {
//        NSLog(@"没有网络，不去做数据请求");
//    }
//    else if([reachability currentReachabilityStatus] == ReachableViaWiFi){
//        NSLog(@"当前状态是wifi");
//    }
//    //开启向通知中心发送网络状态改变后的通知
//    [reachability startNotifier];
//    //从通知中心观察名为：kReachabilityChangedNotification的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatusChanged:) name:kReachabilityChangedNotification object:nil];
    
    
    
    
    return YES;
}

//改变事件
//-(void)netStatusChanged:(NSNotification *)sender{
//    
//    DLog("改变");
//    
//}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
