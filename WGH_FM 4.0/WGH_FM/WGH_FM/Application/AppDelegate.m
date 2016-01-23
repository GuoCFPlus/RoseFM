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
    
    //APPID: 91gXOwDY7NOodNUu0mYDl8TQ-gzGzoHsz
    //APP KEY: w5jGaaQSkIQQHeSS8qWMxNS8
    
    [AVOSCloud setApplicationId:@"91gXOwDY7NOodNUu0mYDl8TQ-gzGzoHsz"
                      clientKey:@"w5jGaaQSkIQQHeSS8qWMxNS8"];
//    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
//    //如果使用美国站点，请加上这行代码
//    [AVOSCloud useAVCloudUS];
    
    
    
    
    
    
    // 友盟分享
    [UMSocialData setAppKey:@"569f6b73e0f55afdab001161"];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self.window setRootViewController:[WGHTabBarViewController new]];
    
    
    if (![UserDefaults boolForKey:@"is_scroll"]) {
        [self.window setRootViewController:[MainScrollViewController new]];
        
        [UserDefaults setBool:YES forKey:@"is_scroll"];
    }
    
    
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    // 远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    
    
    
    
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else{
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
    
    return YES;
}

#pragma mark本地通知代理
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification{
    // 在此时设置解析notification，并展示提示视图
    NSString * message = [notification.userInfo valueForKey:@"hurry"];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"主人" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    
    // 既然已经查看了这个通知, 那么气泡就要减少一个
    NSInteger badge = [[UIApplication  sharedApplication] applicationIconBadgeNumber];
    badge --;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    
    // 取消通知
    [WGHSettingTableViewController cancelLocalNotificationWithKey:@"hurry"];
    
    
}



//禁止横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}





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
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
