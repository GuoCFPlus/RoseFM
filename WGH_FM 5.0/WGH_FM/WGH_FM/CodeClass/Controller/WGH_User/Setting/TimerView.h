//
//  TimerView.h
//  AudioShare
//
//  Created by lanou3g on 15/8/8.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerView : UIView
@property (nonatomic, strong)UILabel *label1;
@property (nonatomic, strong)UILabel *label2;
@property (nonatomic, strong)UILabel *label3;
@property (nonatomic, strong)UILabel *label4;
@property (nonatomic, strong)UILabel *label5;
@property (nonatomic, strong)UILabel *label6;
@property (nonatomic, strong)UISwitch *timerSwich;
@property (nonatomic, strong)UILabel *showTimerLable;

- (NSArray *)labelArray;
@end
