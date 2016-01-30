//
//  NavigationView.m
//  KDG__FM
//
//  Created by 吴凯强 on 16/1/20.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "NavigationView.h"


@interface NavigationView ()

@property(strong,nonatomic)NSTimer *timer;

@end


@implementation NavigationView

static NavigationView *nv = nil;
+ (instancetype)shareNavigationViewWithFrame:(CGRect)frame Text:(NSString *)text {
    
    if (nv == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            nv = [[NavigationView alloc] initWithFrame:frame Text:text];
        });
    }
    
    return nv;
}

//注意点:先设置宽高,再设置中心点,如果先设置中心点,在设置宽高的话就有问题

- (instancetype)initWithFrame:(CGRect)frame Text:(NSString *)text
{
    if (self = [super initWithFrame:frame]) {
        //向下按钮
        UIButton *Downbtn = [[UIButton alloc] init];
        [Downbtn setImage:[UIImage imageNamed:@"wgh_navigationbar_xiangxia"] forState:UIControlStateNormal];
        Downbtn.width = 25;
        Downbtn.height = 20;
        Downbtn.centerY = frame.size.height/2;
        Downbtn.centerX = 30;
        [Downbtn addTarget:self action:@selector(downClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:Downbtn];
        

        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.width = 0.65*kScreenWidth;
        backgroundView.height = 30;
        backgroundView.centerX = frame.size.width/2;
        backgroundView.centerY = frame.size.height/2;
        self.backgroundView = backgroundView;
        [self addSubview:backgroundView];

        self.label = [[UILabel alloc] init];
        self.label.font = [UIFont fontWithName:@"Arial" size:17];
        self.label.textColor = [UIColor orangeColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        [backgroundView addSubview:self.label];
        [backgroundView setClipsToBounds:YES]; //移动到外面不显示

        
        // 下载按钮
        self.moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.moreBtn.width = 25;
        self.moreBtn.height = 25;
        self.moreBtn.centerX = frame.size.width - 30;
        self.moreBtn.centerY = frame.size.height / 2;
        self.moreBtn.tintColor = [UIColor orangeColor];
        [self.moreBtn setImage:[UIImage imageNamed:@"wgh_audio_download"] forState:UIControlStateNormal];
        [self.moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        self.moreBtn.enabled = NO;
        [self addSubview:self.moreBtn];
        
        
    }
    return self;
}

//- (void)closeUserEnabel {
//    
//    self.moreBtn.enabled = NO;
//    NSLog(@"关闭交互");
//    
//}
//
//- (void)openUserEnabel {
//    
//    self.moreBtn.enabled = YES;
//    NSLog(@"打开交互");
//}

- (void)downClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(downBtnClick)]) {
        [self.delegate downBtnClick];
    }
}


- (void)setString:(NSString *)string {
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
    _string = string;
    CGSize size = CGSizeMake(1000000, 30);
    CGRect newRect = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    newRect.size.width += kGap_10;
    if (newRect.size.width < 0.65 * kScreenWidth) {
        newRect.size.width = 0.65 * kScreenWidth;
    }
    self.label.frame = CGRectMake(0, 0, newRect.size.width, 30);
    self.label.text = string;

    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(move) userInfo:nil repeats:YES];
    
}


- (void)move {
    
    
    [self.delegate moveLabel];
}

- (void)moreBtnClick {
    
    [self.delegate downLoadBtnClick];
    
}



@end
