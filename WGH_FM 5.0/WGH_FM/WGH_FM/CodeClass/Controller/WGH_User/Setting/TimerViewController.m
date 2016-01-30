//
//  TimerViewController.m
//  AudioShare
//
//  Created by lanou3g on 15/8/8.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "TimerViewController.h"
#import "TimerView.h"
#import "WGHaudioPlayerViewController.h"

@interface TimerViewController ()
@property (nonatomic, strong)TimerView *tv;
@property (nonatomic, strong)UILabel *lastLabel;
@end

@implementation TimerViewController
- (void)loadView
{
    self.tv = [[TimerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _tv;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    BOOL timerOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"timerOn"];
    if (timerOn) {
        _tv.timerSwich.on = YES;
        
        WGHaudioPlayerViewController *playerVC = [WGHaudioPlayerViewController shareAudioPlayer];
        [playerVC addObserver:self forKeyPath:@"timerTime" options:(NSKeyValueObservingOptionNew) context:nil];
        playerVC.timerObserver = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        _tv.showTimerLable.text = [self convertTime:playerVC.timerTime];
        
    } else {
        _tv.timerSwich.on = NO;
        _tv.showTimerLable.text = nil;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = 0;
    }
    [self p_setupNavigation];
    
    NSArray *labArray = [self.tv labelArray];
    _tv.label1.text = @"10\n分钟后";
    _tv.label2.text = @"20\n分钟后";
    _tv.label3.text = @"30\n分钟后";
    _tv.label4.text = @"60\n分钟后";
    _tv.label5.text = @"90\n分钟后";
    _tv.label6.text = @"120\n分钟后";
    
    for (UILabel *lab in labArray) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [lab addGestureRecognizer:tap];
    }
    [_tv.timerSwich addTarget:self action:@selector(timerSwichAction:) forControlEvents:(UIControlEventValueChanged)];
    
    
 
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    WGHaudioPlayerViewController *playerVC = [WGHaudioPlayerViewController shareAudioPlayer];
    if (playerVC.timerObserver) {
        [playerVC removeObserver:self forKeyPath:@"timerTime"];
        playerVC.timerObserver = NO;
    }
}




- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    self.time = [change[@"new"] doubleValue];
    self.tv.showTimerLable.text = [self convertTime:_time];
    if (self.time <= 0) {
        self.time = 0;
        [self timerSwichAction:self.tv.timerSwich];
        self.tv.timerSwich.on = NO;
        self.tv.showTimerLable.text = nil;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}


- (void)timerSwichAction:(UISwitch *)sender
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (sender.on) {
        [ud setBool:YES forKey:@"timerOn"];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        [ud setBool:NO forKey:@"timerOn"];
        WGHaudioPlayerViewController *playerVC = [WGHaudioPlayerViewController shareAudioPlayer];
        [playerVC.timer invalidate];
        playerVC.timer = nil;
        _tv.showTimerLable.text = nil;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.time = 0;
        self.lastLabel.backgroundColor = [UIColor whiteColor];
        self.lastLabel.textColor = [UIColor blackColor];
        self.timeManual = 0;
        self.lastLabel = nil;
    }
    [ud synchronize];
}


- (void)tapAction:(UITapGestureRecognizer *)sender
{
    UILabel *lab = (UILabel *)sender.view;
    self.lastLabel.backgroundColor = [UIColor whiteColor];
    self.lastLabel.textColor = [UIColor blackColor];
    lab.backgroundColor = [UIColor blackColor];
    lab.textColor = [UIColor whiteColor];
    switch (lab.tag) {
        case 101:
            self.timeManual = 60 * 10;
            break;
        case 102:
            self.timeManual = 60 * 20;
            break;
        case 103:
            self.timeManual = 60 * 30;
            break;
        case 104:
            self.timeManual = 60 * 60;
            break;
        case 105:
            self.timeManual = 60 * 90;
            break;
        case 106:
            self.timeManual = 60 * 120;
            break;
                
        default:
            break;
    }
    self.lastLabel = lab;
    
}

- (void)p_setupNavigation
{
    self.navigationItem.title = @"定时关闭";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:(UIBarButtonItemStyleDone) target:self action:@selector(backAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemDone) target:self action:@selector(confirmAction:)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:(UIBarButtonItemStylePlain) target:self action:@selector(confirmAction:)];s

    
    
}

- (void)backAction:(UIBarButtonItem *)sender
{
    WGHaudioPlayerViewController *playerVC = [WGHaudioPlayerViewController shareAudioPlayer];
    if (playerVC.timerObserver) {
        [playerVC removeObserver:self forKeyPath:@"timerTime" context:nil];
        playerVC.timerObserver = NO;
    }
    
    if (_isModal) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)confirmAction:(UIBarButtonItem *)sender
{
    DLog(@"确认");
    BOOL timerOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"timerOn"];
    if (_timeManual && timerOn) {
        WGHaudioPlayerViewController *playerVC = [WGHaudioPlayerViewController shareAudioPlayer];
        
        if (playerVC.timer) {
            [playerVC.timer invalidate];
            playerVC.timer = nil;
        }
        
        playerVC.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:playerVC selector:@selector(timerChangeAction:) userInfo:nil repeats:YES];
        
        playerVC.timerTime = self.timeManual;
        self.tv.showTimerLable.text = [self convertTime:_timeManual];
        [playerVC.timer fire];
        
        if (_isModal) {
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}


- (NSString *)convertTime:(NSTimeInterval)second
{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: d];
    d = [d dateByAddingTimeInterval: -frominterval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
        
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
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
