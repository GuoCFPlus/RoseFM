//
//  TimerView.m
//  AudioShare
//
//  Created by lanou3g on 15/8/8.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "TimerView.h"

@implementation TimerView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setUpView];
    }
    return self;
}

- (void)p_setUpView
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // timerSwitch
    self.backgroundColor = [UIColor whiteColor];
    self.timerSwich = [[UISwitch alloc] init];
    _timerSwich.frame = CGRectMake(width - 5 - 50 , 34, 80, 40);
    [self addSubview:_timerSwich];
    
    // timerLabel
    self.showTimerLable = [[UILabel alloc] init];
    _showTimerLable.frame = CGRectMake(65, 34, width - 140, 31);
    _showTimerLable.textAlignment = NSTextAlignmentCenter;
    _showTimerLable.layer.borderColor = [UIColor blackColor].CGColor;
    _showTimerLable.layer.borderWidth = 1.f;
    _showTimerLable.textColor = [UIColor orangeColor];
    [self addSubview:_showTimerLable];
//    _showTimerLable.backgroundColor = [UIColor greenColor];
    
    // stopTimeLabel
    self.label1 = [[UILabel alloc] init];
    self.label2 = [[UILabel alloc] init];
    self.label3 = [[UILabel alloc] init];
    self.label4 = [[UILabel alloc] init];
    self.label5 = [[UILabel alloc] init];
    self.label6 = [[UILabel alloc] init];
    NSArray *labelArray = @[_label1, _label2, _label3, _label4, _label5, _label6];
    
    CGFloat labwidth = (width - 100) / 3;
    
    for (int i = 0; i < 6; i ++) {
        UILabel *lab = labelArray[i];
        lab.numberOfLines = 2;
        lab.tag = 101+i;
        lab.userInteractionEnabled = YES;
        lab.layer.cornerRadius = labwidth / 2;
        lab.layer.masksToBounds = YES;
        lab.textAlignment = NSTextAlignmentCenter;
        if (i < 3) {
            lab.frame = CGRectMake(30 + i * (labwidth + 20), CGRectGetMaxY(_showTimerLable.frame) + 40, labwidth, labwidth);
        } else {
            lab.frame = CGRectMake(30 + i % 3 * (labwidth + 20), CGRectGetMaxY(_showTimerLable.frame) + 40 + 30 +  labwidth, labwidth, labwidth);
        }
        lab.backgroundColor = [UIColor whiteColor];
        lab.alpha = 0.8;
        lab.layer.borderColor = [UIColor blackColor].CGColor;
        lab.layer.borderWidth = 1.f;
        [self addSubview:lab];
    }
    
    
}

- (void)layoutSubviews
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    _timerSwich.frame = CGRectMake(width - 5 - 50 , 34, 80, 40);
    _showTimerLable.frame = CGRectMake(65, 34, width - 140, 31);
    NSArray *labelArray = @[_label1, _label2, _label3, _label4, _label5, _label6];
    
    CGFloat labwidth = (width - 100) / 3;
    for (int i = 0; i < 6; i ++) {
        UILabel *lab = labelArray[i];
        
        if (i < 3) {
            lab.frame = CGRectMake(30 + i * (labwidth + 20), CGRectGetMaxY(_showTimerLable.frame) + 40, labwidth, labwidth);
        } else {
            lab.frame = CGRectMake(30 + i % 3 * (labwidth + 20), CGRectGetMaxY(_showTimerLable.frame) + 40 + 30 +  labwidth, labwidth, labwidth);
        }
    }
}

- (NSArray *)labelArray
{
    return @[_label1, _label2, _label3, _label4, _label5, _label6];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
