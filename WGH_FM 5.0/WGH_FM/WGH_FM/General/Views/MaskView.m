//
//  MaskView.m
//  KDG__FM
//
//  Created by 郜宇 on 15/10/17.
//  Copyright © 2015年 KDG. All rights reserved.
//

#import "MaskView.h"

@implementation MaskView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.center = CGPointMake(frame.size.width/2, frame.size.height/2-25);
        _progressView.progress = 0;
        _progressView.progressTintColor = [UIColor orangeColor];
        _progressView.trackTintColor = [UIColor whiteColor];
        [self addSubview:_progressView];
        //label
        UILabel *label = [[UILabel alloc] init];
        label.width = 150;
        label.height = 30;
        label.centerX = frame.size.width / 2;
        label.centerY = frame.size.height / 2 + 15;
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        self.label = label;
        [self addSubview:label];

        
        
    }
    return self;
}

@end
