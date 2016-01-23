//
//  WGHBroadcastTools.m
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/19.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHBroadcastTools.h"

@implementation WGHBroadcastTools


static WGHBroadcastTools *bt = nil;
+ (instancetype)shareBroadcastPlayer {
    
    if (bt == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            bt = [[WGHBroadcastTools alloc] init];
        });
    }
    
    return bt;
}

//重写init方法
// 这里为什么要重写init方法呢?
// 因为,我们应该得到 "某首歌曲播放结束" 这一事件,之后由外界来决定"播放结束之后采取什么操作".
// AVPlayer并没有通过block或者代理向我们返回这一状态(事件),而是向通知中心注册了一条通知(AVPlayerItemDidPlayToEndTimeNotification),我们也只有这一条途径获取播放结束这一事件.
// 所以,在我们创建好一个播放器时([[AVPlayer alloc] init]),应该立刻为通知中心添加观察者,来观察这一事件的发生.
// 这个动作放到init里,最及时也最合理.
- (instancetype)init
{
    self = [super init];
    if (self) {
        _player = [[AVPlayer alloc] init];
        //通知中心
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endOfPlay:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];;
        
        
    }
    return self;
}
// 播放结束后的方法,由代理具体实现行为.
- (void)endOfPlay:(NSNotification *)sender {
    // 为什么要先暂停一下呢?
    // 看看 musicPlay方法, 第一个if判断,你能明白为什么吗?
    [self audioPause];
    [self.delegate endOfPlay];
    
}




//准备播放  我们在外部调用播放器播放时,不会调用"直接播放",而是调用这个"准备播放",当它准备好时,会直接播放.
- (void)audioPrePlay {
    // 通过下面的逻辑,只要AVPlayer有currentItem,那么一定被添加了观察者.
    // 所以上来直接移除之.
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    // 根据传入的URL(MP3歌曲地址),创建一个item对象
    // initWithURL的初始化方法建立异步链接准备. 完成准备之后, 会修改自身内部的属性status. 所以, 我们需要观察该属性, 当它的状态变为 AVPlayerItemStatusReadyToPlay时, 我们便能得知,播放器已经准备好, 可以播放了.
    
    // 创建一个新的 AVPlayerItem, 并且对其添加观察者, 观察其准备状态.
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.playerUrl]];
    // 要掌握观察者啊!!!!!! 这个东西其实很好用!!!!!!!!
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    // 用新创建的item,替换AVPlayer之前的item.新的item是带着观察者的哦.
    [self.player replaceCurrentItemWithPlayerItem:item];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    // 这里的if判断是意思呢?
    // 71行中, 我们使用当前对象作为status的观察者, 事实上, 当前对象self, 也能观察其他对象的属性, 但是, 一旦它观察的任意一个属性发生了变化, 都会走同一个代理方法(本方法). 所以你不知道到底是那个属性发生了变化. 好在, 该方法的keyPath表示是哪个属性发了变化.
    if ([keyPath isEqualToString:@"status"]) {
        // 观察的属性发生了变化, 会将变化前后的值, 封装成字典change作为参数传给我们, 我们从字典中根据key值@"new" 就能拿到新值. 之后来判断一下 这个新值是什么就可以了.
        switch ([[change valueForKey:@"new"] integerValue]) {
            case AVPlayerItemStatusUnknown:
                DLog(@"不知道什么错误");
                break;
            case AVPlayerItemStatusFailed:
                DLog(@"准备失败");
                break;
            case AVPlayerItemStatusReadyToPlay:
                DLog(@"准备成功,开始播放");
                [self audioPlay];
                break;
            default:
                break;
        }
    }
}

//开始播放
- (void)audioPlay {
    // 如果计时器已经存在了, 说明已经在播放中, 直接返回.
    // 对于已经存在的计时器,只有musicPause方法才会使之停止和注销.
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    // 如果计时器已经存在了, 说明已经在播放中, 直接返回.
    // 对于已经存在的计时器,只有musicPause方法才会使之停止和注销.
    [self.player play];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    
}
//定时器方法
- (void)timerAction {
    
    //将当前播放时间,总时间和进度返回
    // 重点!!!
    // 计时器的处理方法中, 不断调用协议中的代理方法, 让它的代理执行方法, 同时将播放进度返回出去.
    // 一定要掌握这种形式.
    // "不停的将当前播放时间和总时间和进度返回出去."
    [self.delegate getCurTime:[self intToString:[self getCurrentTime]] Totle:[self intToString:[self getTotleTime]] Progress:[self getProgress]];
    
    
}

- (NSString *)intToString:(NSInteger)integer {
    
    return  [NSString stringWithFormat:@"%02d:%02d",(int)integer/60,(int)integer%60];
}


//暂停播放
- (void)audioPause {
    
    [self.timer invalidate];
    self.timer = nil;
    
    [self.player pause];
    
}

//播放跳转
- (void)seekTotimeWithValue:(CGFloat)value {
    
    [self audioPause];
    [self.player seekToTime:CMTimeMake(value * [self getTotleTime], 1) completionHandler:^(BOOL finished) {
        if (finished == YES) {
            [self audioPlay];
        }
        
    }];
    
}



//获取时间总长
- (NSInteger)getTotleTime {
    // currentItem的duration属性是一个结构体, 里面记录了歌曲时长等信息.
    // 但是, 这个时长并不是直接以秒数的方式返回.
    // 我们需要从结构体中拿出value和timescale变量, 做除运算便可得到总时长.
    CMTime totleTime = [self.player.currentItem duration];
    if (totleTime.timescale == 0) {
        return 1;
    }else {
        
        return totleTime.value / totleTime.timescale;
        
    }
}

//获取当前播放时间
- (NSInteger)getCurrentTime {
    
    if (self.player.currentItem) {
        // 用value/scale,就是AVPlayer计算时间的算法. 它就是这么规定的.
        // 下同.
        return self.player.currentTime.value / self.player.currentTime.timescale;
    }else {
        return 0;
    }
}

// 当前播放进度(0-1)
- (CGFloat)getProgress {
    // 当前播放时间 / 播放总时间, 得到一个0-1的进度百分比即可.
    // 注意类型, 两个整型做除, 得到仍是整型. 所以要强转一下.
    return (CGFloat)[self getCurrentTime] / (CGFloat)[self getTotleTime];
    
}


- (void)openTimer {
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
}


//播放录音
- (void)playRecordWithPath:(NSString *)path {
    //  如果当前正在播放音乐，把播放监听移除
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    // 根据URL创建AVPlayerItem对象
    NSURL *url = [NSURL fileURLWithPath:path];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:url];
    //给playerItem添加观察者
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    // 根据给定的item，替换当前播放的音乐
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
}


@end
