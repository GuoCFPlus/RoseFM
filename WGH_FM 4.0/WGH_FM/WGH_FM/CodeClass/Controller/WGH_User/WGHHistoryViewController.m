//
//  WGHHistoryViewController.m
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/22.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHHistoryViewController.h"



@interface WGHHistoryViewController ()<WGHChangeHistoryMusicDelegate,WGHChangeHistoryBroadcastDelegate>

@property(strong,nonatomic)WGHHistoryBroadcastView *historyBroadcastView;
@property(strong,nonatomic)WGHHistoryMusicView *historyMusicView;



@end

@implementation WGHHistoryViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"播放历史";
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnAction)];
        
    }
    
    return self;
}
- (void)returnAction {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = 0;
    }
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *array = @[@"声音历史",@"广播历史"];
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:array];
    seg.frame = CGRectMake(0, 0, kScreenWidth, kGap_40);
    //背景色
    seg.backgroundColor = [UIColor colorWithRed:0.900 green:0.900 blue:0.900 alpha:1.000];
    //切圆角
    seg.layer.cornerRadius = 5;
    seg.layer.masksToBounds = YES;
    //边框及字体颜色
    seg.tintColor = [UIColor colorWithRed:1.000 green:0.400 blue:0.000 alpha:1.000];
    seg.selectedSegmentIndex = 0;
    [seg addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:seg];
    
    
    self.historyBroadcastView = [WGHHistoryBroadcastView shareShowHistoryBroadcastView:CGRectMake(0, CGRectGetMaxY(seg.frame)+5, kScreenWidth, kScreenHeight-CGRectGetMaxY(seg.frame) - 5 - 64)];
    self.historyBroadcastView.delegate = self;
    [self.historyBroadcastView refreshTableView];
    [self.view addSubview:self.historyBroadcastView];
    
    self.historyMusicView = [WGHHistoryMusicView shareShowHistoryMusictView:CGRectMake(0, CGRectGetMaxY(seg.frame)+5, kScreenWidth, kScreenHeight-CGRectGetMaxY(seg.frame)-5 - 64)];
    self.historyMusicView.delegate = self;
    [self.historyMusicView refreshTableView];
    [self.view addSubview:self.historyMusicView];
    
    
    
}
#pragma mark  ----页面切换----
-(void)changePage:(UISegmentedControl *)seg {
    
    if (seg.selectedSegmentIndex == 0) {
        [self.view bringSubviewToFront:self.historyMusicView];
        //        [self.classFyView removeFromSuperview];
        
    }else {
        [self.view bringSubviewToFront:self.historyBroadcastView];
        //        [self.view addSubview:self.classFyView];
        
    }
    
}



// 代理方法

- (void)changeAudioView:(NSMutableArray *)dataArray index:(NSInteger)index {
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定后,只能从当前历史列表播放,确定要播放吗" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    UIAlertAction *defaultlAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        WGHaudioPlayerViewController *audioPlayerVC = [WGHaudioPlayerViewController shareAudioPlayer];
        audioPlayerVC.dataArray = dataArray;
        audioPlayerVC.indext = index;
        
        [self presentViewController:audioPlayerVC animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:defaultlAction];
    [alertController addAction:cancelAction];
    
    
}


- (void)changeBroadcastView:(NSMutableArray *)dataArray index:(NSInteger)index {
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定后,只能从当前广播历史列表播放,确定要播放吗" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    UIAlertAction *defaultlAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        // 跳转播放界面
        WGHBroadcastPlayViewController *bpVC = [WGHBroadcastPlayViewController sharePlayerVC];
        
        bpVC.isRecommend = YES;
        bpVC.dataArray = dataArray;
        bpVC.index = index;
        
        UINavigationController *albumListNC = [[UINavigationController alloc] initWithRootViewController:bpVC];
        [albumListNC.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:1.000 green:0.304 blue:0.156 alpha:1.000],UITextAttributeTextColor,[UIFont systemFontOfSize:18],UITextAttributeFont,nil]];
        albumListNC.navigationBar.tintColor = [UIColor colorWithRed:1.000 green:0.304 blue:0.156 alpha:1.000];
        albumListNC.navigationBar.alpha = 0;
        [self presentViewController:albumListNC animated:YES completion:nil];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:defaultlAction];
    [alertController addAction:cancelAction];
    
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
