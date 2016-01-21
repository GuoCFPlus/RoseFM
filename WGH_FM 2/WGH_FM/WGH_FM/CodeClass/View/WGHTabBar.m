//
//  WGHTabBar.m
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/13.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHTabBar.h"

@implementation WGHTabBar

//
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self = [super initWithFrame:frame]) {
        //中间的加号图片
        self.circleButton = [[UIButton alloc] init];
        [self.circleButton setBackgroundImage:[UIImage imageNamed:@"wgh_tabbar_bofang×64"] forState:UIControlStateNormal];
        
        
        self.circleButton.frame = CGRectMake(0, 0, 50, 50);
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeColor:) name:@"night" object:nil];
        
        
        //按钮的监听事件
        [self.circleButton addTarget:self action:@selector(CircleClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.circleButton];
        
        
    }
    return self;
}


- (void)changeColor:(NSNotification *)notification
{
    BOOL num = [notification.object boolValue];
    if (num == YES) {
        self.backgroundImage = [UIImage imageNamed:@"wgh_tabbar_bofang×64"];
    }else{
        self.backgroundImage = [UIImage imageNamed:@"wgh_tabbar_zanting×64"];
    }
}

- (void)CircleClick
{
    
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickCircleButton:)]) {
        [self.delegate tabBarDidClickCircleButton:self.circleButton];
    }
    
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    //1.设置加号按钮的位置
    self.circleButton.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    //2.设置其他tabbarButton的位置和尺寸
    
    CGFloat tabbarButtonW = self.frame.size.width / 5;
    CGFloat tabbarButtonIndex = 0;
    
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            
            child.frame = CGRectMake(tabbarButtonIndex * tabbarButtonW, 0, tabbarButtonW, 49);
            tabbarButtonIndex ++;
            if (tabbarButtonIndex == 2) {
                tabbarButtonIndex ++;
            }
        }
        
    }
    
}

@end
