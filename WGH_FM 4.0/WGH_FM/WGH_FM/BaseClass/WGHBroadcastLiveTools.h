//
//  WGHBroadcastLiveTools.h
//  WGH_FM
//
//  Created by lanou3g on 16/1/21.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@protocol WGHBroadcastLiveToolsDelegate <NSObject>

// 将当前播放时间, 播放进度, 总时间, 剩余时间..信息  返回给播放界面
// 外界实现这个方法的同时, 也将参数的值拿走了, 这样我们起到了"通过代理方法向外界传递值"的功能.
- (void)getCurTime:(NSString *)curTime Totle:(NSString *)totleTime Progress:(CGFloat)progress;

- (void)endOfPlay;

@end


@interface WGHBroadcastLiveTools : NSObject

+ (instancetype)shareBroadcastLivePlayer;

@property (weak, nonatomic) id<WGHBroadcastLiveToolsDelegate> delegate;


/**
 *  定时器
 */
@property (strong, nonatomic) NSTimer *timer;
/**
 *  本类中的播放器指针. 真正将音乐播放出声音的是这个对象, 我们当前类只是对其封装.
 */
@property (strong, nonatomic) AVPlayer *player;

/**
 *  播放音乐信息模型
 */
@property (strong, nonatomic) NSString *playerUrl;

/**
 *  准备播放
 */
- (void)audioPrePlay;
/**
 *  开始播放
 */
- (void)audioPlay;
/**
 *  暂停播放
 */
- (void)audioPause;

/**
 *  播放跳转
 *
 *  @param value 控制播放时间的slider的value参数
 */
- (void)seekTotimeWithValue:(CGFloat)value;

//获取时间总长
- (NSInteger)getTotleTime;
//获取播放时间
- (NSInteger)getCurrentTime;

- (CGFloat)getProgress;
- (void)openTimer;

//进度时间与总时间
-(NSDictionary *)getTimeWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;

@end
