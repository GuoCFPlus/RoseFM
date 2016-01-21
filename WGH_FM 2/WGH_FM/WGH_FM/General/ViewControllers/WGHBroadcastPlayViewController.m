//
//  WGHBroadcastPlayViewController.m
//  WGH_FM
//
//  Created by lanou3g on 16/1/19.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHBroadcastPlayViewController.h"
#define kBottomViewHeight 100

#define kMarginLR 20
#define kMarginTB 26

#define kContentImgWidth (kScreenWidth - kMarginLR*2)


#define kLabelWidth (kContentImgWidth - kGap_40)
#define kLabelHeight 25

#define kLineGap (kScreenHeight - 64 - kMarginTB - kContentImgWidth - kGap_50 - 70)/2

#define kMarginButton (kScreenWidth - kGap_30*4 -kGap_50 -kGap_40)/4
#define kHistoryWidth 70

@interface WGHBroadcastPlayViewController ()<WGHBroadcastLiveToolsDelegate,UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)GD_BroadcastRecommandRadioList *playModelRecommand;
@property(strong,nonatomic)GD_BroadcastTopRadioModel *playModel;
@property(strong,nonatomic)GD_BroadcastPlayModel *playDetailModel;

//节目数组
@property(strong,nonatomic)NSMutableArray *broadcastListArray;

//定时器
@property (strong, nonatomic) NSTimer *timerMain;

@end
static NSString *const broadcastListCellID = @"broadcastListCellID";
@implementation WGHBroadcastPlayViewController

+(instancetype)sharePlayerVC{
    static WGHBroadcastPlayViewController *bpVC = nil;
    if (bpVC == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            bpVC = [[WGHBroadcastPlayViewController alloc]init];
        });
    }
    return bpVC;
}

-(instancetype)init{
    if (self = [super init]) {
        UIImage *image = [UIImage imageNamed:@"wgh_navigationbar_xiangxia"];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(returnAction)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"wgh_guangbo_naozhong"] style:UIBarButtonItemStylePlain target:self action:@selector(clockAction)];
    }
    return self;
}

- (void)returnAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clockAction {
    
}


//绘制页面
- (void)drawView {
    
    
    // 控制位置
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = 0;
    }
    
    self.navigationItem.title = @"中国之声";
    
    //底层logo视图
    self.bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    //开启响应者链
    self.bgImgView.userInteractionEnabled = YES;
    self.bgImgView.image = [UIImage imageNamed:@"wgh_user_header_stretching"];
    [self.view addSubview:self.bgImgView];
    //内容视图：放模糊视图,不需要全局，在内页直接写了
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = self.bgImgView.frame;
    [self.bgImgView addSubview:effectView];
//    UIView *effectView = [[UIView alloc]initWithFrame:self.bgImgView.frame];
//    effectView.backgroundColor = [UIColor blackColor];
//    effectView.alpha = 0.5;
//    [self.bgImgView addSubview:effectView];
    
    //样式图片视图
    self.contentImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kMarginLR, kMarginTB, kContentImgWidth, kContentImgWidth)];
    self.contentImgView.image = [UIImage imageNamed:@"wgh_guangbo_playBg"];
    [self.bgImgView addSubview:self.contentImgView];
    
    //主播
    CGFloat y = kContentImgWidth * 0.4;
    self.announcerListLabel = [[UILabel alloc]initWithFrame:CGRectMake(kGap_20, y,kLabelWidth, kLabelHeight)];
    self.announcerListLabel.text = @"主播：暂无";
    self.announcerListLabel.textColor = [UIColor whiteColor];
    self.announcerListLabel.font = [UIFont systemFontOfSize:13];
    self.announcerListLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentImgView addSubview:self.announcerListLabel];
    
    //节目标题
    self.programNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(kGap_20, CGRectGetMinY(self.announcerListLabel.frame)-kLabelHeight-kGap_10, kLabelWidth , kLabelHeight)];
    self.programNameLabel.text = @"暂无节目单";
    self.programNameLabel.textColor = [UIColor whiteColor];
    self.programNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentImgView addSubview:self.programNameLabel];
    
    //时间区间
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kGap_20, CGRectGetMaxY(self.announcerListLabel.frame),kLabelWidth, kLabelHeight)];
    self.timeLabel.text = @"00:00 - 24:00";
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentImgView addSubview:self.timeLabel];
    
    //节目单按钮
    self.listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.listButton.frame = CGRectMake(kGap_20, CGRectGetMaxY(self.contentImgView.frame)+kGap_20+kLineGap, kGap_30, kGap_30);
    [self.listButton setImage:[UIImage imageNamed:@"wgh_guangbo_listWhite"] forState:UIControlStateNormal];
    //self.listButton.backgroundColor = [UIColor orangeColor];
    [self.listButton addTarget:self action:@selector(listAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgImgView addSubview:self.listButton];
    //节目单label
    self.listLabel = [[UILabel alloc]initWithFrame:CGRectMake(kGap_10, CGRectGetMaxY(self.listButton.frame), kGap_50, kLabelHeight)];
    self.listLabel.text = @"节目单";
    self.listLabel.textColor = [UIColor whiteColor];
    self.listLabel.font = [UIFont systemFontOfSize:13];
    self.listLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgImgView addSubview:self.listLabel];
    //上一首按钮
    self.preButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.preButton.frame = CGRectMake(CGRectGetMaxX(self.listButton.frame)+kMarginButton, CGRectGetMaxY(self.contentImgView.frame)+kGap_20+kLineGap, kGap_30, kGap_30);
    [self.preButton setImage:[UIImage imageNamed:@"wgh_guangbo_preWhite"] forState:UIControlStateNormal];
    [self.preButton addTarget:self action:@selector(preAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgImgView addSubview:self.preButton];
    //播放暂停按钮
    self.playButton = [GDButton buttonWithType:UIButtonTypeCustom];
    self.playButton.frame = CGRectMake(CGRectGetMaxX(self.preButton.frame)+kMarginButton, CGRectGetMaxY(self.contentImgView.frame)+kGap_10+kLineGap, kGap_50, kGap_50);
    [self.playButton setImage:[UIImage imageNamed:@"wgh_guangbo_playWhite"] forState:UIControlStateNormal];
    self.playButton.isPlay = NO;
    [self.playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgImgView addSubview:self.playButton];
    //下一首按钮
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton.frame = CGRectMake(CGRectGetMaxX(self.playButton.frame)+kMarginButton, CGRectGetMaxY(self.contentImgView.frame)+kGap_20+kLineGap, kGap_30, kGap_30);
    [self.nextButton setImage:[UIImage imageNamed:@"wgh_guangbo_nextWhite"] forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgImgView addSubview:self.nextButton];
    //播放历史按钮
    self.historyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.historyButton.frame = CGRectMake(CGRectGetMaxX(self.nextButton.frame)+kMarginButton, CGRectGetMaxY(self.contentImgView.frame)+kGap_20+kLineGap, kGap_30, kGap_30);
    //self.historyButton.backgroundColor = [UIColor orangeColor];
    [self.historyButton setImage:[UIImage imageNamed:@"wgh_guangbo_historyWhite"] forState:UIControlStateNormal];
    [self.historyButton addTarget:self action:@selector(historyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgImgView addSubview:self.historyButton];
    //播放历史label
    self.historyLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - kHistoryWidth, CGRectGetMaxY(self.historyButton.frame), kHistoryWidth, kLabelHeight)];
    self.historyLabel.text = @"播放历史";
    //self.historyLabel.backgroundColor = [UIColor orangeColor];
    self.historyLabel.textColor = [UIColor whiteColor];
    self.historyLabel.font = [UIFont systemFontOfSize:13];
    self.historyLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgImgView addSubview:self.historyLabel];
    
    //进度条slider
    self.playSlider = [[UISlider alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.historyLabel.frame)+kGap_10+kLineGap, kScreenWidth, 2)];
    self.playSlider.minimumTrackTintColor = [UIColor colorWithRed:253/255.0 green:120/255.0 blue:99/255.0 alpha:1];
    //设置最小值
    self.playSlider.minimumValue = 0;
    self.playSlider.maximumValue = 100;
    [self.playSlider setThumbImage:[UIImage imageNamed:@"wgh_guangbo_cycle"] forState:UIControlStateNormal];
    //添加事件
    [self.playSlider addTarget:self action:@selector(sliderAction) forControlEvents:UIControlEventValueChanged];
    [self.bgImgView addSubview:self.playSlider];
    
    //已播放时间label
    self.pastTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.playSlider.frame), kHistoryWidth, kLabelHeight)];
    self.pastTimeLabel.text = @"00:00";
    self.pastTimeLabel.textColor = [UIColor whiteColor];
    self.pastTimeLabel.font = [UIFont systemFontOfSize:13];
    self.pastTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgImgView addSubview:self.pastTimeLabel];
    //总时长label
    self.totleTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - kHistoryWidth - kGap_10, CGRectGetMaxY(self.playSlider.frame), kHistoryWidth, kLabelHeight)];
    self.totleTimeLabel.text = @"00:00:00";
    self.totleTimeLabel.textColor = [UIColor whiteColor];
    self.totleTimeLabel.font = [UIFont systemFontOfSize:13];
    self.totleTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgImgView addSubview:self.totleTimeLabel];
    

    
}

//节目单按钮事件
-(void)listAction{
    
}
//上一首点击事件
-(void)preAction{
    
}
//播放/暂停点击事件
-(void)playAction:(GDButton *)sender{
    //速率为0，即未播放时点击按钮，变成播放
    if ([WGHBroadcastLiveTools shareBroadcastLivePlayer].player.rate == 0) {
        if (self.timerMain) {
            [self.timerMain invalidate];
            self.timerMain = nil;
        }
        self.timerMain = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];

        [[WGHBroadcastLiveTools shareBroadcastLivePlayer] audioPlay];    }
    else
    {
        [self.timerMain invalidate];
        self.timerMain = nil;
        [[WGHBroadcastLiveTools shareBroadcastLivePlayer] audioPause];
    }
}

-(void)timerAction{
    //加载数据
    if (self.playDetailModel) {
        //进度时间与总时间
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[[WGHBroadcastLiveTools shareBroadcastLivePlayer] getTimeWithStartTime:self.playDetailModel.startTime endTime:self.playDetailModel.endTime]];
        self.totleTimeLabel.text = dict[@"totleTime"];
        self.playSlider.maximumValue = [dict[@"maxProgress"] floatValue];
        self.playSlider.value = [dict[@"progress"] floatValue];
        self.pastTimeLabel.text = dict[@"currutTime"];
    }
}

//下一首事件
-(void)nextAction{
    
}
//播放历史事件
-(void)historyAction{
    
}
//进度事件
-(void)sliderAction{
    [[WGHBroadcastLiveTools shareBroadcastLivePlayer] seekTotimeWithValue:self.playSlider.value];
}

//加载数据
- (void)requestRecommendData {
    
    __weak typeof(self) weak = self;
    NSString *url = [NSString string];
    if (self.isRecommend == YES) {
        url = [NSString stringWithFormat:@"http://live.ximalaya.com/live-web/v1/getProgramDetail?device=iPhone&programScheduleId=%@&radioId=%@",self.playModel.programScheduleId,self.playModel.radioId];
    }
    else
    {
        url = [NSString stringWithFormat:@"http://live.ximalaya.com/live-web/v1/getProgramDetail?device=iPhone&programScheduleId=0&radioId=%@",self.playModelRecommand.radioId];
    }
    
    DLog(@"%@",url);
    [[WGHRequestData shareRequestData] requestClassBPDataWithURL:url block:^(GD_BroadcastPlayModel *model) {
        NSLog(@"%@",model);
        if (model) {
            weak.playDetailModel = model;
            dispatch_async(dispatch_get_main_queue(), ^{
                // 绘制视图
                weak.navigationItem.title = weak.playModel.rname;
                //[weak.bgImgView sd_setImageWithURL:[NSURL URLWithString:weak.playModel.radioCoverLarge] placeholderImage:[UIImage imageNamed:@"wgh_user_header_stretching"]];
                weak.programNameLabel.text = weak.playDetailModel.programName;
                if (weak.playDetailModel.announcerList.count > 0) {
                    NSMutableString *announcerStr = [NSMutableString stringWithString:@"主播："];
                    for (int i = 0; i < weak.playDetailModel.announcerList.count; i++) {
                        [announcerStr appendFormat:@"%@ ",[weak.playDetailModel.announcerList[i] valueForKey:@"announcerName"]];
                    }
                    weak.announcerListLabel.text = announcerStr;
                    weak.announcerListLabel.hidden = NO;
                }
                else
                {
                    weak.announcerListLabel.hidden = YES;
                }
                weak.timeLabel.text = [NSString stringWithFormat:@"%@ - %@",weak.playDetailModel.startTime,weak.playDetailModel.endTime];
                
                //进度时间与总时间
                NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[[WGHBroadcastLiveTools shareBroadcastLivePlayer] getTimeWithStartTime:weak.playDetailModel.startTime endTime:weak.playDetailModel.endTime]];
                self.totleTimeLabel.text = dict[@"totleTime"];
                self.playSlider.maximumValue = [dict[@"maxProgress"] floatValue];
                self.playSlider.value = [dict[@"progress"] floatValue];
                self.pastTimeLabel.text = dict[@"currutTime"];
            });
        }
        
    }];
    
}






- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //绘制页面
    [self drawView];
    
    
    //设置代理
    [WGHBroadcastLiveTools shareBroadcastLivePlayer].delegate = self;
    self.broadcastListTableView.delegate = self;
    self.broadcastListTableView.dataSource = self;
    
    //为播放器添加观察者，观察播放速率“rate”
    //因为AVPlayer没有一个内部属性来标识当前的播放状态，所以我们可以通过rate变相的得到播放状态
    //观察播放速率rate，是为了获得播放暂停的触发事件，作出相应的响应事件（比如修改button的图片及事件）
    [[WGHBroadcastLiveTools shareBroadcastLivePlayer].player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    //播放模式观察者
    [[WGHBroadcastLiveTools shareBroadcastLivePlayer] addObserver:self forKeyPath:@"musicTurnModel" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];

    
}

-(void)viewDidAppear:(BOOL)animated{
    //推荐电台
    if (self.isRecommend == NO) {
        self.playModelRecommand = self.dataArray[self.index];
        [WGHBroadcastLiveTools shareBroadcastLivePlayer].playerUrl = self.playModelRecommand.radioPlayUrl[@"radio_24_aac"];
    }
    else
    {
        //其他电台
        self.playModel = self.dataArray[self.index];
        [WGHBroadcastLiveTools shareBroadcastLivePlayer].playerUrl = self.playModel.radioPlayUrl[@"radio_24_aac"];
    }
    
    [[WGHBroadcastLiveTools shareBroadcastLivePlayer] audioPrePlay];
    
    //加载数据
    [self requestRecommendData];
    self.timerMain = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}


//观察播放速率的响应方法：速率 == 0 表示暂停；不为0，表示播放中
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    //速率为0，即未播放时点击按钮，变成播放
    if ([keyPath isEqualToString:@"rate"]) {
        if ([change[@"new"] floatValue] == 0) {
            [self.playButton setImage:[UIImage imageNamed:@"wgh_guangbo_playWhite"] forState:UIControlStateNormal];
            self.playButton.isPlay = NO;
        }
        else{
            [self.playButton setImage:[UIImage imageNamed:@"wgh_guangbo_stopWhite"] forState:UIControlStateNormal];
            self.playButton.isPlay = YES;
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ---代理事件---
-(void)getCurTime:(NSString *)curTime Totle:(NSString *)totleTime Progress:(CGFloat)progress{
    
//    self.pastTimeLabel.text = curTime;
//    self.totleTimeLabel.text = totleTime;
//    self.playSlider.value = progress;
    /*//CD旋转
    self.musicImageView.transform = CGAffineTransformRotate(self.musicImageView.transform, M_2_PI/180);
    //返回歌词在数组中的位置，然后根据此位置，将歌词跳到相应的行
    NSInteger index = [[MusicPlayTools shareMusicPlay] getIndexFromArray];
    if (index == -1) {
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.musicLyricTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
     */
}

-(void)endOfPlay{
    /*
    //单曲循环时，继续播放本曲目
    if ([MusicPlayTools shareMusicPlay].musicTurnModel == 2 ) {
        [[MusicPlayTools shareMusicPlay] seekToTimeWithValue:0];
    }
    else
    {
        [self nextAction:nil];
    }
     */
}


#pragma mark -----tableView代理方法-----

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.broadcastListArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:broadcastListCellID];
    
//    if (cell == nil) {
//        cell = [[MusicLyricTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:musicLyricCellID];
//    }
//    cell.musicLyric.text = ((MusicLyric *)self.lyricArray[indexPath.row]).lyricStr;
    
    return cell;
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
