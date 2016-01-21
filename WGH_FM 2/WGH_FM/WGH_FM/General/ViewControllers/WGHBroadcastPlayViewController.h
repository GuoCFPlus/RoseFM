//
//  WGHBroadcastPlayViewController.h
//  WGH_FM
//
//  Created by lanou3g on 16/1/19.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDButton.h"
@interface WGHBroadcastPlayViewController : UIViewController

//背景图片视图：放电台logo
@property (strong, nonatomic) UIImageView *bgImgView;
//内容视图：放模糊视图,不需要全局，在内页直接写了

//内容视图：放昨天今天明天
@property (strong, nonatomic) UIScrollView *contentScrollView;
//选项卡
@property (strong, nonatomic) UISegmentedControl *changeSegmentedControl;
//列表视图
@property (strong, nonatomic) UITableView *broadcastListTableView;

//样式图片视图
@property (strong, nonatomic) UIImageView *contentImgView;
//节目标题
@property (strong, nonatomic) UILabel *programNameLabel;
//主播
@property (strong, nonatomic) UILabel *announcerListLabel;
//时间区间
@property (strong, nonatomic) UILabel *timeLabel;
//节目单按钮
@property (strong, nonatomic) UIButton *listButton;
//节目单label
@property (strong, nonatomic) UILabel *listLabel;
//上一首按钮
@property (strong, nonatomic) UIButton *preButton;
//播放暂停按钮
@property (strong, nonatomic) GDButton *playButton;
//下一首按钮
@property (strong, nonatomic) UIButton *nextButton;
//播放历史按钮
@property (strong, nonatomic) UIButton *historyButton;
//播放历史label
@property (strong, nonatomic) UILabel *historyLabel;
//已播放时间label
@property (strong, nonatomic) UILabel *pastTimeLabel;
//总时长label
@property (strong, nonatomic) UILabel *totleTimeLabel;
//进度条slider
@property (strong, nonatomic) UISlider *playSlider;



+(instancetype)sharePlayerVC;


@property (strong, nonatomic) NSArray *dataArray;
@property (assign, nonatomic) NSInteger index;
//是否是推荐
@property (assign, nonatomic) BOOL isRecommend;



@end
