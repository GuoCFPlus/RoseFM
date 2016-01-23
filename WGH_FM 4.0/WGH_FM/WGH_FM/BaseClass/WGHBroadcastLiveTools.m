//
//  WGHBroadcastLiveTools.m
//  WGH_FM
//
//  Created by lanou3g on 16/1/21.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHBroadcastLiveTools.h"

@implementation WGHBroadcastLiveTools

static WGHBroadcastLiveTools *bt = nil;
+ (instancetype)shareBroadcastLivePlayer {
    
    if (bt == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            bt = [[WGHBroadcastLiveTools alloc] init];
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
                NSLog(@"不知道什么错误");
                break;
            case AVPlayerItemStatusFailed:
                NSLog(@"准备失败");
                break;
            case AVPlayerItemStatusReadyToPlay:
                NSLog(@"准备成功,开始播放");
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
    //[self.delegate getCurTime:[self formatTime:[self getCurrentTime]] Totle:[self formatTime:[self getTotleTime]] Progress:[self getProgress]];
}


//进度时间与总时间
-(NSDictionary *)getTimeWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"currutTime":@"00:00",@"totleTime":@"00:00",@"progress":@"0.1",@"maxProgress":@"100.0"}];
    
    //建两种时间转换格式
    //05:30-07:00
    NSDateFormatter *dfm=[[NSDateFormatter alloc]init];
    [dfm setDateFormat:@"HH:mm"];
    NSDateFormatter *dfm1=[[NSDateFormatter alloc]init];
    [dfm1 setDateFormat:@"yyyyMMdd-HH:mm:ss"];
    //获取0时区时间
    NSDate *dateNow=[NSDate dateWithTimeIntervalSinceNow:0];
    //获取北京时间
    NSDate *dateNow1=[NSDate dateWithTimeIntervalSinceNow:8*3600];
    //0时区时间转化字符串
    //时间类型转成字符串类型自动自动加上当前时区的时间差
    NSString *strNow=[dfm1 stringFromDate:dateNow];
    //截取前10个字符  20151017-
    NSString *pinjie = [strNow substringToIndex:9];
    
    //取model中节目开始时间和结束时间字符串,格式为HH:mm
    NSString *startDatem1=[NSString stringWithFormat:@"%@%@:00",pinjie,startTime];
    NSString *endDatem1=[NSString stringWithFormat:@"%@%@:00",pinjie,endTime];
    //装换成时间
    NSDate *startDate1=[dfm1 dateFromString:startDatem1];
    NSDate *startDate2=[NSDate dateWithTimeInterval:8*3600 sinceDate:startDate1];
    NSDate *endDate1=[dfm1 dateFromString:endDatem1];
    NSDate *endDate2=[NSDate dateWithTimeInterval:8*3600 sinceDate:endDate1];
    //获取节目开始时间和结束时间和当前时间到1970时间的时间差
    NSTimeInterval nowto1970=[dateNow1 timeIntervalSince1970]*1;
    NSTimeInterval startto1970=[startDate2 timeIntervalSince1970]*1;
    NSTimeInterval endto1970=[endDate2 timeIntervalSince1970]*1;
    //  如果当前时间大于开始时间,小于结束时间,取当前model为view赋值
    if ((nowto1970 - startto1970 > 0)&&(endto1970 - nowto1970 >0)) {
        
        //节目总时间
        float aan=(endto1970 - startto1970);
        //将节目总时间转化成标准字符串格式 例3:20:05
        [dict setValue:[self formatTime:aan] forKey:@"totleTime"] ;
        
        //进度条最大值
        [dict setValue:[NSString stringWithFormat:@"%f",aan] forKey:@"maxProgress"];
        
        //北京时间
        NSDate *dateNown=[NSDate dateWithTimeIntervalSinceNow:8*3600];
        //当前北京时间到1970年的时间段
        NSTimeInterval nowto1970n=[dateNown timeIntervalSince1970]*1;
        float aa=(nowto1970n - startto1970);
        //将节目当前时间转化成标准字符串格式 例3:20:05
        [dict setValue:[self formatTime:aa] forKey:@"currutTime"];
        //进度条当前时间
        [dict setValue:[NSString stringWithFormat:@"%f",nowto1970n - startto1970] forKey:@"progress"];
        
    }
    return dict;
    
}



//将float类型的时间转化格式
-(NSString *)formatTime:(float)time{
    //不到一个小时
    if (time <= 3600) {
        int min=(int)time/60;
        int sec=(int)time%60;
        NSString *timeS = [NSString stringWithFormat:@"%02d:%02d",min,sec];
        return timeS;
    }else{
        //大于一个小时
        int hour = (int)time/3600;
        int min = (int)(time-hour*3600)/60;
        int sec = (int)(time - hour*3600-min*60);
        NSString *timeS=[NSString stringWithFormat:@"%02d:%02d:%02d",hour,min,sec];
        return timeS;
    }
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



@end
