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
//下载
@property (nonatomic,strong)AFHTTPRequestOperation *downloadOP;
//蒙版
@property (nonatomic,strong)MaskView *maskView;
//音效
@property (nonatomic,assign)SystemSoundID soundID;

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

@property(strong,nonatomic) NSTimer *myTimer;

@property(strong,nonatomic) UIAlertController *alertController;

@property(assign,nonatomic)float move;

// 发送消息 定时器
@property(strong,nonatomic)NSTimer *sendMessageTimer;
// 消息数组
@property(nonatomic,strong)NSMutableArray * messageArrag;

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
    
    [[WGHChatRoom shareChatRoomHandle] logOut:nil];
    [self.sendMessageTimer invalidate];
    self.sendMessageTimer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)downLoadBtnClick {
    
    // 下载按钮
    [[WGHNetWorking shareAcquireNetworkState] acquireCurrentNetworkState:^(int result) {
        
        if (result == 2) {
            
            [self beginDownLoad];
            
        }else if (result == 0) {
            
            [[WGHNetWorking shareAcquireNetworkState] showPrompt];
            return;
            
        }else {
            if ([UserDefaults boolForKey:@"switch"] == YES) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"当前网络是非WIFI,确定要下载吗" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alert animated:YES completion:nil];

                UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self beginDownLoad];
                }];
                [alert addAction:cancleAction];
                [alert addAction:defaultAction];
                
            }else {
                [self beginDownLoad];
            }
        }
    }];
}


//开始下载
- (void)beginDownLoad {
    
    if (![[WGHLeanCloudTools sharedLeanUserTools] isLoggedIn]) {
        
        [self loginAciton];
        return;
    }
    
    if (self.model.downloadAacUrl == nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"抱歉,无该歌曲下载地址" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancleAction];
        //弹出
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    
    NSString * DocumentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString * dataBasePath = [DocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",[[WGHLeanCloudTools sharedLeanUserTools] user]]];
    //单例方法
    DataBaseTool * db = [DataBaseTool shareDataBase];
    //打开
    [db connectDB:dataBasePath];
    
    //打开数据库,看数据库中有没有这首歌,如果有就不可以下载了
    
    NSArray *updownArray = [db selectAllDownload:@"1=1"];
    for (WGHAlbumListModel *model in updownArray) {
        if ([model.playPathAacv164 isEqualToString:self.model.playPathAacv164]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"本歌曲已经下载咯,请勿重复下载!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:cancleAction];
            //弹出
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
    }
    
    CATransition *tran = [CATransition animation];
    tran.duration = 1.0;
    self.maskView.hidden = NO;
    tran.type = @"oglFlip";
    [self.maskView.layer addAnimation:tran forKey:nil];
    
    //下载地址
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *videoPath = [NSString stringWithFormat:@"%@/%@.aac",path,self.model.title];
    DLog(@"===============%@",videoPath);
    
    
    
    //下载
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.model.downloadAacUrl]];
    self.downloadOP = [[AFHTTPRequestOperation alloc] initWithRequest:downloadRequest];
    self.downloadOP.outputStream = [NSOutputStream outputStreamToFileAtPath:videoPath append:NO];
    //下载
    __weak typeof(self)temp = self;
    [self.downloadOP setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//        temp.view.userInteractionEnabled = NO;
        temp.navigationView.moreBtn.enabled = NO;
        CGFloat progress = ((float)totalBytesRead) / totalBytesExpectedToRead;
        [temp.maskView.progressView setProgress:progress animated:YES];
        
    }];
    //下载完成
    [self.downloadOP setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        temp.navigationView.moreBtn.enabled = NO;
//        temp.view.userInteractionEnabled = NO;
        temp.maskView.label.text = @"下载成功";
        
        //将下载的写入数据库
        [db insertDownloadName:temp.model];
        
//        AudioServicesPlaySystemSound(temp.soundID);
        
        [temp performSelector:@selector(maskViewHidden) withObject:nil afterDelay:2];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        temp.maskView.label.text = @"下载失败";
        
        [temp performSelector:@selector(maskViewHidden) withObject:nil afterDelay:2];
    }];
    
    //启动下载
    [self.downloadOP start];
    
    //关闭
    [db disconnectDB];
    
}

- (void)maskViewHidden
{
    CATransition *tran = [CATransition animation];
    tran.duration = 0;
    self.maskView.hidden = YES;
    tran.type = @"pageCurl";
    self.maskView.label.text = @"";
    [self.maskView.layer addAnimation:tran forKey:nil];
//    self.view.userInteractionEnabled = YES;
    self.navigationView.moreBtn.enabled = YES;
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
    
    
    if (self.model.downloadAacUrl == nil) {
        
        self.alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"该节目不支持收藏" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:self.alertController animated:YES completion:nil];
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeMyTimer) userInfo:nil repeats:YES];
        
        return;
    }
    
    
    
    if ([[WGHLeanCloudTools sharedLeanUserTools] isLoggedIn]) {
        // 数据库收藏
        NSString * DocumentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
         NSString * dataBasePath = [DocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",[[WGHLeanCloudTools sharedLeanUserTools] user]]];
        //单例方法
        DataBaseTool * db = [DataBaseTool shareDataBase];
        //打开
        [db connectDB:dataBasePath];
        
        int result = [db insertCollectMusicPlayer:self.model];
        
        if (result == 101) {
            
            self.alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"收藏成功" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:self.alertController animated:YES completion:nil];
            self.myTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(removeMyTimer) userInfo:nil repeats:YES];
            
        }else {
            
            self.alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"该节目已收藏过" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:self.alertController animated:YES completion:nil];
            self.myTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(removeMyTimer) userInfo:nil repeats:YES];
            
        }
        
        //关闭
        [db disconnectDB];
        
        
    }else {
        [self loginAciton];
    }
    
}

- (void)removeMyTimer {
    
    [self.myTimer invalidate];
    self.myTimer = nil;
    
    [self.alertController dismissViewControllerAnimated:YES completion:nil];
    
}

// 评论
- (void)commentButtonAction {
    
    if (self.model == nil) {
        return;
    }
    
    if ([[WGHLeanCloudTools sharedLeanUserTools] isLoggedIn]) {
        // 发送消息
        [[WGHChatRoom shareChatRoomHandle] sendMessage:[NSString stringWithFormat:@"%@: %@",[[WGHLeanCloudTools sharedLeanUserTools] user],self.textView.text] callback:^(BOOL success, NSError *error) {
            if (success) {
                DLog(@"发送消息成功");
                self.textView.text = nil;
            }else
            {
                DLog(@"发送消息失败");
            }
        }];
        
        AVIMMessage * message = nil;
        message = [AVIMMessage messageWithContent:[NSString stringWithFormat:@"%@: %@",[[WGHLeanCloudTools sharedLeanUserTools] user],self.textView.text]];
//        if (message.content.length >= 50) {
//            DLog(@"您太长了");
//            return;
//        }
        [_messageArrag addObject:message];
        
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

//点击return

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"])
    {
        //发送消息
        [self commentButtonAction];
        //关闭键盘
        //[textView resignFirstResponder];
        return NO;
    }
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
//    self.navigationView = [NavigationView shareNavigationViewWithFrame:CGRectMake(0, kGap_20, kScreenWidth, 44) Text:self.model.title];
//    self.navigationView.delegate = self;
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
    
    
    //蒙板
    self.maskView = [[MaskView alloc] initWithFrame:CGRectMake((kScreenWidth-200)/2,250, 200, 100)];
    _maskView.layer.cornerRadius = 15;
    _maskView.layer.masksToBounds = YES;
    _maskView.backgroundColor = [UIColor grayColor];
    _maskView.alpha = 0.7;
    _maskView.hidden = YES;
    [self.view addSubview:_maskView];
    
    
    
    //设置观察者
    [[WGHBroadcastTools shareBroadcastPlayer].player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    
    
    _messageArrag = [WGHChatRoom shareChatRoomHandle].messageArray;
    
    // 开始播放
    [self beginAudioPlayer];
    
}
- (void)openBarrage {
    
    [UserDefaults setBool:self.barrageSwitch.on forKey:@"danmu"];
    [self.messageArrag removeAllObjects];

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
    if (self.dataArray == NULL) {
        return;
    }
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
    
    
    self.model = self.dataArray[self.indext];
    if ([self.model.playPathAacv164 isEqualToString:[WGHBroadcastTools shareBroadcastPlayer].playerUrl]) {
        return;
    }
    
    if ([[WGHLeanCloudTools sharedLeanUserTools] isLoggedIn]) {
        
        if (self.model.downloadAacUrl != nil) {
            
            NSString * DocumentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
            NSString * dataBasePath = [DocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",[[WGHLeanCloudTools sharedLeanUserTools] user]]];
            //单例方法
            DataBaseTool * db = [DataBaseTool shareDataBase];
            //打开
            [db connectDB:dataBasePath];
            [db insertMusicPlayer:self.model];
            //关闭
            [db disconnectDB];
            
        }
    }
    
    if ([[WGHLeanCloudTools sharedLeanUserTools] isLoggedIn]) {
        // 创建聊天室
        [self creatLongConnection];
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
        //NSLog(@"%ld",(long)self.indext);
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
    
    WGHHistoryViewController *historyVC = [WGHHistoryViewController new];
    UINavigationController *historyNC = [[UINavigationController alloc] initWithRootViewController:historyVC];
    [historyNC.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:1.000 green:0.304 blue:0.156 alpha:1.000],UITextAttributeTextColor,[UIFont systemFontOfSize:18],UITextAttributeFont,nil]];
    historyNC.navigationBar.tintColor = [UIColor colorWithRed:1.000 green:0.304 blue:0.156 alpha:1.000];
    [self presentViewController:historyNC animated:YES completion:nil];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
     //如果本界面暂停播放  重新开始开放
    if ([WGHBroadcastTools shareBroadcastPlayer].player.rate == 0) {
        [[WGHBroadcastTools shareBroadcastPlayer] audioPlay];
    }
    
    [self beginAudioPlayer];
    
    [self creatLongConnection];
}
// 创建聊天室
- (void)creatLongConnection {
    
    
    // 1.创建长连接
    [[WGHChatRoom shareChatRoomHandle] connectServerWithClientID:[[WGHLeanCloudTools sharedLeanUserTools] user] :^(BOOL success, NSError *error) {
        if (success) {
            DLog(@"成功");
            [[WGHChatRoom shareChatRoomHandle] findChatRoomWithnameID:[self.model.trackId stringValue] callback:^(BOOL success, NSError *error) {
                if (success) {
                    NSLog(@"加入聊天室");
                   self.sendMessageTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(postMessage:) userInfo:self repeats:YES];
                }else
                {
                    NSLog(@"查找聊天室失败,创建");
                    [self creatChatRoom];
                }
            }];
            
        }
        else{
            NSLog(@"建立长连接失败");
        }
    }];
    
    
}

- (void)creatChatRoom {
    
    WGHLeanCloudTools *lc = [WGHLeanCloudTools sharedLeanUserTools];
    WGHChatRoom *cr = [WGHChatRoom shareChatRoomHandle];
    [cr createRoomWithClientID:[lc user] RoomName:[self.model.trackId stringValue] callback:^(BOOL success, NSError *error) {
        if (success) {
            // 可以进入聊天室
            NSLog(@"创建聊天室成功");
            self.sendMessageTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(postMessage:) userInfo:self repeats:YES];
        }else {
            NSLog(@"%@",error);
        }
    }];
    
}


// 将消息推送到屏幕上
-(void)postMessage:(NSTimer *)sender
{
    
    
    if ([UserDefaults boolForKey:@"danmu"] == NO) {
        return;
    }
    
//     DLog(@"%@",_messageArrag);
    for (int i = 0; i < _messageArrag.count; i++) {
        if (_messageArrag.count > 0) {
            
            //CGFloat barrageLen = [self p_WidthWithString:[_messageArrag[i] content] ];
            CGFloat barrageLen = [self p_WidthWithString:[_messageArrag[i] content]];
            long int Y = arc4random()%((int)(kScreenHeight/2 - kGap_50) - 64 + 1) + 64;
            UILabel * barrage = [[UILabel alloc] init];
            barrage.frame = CGRectMake(kScreenWidth,
                                       Y,
                                       barrageLen,
                                       30);
            barrage.text = [_messageArrag[i] content]; // 这里可以通过 label 来控制字体的大小颜色以及位置.
            CGFloat red = arc4random()%255/256.0;
            CGFloat green = arc4random()%255/256.0;
            CGFloat blue = arc4random()%255/256.0;
            barrage.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.000];
            barrage.font = [UIFont systemFontOfSize:17];
            [self.view addSubview:barrage];
            
            CGFloat speed = 85.;
            speed += random()%20;
            CGFloat time = (barrage.frame.size.width + kScreenWidth) / speed;
            
            [UIView animateWithDuration:time delay:0.f options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionLayoutSubviews  animations:^{
                
                CGRect tmp = CGRectMake(0 - barrageLen,
                                        Y,
                                        [self p_WidthWithString:[_messageArrag[i] content]],
                                        30);
                barrage.frame  = tmp ;
            } completion:^(BOOL finished) {
                [barrage removeFromSuperview];
            }];
            
            [self.messageArrag removeObjectAtIndex:i];
            i--;
        }
    }
    
}

- (CGFloat)p_WidthWithString:(NSString*)aString{
    return [aString boundingRectWithSize:CGSizeMake(2000, 25) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.f]} context:nil].size.width;
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

// 懒加载
- (NavigationView *)navigationView {
    
    if (_navigationView == nil) {
        _navigationView = [NavigationView shareNavigationViewWithFrame:CGRectMake(0, kGap_20, kScreenWidth, 44) Text:self.model.title];
        self.navigationView.delegate = self;
    }
    
    return _navigationView;
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
