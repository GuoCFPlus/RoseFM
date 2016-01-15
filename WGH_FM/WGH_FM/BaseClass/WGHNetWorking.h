//
//  WGHNetWorking.h
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/14.
//  Copyright © 2016年 吴凯强. All rights reserved.
//
/// 获取网络状态  ***********
//***********************************
//***********************************
//***********************************
//***********************************
//***********************************
//***********************************
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WGHNetWorking : NSObject

+(instancetype)shareAcquireNetworkState;

- (void)acquireCurrentNetworkState:(void (^)(int result))block;

- (void)showPrompt;


@end
