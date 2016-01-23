//
//  WGHaudioPlayerViewController.h
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/19.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WGHaudioPlayerViewController : UIViewController

+(instancetype)shareAudioPlayer;


@property (strong, nonatomic) NSArray *dataArray;
@property (assign, nonatomic) NSInteger indext;


// timer相关
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, assign)CGFloat timerTime;
@property (nonatomic, assign)BOOL timerObserver;

@end
