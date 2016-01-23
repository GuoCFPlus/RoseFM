//
//  WGHaudioPlayerViewController.m
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/19.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHaudioPlayerViewController.h"

@interface WGHaudioPlayerViewController ()<WGHBroadcastToolsDelegate,WGHNavigationViewDelegete,UITextViewDelegate>

@property(strong,nonatomic)NavigationView *navigationView;


@property(strong,nonatomic)UIScrollView *titleScroll;
@property(strong,nonatomic)UILabel *titleLabel;


@property(strong,nonatomic)WGHAlbumListModel *model;

@property(strong,nonatomic)UIImageView *backImgView;
/**
 *  时间进度条
 */
@property(strong,nonatomic) UISlider *time_slider;

@property(strong,nonatomic) UIImageView *player_image;

/**
 *  音乐播放时间
 */
@property(strong,nonatomic) UILabel *begin_time;
/**
 *  音乐时间总长
 */
@property(strong,nonatomic) UILabel *end_time;
/**
 *  开始播放
 */
@property(strong,nonatomic) UIButton *begin_play;

/**
 *  上一首
 */
@property(strong,nonatomic) UIButton *previous_track;

/**
 *  下一首
 */
@property(strong,nonatomic) UIButton *next_track;

/**
 *  播放列表
 */
@property(strong,nonatomic) UIButton *playerList;

/**
 *  播放模式
 */
@property(strong,nonatomic) UILabel *playListLabel;
/**
 *  播放历史
 */
@property(strong,nonatomic) UIButton *playHistory;
/**
 *  收藏
 */
@property(strong,nonatomic) UIButton *collectButton;
/**
 *  评论
 */
@property(strong,nonatomic) UIButton *commentButton;
/**
 *  分享
 */
@property(strong,nonatomic) UIButton *shareButton;
/**
 *  弹幕
 */
@property(strong,nonatomic) UISwitch *barrageSwitch;

/**
 *  发送消息
 */
@property(strong,nonatomic) UITextView *textView;


@property(strong,nonatomic) UIView *commentView;

@property(assign,nonatomic)float move;
@end

@implementation WGHaudioPlayerViewController

static WGHaudioPlayerViewController *ap = nil;

+ (instancetype)shareAudioPlayer {
    
    if (ap == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            ap = [[WGHaudioPlayerViewController alloc] init];
            
        });
    }
    return ap;
    
}


// navigationView代理方法
- (void)moveLabel {
    
    self.move--;
    
    self.navigationView.label.x = self.move;
    if (ABS(self.move) > self.navigationView.label.width) {
        self.move = 0 - self.move - (self.navigationView.label.width - 0.65 *kScreenWidth);
    }
    
}

- (void)downBtnClick {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
// 登录
- (void)loginAciton {
    
    
    WGHLandingViewController *loginVC = [WGHLandingViewController new];
    UINavigationController *loginNC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [loginNC.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:1.000 green:0.304 blue:0.156 alpha:1.000],UITextAttributeTextColor,[UIFont systemFontOfSize:18],UITextAttributeFont,nil]];
    loginNC.navigationBar.tintColor = [UIColor colorWithRed:1.000 green:0.304 blue:0.156 alpha:1.000];
    loginNC.navigationBar.alpha = 0;
    
    [self presentViewController:loginNC animated:YES completion:nil];
}
// 点赞
- (void)collectButtonAction {
    
    if ([[WGHLeanCloudTools sharedLeanUserTools] isLoggedIn]) {
        // 数据库收藏
        
        
        
    }else {
        [self loginAciton];
    }
    
}

// 评论
- (void)commentButtonAction {
    
    if ([[WGHLeanCloudTools sharedLeanUserTools] isLoggedIn]) {
        // 发送消息
        NSLog(@"发送");
        
        
        
        
        
    }else {
        [self loginAciton];
    }
    
    
}
#pragma -------TextView 代理方法-------

//将要开始编辑
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    [UIView animateWithDuration:0.2 animations:^{

        self.commentView.y = kScreenHeight - 295;
    }];
    
    return YES;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.2 animations:^{
        
        self.commentView.y = kScreenHeight - 50;
    }];
}

// 社会化分享
- (void)shareAction {
    
    if (self.model == nil) {
        return;
    }
    
    NSString *title = self.model.title;
    NSString *downUrl = self.model.downloadAacUrl;
    NSString *playUrl = self.model.playPathAacv164;
    
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"569f6b73e0f55afdab001161"
                                      shareText:[NSString stringWithFormat:@"《%@》\n\n下载地址: %@\n %@",title,downUrl,playUrl]
                                     shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.coverSmall]]]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToQzone,UMShareToEmail,UMShareToKakaoTalk,nil]
                                       delegate:nil];
    
}



#define kBackImgHeight (kScreenHeight/2+64)
#define kPlayImgWidth (kScreenHeight/2-kGap_40)
#define kCenterHeight kScreenHeight/6
#define kSwitchHeight kScreenHeight/15
- (void)viewDidLoad {
    [super viewDidLoad];
    self.move = 0;
    
    self.view.backgroundColor = [UIColor colorWithRed:0.850 green:0.850 blue:0.850 alpha:1.000];
    
    // 设置代理
    [WGHBroadcastTools shareBroadcastPlayer].delegate = self;
    
    
    // 背景图
    self.backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBackImgHeight)];
    [self.view addSubview:self.backImgView];
    

    //添加模糊背景
    //模糊背景
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = self.backImgView.frame;
    [self.view addSubview:effectView];
    
    self.player_image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kPlayImgWidth, kPlayImgWidth)];
    self.player_image.center = CGPointMake(kScreenWidth/2, kBackImgHeight/2+22);
    self.player_image.image = [UIImage imageNamed:@"rotating"];
    self.player_image.layer.cornerRadius = kPlayImgWidth/2;
    self.player_image.layer.masksToBounds = YES;
    [self.view addSubview:self.player_image];
    
    self.time_slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kGap_40)];
    self.time_slider.center = CGPointMake(kScreenWidth/2, kBackImgHeight);
    self.time_slider.minimumTrackTintColor = [UIColor orangeColor];
    self.time_slider.maximumTrackTintColor = [UIColor whiteColor];
    self.time_slider.minimumValue = 0;
    self.time_slider.maximumValue = 1;
    self.time_slider.value = 0;
    [self.time_slider addTarget:self action:@selector(time_sliderChange) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.time_slider];
    
    self.begin_time = [[UILabel alloc] initWithFrame:CGRectMake(kGap_10, kBackImgHeight-37, kGap_40, kGap_20)];
    self.begin_time.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:self.begin_time];
    
    self.end_time = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-kGap_50, kBackImgHeight-37, kGap_40, kGap_20)];
    self.end_time.font = [UIFont systemFontOfSize:12];
    self.end_time.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.end_time];
    
    
    //自定义导航栏
    self.navigationView = [[NavigationView alloc] initWithFrame:CGRectMake(0, kGap_20, kScreenWidth, 44) Text:self.model.title];
    self.navigationView.delegate = self;
    [self.view addSubview:self.navigationView];
    
    
    
    
    
    //播放/暂停按钮
    self.begin_play = [UIButton buttonWithType:UIButtonTypeSystem];
    self.begin_play.frame = CGRectMake(0, 0, kGap_30, kGap_30);
    self.begin_play.center = CGPointMake(kScreenWidth/2, kBackImgHeight+kCenterHeight);
    [self.begin_play setTintColor:[UIColor orangeColor]];
    
    [self.begin_play setImage:[UIImage imageNamed:@"wgh_tabbar_bofang×64"] forState:UIControlStateNormal];
    [self.begin_play setImage:[UIImage imageNamed:@"wgh_tabbar_bofang×64_h"] forState:UIControlStateHighlighted];
    
    [self.begin_play addTarget:self action:@selector(begin_playAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.begin_play];
    
    //上一首按钮
    self.previous_track = [UIButton buttonWithType:UIButtonTypeSystem];
    self.previous_track.frame = CGRectMake(0, 0, kGap_20, kGap_20);
    self.previous_track.center = CGPointMake(kScreenWidth/2-60, kBackImgHeight+kCenterHeight);
    [self.previous_track setTintColor:[UIColor orangeColor]];
    
    [self.previous_track setImage:[UIImage imageNamed:@"wgh_audio_previous"] forState:UIControlStateNormal];
    [self.previous_track setImage:[UIImage imageNamed:@"wgh_audio_previous_h"] forState:UIControlStateHighlighted];
    
    [self.previous_track addTarget:self action:@selector(previous_trackAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.previous_track];
    
    //下一首按钮
    self.next_track = [UIButton buttonWithType:UIButtonTypeSystem];
    self.next_track.frame = CGRectMake(0, 0, kGap_20, kGap_20);
    self.next_track.center = CGPointMake(kScreenWidth/2+60, kBackImgHeight+kCenterHeight);
    [self.next_track setTintColor:[UIColor orangeColor]];
    
    [self.next_track setImage:[UIImage imageNamed:@"wgh_audio_nextPlayer"] forState:UIControlStateNormal];
    [self.next_track setImage:[UIImage imageNamed:@"wgh_audio_nextPlayer_h"] forState:UIControlStateHighlighted];
    
    [self.next_track addTarget:self action:@selector(next_trackAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.next_track];
    
    // 播放列表
    self.playerList = [UIButton buttonWithType:UIButtonTypeSystem];
    self.playerList.frame = CGRectMake(0, 0, kGap_20, kGap_20);
    self.playerList.center = CGPointMake(kGap_30, kBackImgHeight+kCenterHeight-5);
    [self.playerList setTintColor:[UIColor orangeColor]];
    
    [self.playerList setImage:[UIImage imageNamed:@"wgh_audio_liebiao"] forState:UIControlStateNormal];
    [self.playerList addTarget:self action:@selector(playerMoshi) forControlEvents:UIControlEventTouchUpInside];
    self.playerList.tag = 101;
    [self.view addSubview:self.playerList];
    
    self.playListLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.playerList.frame), kGap_40, 15)];
    self.playListLabel.text = @"循环播放";
    self.playListLabel.textAlignment = NSTextAlignmentCenter;
    self.playListLabel.textColor = [UIColor grayColor];
    self.playListLabel.font = [UIFont systemFontOfSize:10];
    
    [self.view addSubview:self.playListLabel];
    
    
    // 播放历史
    self.playHistory = [UIButton buttonWithType:UIButtonTypeSystem];
    self.playHistory.frame = CGRectMake(0, 0, kGap_20, kGap_20);
    self.playHistory.center = CGPointMake(kScreenWidth-kGap_30, kBackImgHeight+kCenterHeight-5);
    [self.playHistory setTintColor:[UIColor orangeColor]];
    [self.playHistory setImage:[UIImage imageNamed:@"wgh_audio_lishi"] forState:UIControlStateNormal];
    [self.playHistory addTarget:self action:@selector(changePlayHistory) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playHistory];
    UILabel *dingshiLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-kGap_50, CGRectGetMaxY(self.playerList.frame), kGap_40, 15)];
    dingshiLabel.text = @"播放历史";
    dingshiLabel.textAlignment = NSTextAlignmentCenter;
    dingshiLabel.textColor = [UIColor grayColor];
    dingshiLabel.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:dingshiLabel];
    
    
    // 控制弹幕按钮
    self.barrageSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, kGap_40, kGap_30)];
    self.barrageSwitch.center = CGPointMake(kScreenWidth-kGap_40, kBackImgHeight+kSwitchHeight);
    self.barrageSwitch.tintColor = [UIColor colorWithRed:0.005 green:0.005 blue:0.005 alpha:0.2];
    self.barrageSwitch.thumbTintColor = [UIColor whiteColor];
    self.barrageSwitch.onTintColor = [UIColor orangeColor];
    self.barrageSwitch.on = [UserDefaults boolForKey:@"danmu"];
    
    [self.barrageSwitch addTarget:self action:@selector(openBarrage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.barrageSwitch];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kGap_40, kGap_30)];
    label.text = @"弹幕";
    label.textColor = [UIColor orangeColor];
    label.center = CGPointMake(kScreenWidth-85, kBackImgHeight+kSwitchHeight);
   [self.view addSubview:label];
    
    
    self.commentView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kGap_50, kScreenWidth, kGap_50)];
    self.commentView.backgroundColor = [UIColor colorWithRed:0.950 green:0.950 blue:0.950 alpha:0.5];
    [self.view addSubview:self.commentView];
    
    
    // 收藏按钮
    self.collectButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.collectButton.frame = CGRectMake(kGap_10, kGap_10, kGap_30, kGap_30);
    self.collectButton.tintColor = [UIColor orangeColor];
    [self.collectButton setImage:[UIImage imageNamed:@"wgh_audioplay_shoucang"] forState:UIControlStateNormal];
    [self.collectButton addTarget:self action:@selector(collectButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.commentView addSubview:self.collectButton];
    
    
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(45, kGap_10, kScreenWidth-120, kGap_30)];
    self.textView.delegate = self;
    [self.commentView addSubview:self.textView];
    
    
    // 评论按钮
    self.commentButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.commentButton.frame = CGRectMake(CGRectGetMaxX(self.textView.frame), kGap_10, kGap_30, kGap_30);
    self.commentButton.tintColor = [UIColor orangeColor];
    [self.commentButton setImage:[UIImage imageNamed:@"wgh_audioplay_pinglun"] forState:UIControlStateNormal];
    [self.commentButton addTarget:self action:@selector(commentButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.commentView addSubview:self.commentButton];
    
    
    // 分享按钮
    self.shareButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.shareButton.frame = CGRectMake(kScreenWidth-kGap_40, kGap_10, kGap_30, kGap_30);
    self.shareButton.tintColor = [UIColor orangeColor];
    [self.shareButton setImage:[UIImage imageNamed:@"wgh_audioplay_fenxiang"] forState:UIControlStateNormal];
    
    [self.shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [self.commentView addSubview:self.shareButton];
    
    
    
    //设置观察者
    [[WGHBroadcastTools shareBroadcastPlayer].player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    
    
    // 开始播放
    [self beginAudioPlayer];
    
}
- (void)openBarrage {
    
    [UserDefaults setBool:self.barrageSwitch.on forKey:@"danmu"];
}



#pragma mark ---观察者----
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"rate"]) {
        if ([change[@"new"] floatValue] == 0) {
            [self.begin_play setImage:[UIImage imageNamed:@"wgh_tabbar_bofang×64"] forState:UIControlStateNormal];
            [self.begin_play setImage:[UIImage imageNamed:@"wgh_tabbar_bofang×64_h"] forState:UIControlStateHighlighted];
        }else {
            
            [self.begin_play setImage:[UIImage imageNamed:@"wgh_tabbar_zanting×64"] forState:UIControlStateNormal];
            [self.begin_play setImage:[UIImage imageNamed:@"wgh_tabbar_zanting×64_h"] forState:UIControlStateHighlighted];
        }
    }
}

// 代理方法  获取总时间  播放进度
- (void)getCurTime:(NSString *)curTime Totle:(NSString *)totleTime Progress:(CGFloat)progress {
    // 时间进度
    self.begin_time.text = curTime;
    // 时间总长
    self.end_time.text = totleTime;
    self.time_slider.value = progress;
    
    self.player_image.transform = CGAffineTransformRotate(self.player_image.transform, M_1_PI/20);
    
    
}

- (void)endOfPlay {
    // 播放结束后  执行此方法   根据当前的播放模式判断该如何播放
    if (self.playerList.tag == 101) {
        [self next_trackAction];
    }else if(self.playerList.tag == 102){
        [self randomPlay];
    }else if (self.playerList.tag == 103) {
        [[WGHBroadcastTools shareBroadcastPlayer] audioPrePlay];
    }
    
}


- (void)beginAudioPlayer {
    // 播放前  获取当前的网络状态
    
    [[WGHNetWorking shareAcquireNetworkState] acquireCurrentNetworkState:^(int result) {
        if (result == 2) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self audioPlay];
                
            });
        }else if (result == 0){
            [[WGHNetWorking shareAcquireNetworkState] showPrompt];
        }else {
            // 非 wifi  网络状态下  不播放 (打开 非wifi状态下播放按钮  即可播放)
            if ([UserDefaults boolForKey:@"switch"]) {
                [[WGHNetWorking shareAcquireNetworkState] showNetworkErrors];
            }else {
                [self audioPlay];
            }
        }
    }];
    
}

// 播放
- (void)audioPlay {
    
    // 广播界面如果正在播放  就先暂停
    if ([WGHBroadcastLiveTools shareBroadcastLivePlayer].player.rate != 0) {
        [[WGHBroadcastLiveTools shareBroadcastLivePlayer] audioPause];
    }
    // 如果本界面暂停播放  重新开始开放
    if ([WGHBroadcastTools shareBroadcastPlayer].player.rate == 0) {
        [[WGHBroadcastTools shareBroadcastPlayer] audioPlay];
    }
    
    self.model = self.dataArray[self.indext];
    if ([self.model.playPathAacv164 isEqualToString:[WGHBroadcastTools shareBroadcastPlayer].playerUrl]) {
        return;
    }
    
    
    [WGHBroadcastTools shareBroadcastPlayer].playerUrl = self.model.playPathAacv164;
    [[WGHBroadcastTools shareBroadcastPlayer] audioPrePlay];
    [self refreshMessage];
    
}

// 刷新数据信息
- (void)refreshMessage {
    
    self.move = 0;
    self.navigationView.string = self.model.title;
    [self.backImgView sd_setImageWithURL:[NSURL URLWithString:self.model.coverSmall]];
    
}


#pragma mark  ----开始播放按钮---
- (void)begin_playAction {
    
    if ([WGHBroadcastTools shareBroadcastPlayer].player.rate == 0) {
        // 播放
        [[WGHBroadcastTools shareBroadcastPlayer] audioPlay];
        
    }else {
        // 暂停
        [[WGHBroadcastTools shareBroadcastPlayer] audioPause];
    }
}
#pragma mark ------上一首按钮-----
- (void)previous_trackAction {
    
    if (self.indext == 0) {
        self.indext = self.dataArray.count - 1;
    }else {
        self.indext--;
    }
    
    [self beginAudioPlayer];
    
}
#pragma mark ------下一首按钮-----
- (void)next_trackAction {
    
    if (self.indext == self.dataArray.count-1) {
        self.indext = 0;
    }else {
        self.indext ++;
    }
    
    [self beginAudioPlayer];
    
}
#pragma mark ------随机播放-----
//随机播放
- (void)randomPlay {
    
    self.indext = arc4random()%(self.dataArray.count-1 - 0 + 0)+0;
    [self beginAudioPlayer];
    
}

- (void)time_sliderChange {
    // 控制时间slider
    [[WGHBroadcastTools shareBroadcastPlayer] seekTotimeWithValue:self.time_slider.value];
    
}

// 播放模式
- (void)playerMoshi {
    
    if (self.playerList.tag == 101) {
        [self.playerList setImage:[UIImage imageNamed:@"suijibofang"] forState:UIControlStateNormal];
        self.playListLabel.text = @"随机播放";
        self.playerList.tag = 102;
    }else if (self.playerList.tag == 102) {
        [self.playerList setImage:[UIImage imageNamed:@"danquxunhuan"] forState:UIControlStateNormal];
        self.playListLabel.text = @"单曲循环";
        self.playerList.tag = 103;
    }else if (self.playerList.tag == 103) {
        [self.playerList setImage:[UIImage imageNamed:@"wgh_audio_liebiao"] forState:UIControlStateNormal];
        self.playListLabel.text = @"循环播放";
        self.playerList.tag = 101;
    }
    
}


#pragma mark ----timer 相关
- (void)timerStopAction
{
    if ([WGHBroadcastTools shareBroadcastPlayer].player.rate != 0) {
        [[WGHBroadcastTools shareBroadcastPlayer] audioPause];
    }
    
}
#pragma mark ----定时关闭  退出程序

- (void)exitApplication {
    
    [UIView beginAnimations:@"exitApplication" context:nil];
//    self.tab.tabBar.hidden = YES;
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:(UIViewAnimationTransitionNone) forView:[UIApplication sharedApplication].delegate.window cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    [UIApplication sharedApplication].delegate.window.bounds = CGRectMake(0, 0, 0, 0);
    [UIView commitAnimations];
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
    
}

- (void)timerChangeAction:(NSTimer *)aTimer
{
    
    self.timerTime = _timerTime - 1;
    if (_timerTime <= 0) {
        _timerTime = 0;
        [self exitApplication];
        [aTimer invalidate];
        aTimer = nil;
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"timerOn"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"定时关闭时间已到" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        });
    }
}




// 跳转播放历史界面
- (void)changePlayHistory {
    
    
    
}




- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    [self beginAudioPlayer];
    
}
- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}
// 后台播放
-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
    
    if (event.type == UIEventTypeRemoteControl) {
        if (event.subtype == UIEventSubtypeRemoteControlPlay || event.subtype == UIEventSubtypeRemoteControlStop) {
            [self begin_playAction];
        }else if (event.subtype == UIEventSubtypeRemoteControlPreviousTrack) {
            [self previous_trackAction];
        }else if (event.subtype == UIEventSubtypeRemoteControlNextTrack){
            [self next_trackAction];
        }
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
