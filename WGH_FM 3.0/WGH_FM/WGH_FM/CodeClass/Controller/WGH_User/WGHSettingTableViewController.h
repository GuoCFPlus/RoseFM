//
//  WGHSettingTableViewController.h
//  WGH_FM
//
//  Created by 韩明雨 on 16/1/20.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WGHSettingTableViewController : UITableViewController




/**
 *  生成并注册一个通知
 *
 *  @param alterTime 时间响应
 */
+ (void)registLocalNotification;

/**
 *  根据通知的key, 移除本地通知
 *
 *  @param key key值
 */
+ (void)cancelLocalNotificationWithKey:(NSString *)key;



@end
