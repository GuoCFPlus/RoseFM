//
//  WGHNetWorking.m
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/14.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHNetWorking.h"

@interface WGHNetWorking ()<UIAlertViewDelegate>


@end

static WGHNetWorking *nw = nil;
@implementation WGHNetWorking


+(instancetype)shareAcquireNetworkState {
    
    if (nw == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            nw = [[WGHNetWorking alloc] init];
        });
    }
    return nw;
}
// 获取当前网络状态
- (void)acquireCurrentNetworkState:(void (^)(int))block {
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            // 无网络
            block(0);
        }else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
            // wifi
            block(2);
            
        }else if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
            // 移动网络
            block(1);
        }else {
            // 未知网络
            block(-1);
        }
    }];
}


// 设置无网络弹窗

- (void)showPrompt {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前无网络,检查后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}


- (void)showNetworkErrors {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"非WIFI网络,确定要播放" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // 如果点击确定添加
    if (buttonIndex == 0) {
        [UserDefaults setBool:YES forKey:@"switch"];
    }
    
}





@end
