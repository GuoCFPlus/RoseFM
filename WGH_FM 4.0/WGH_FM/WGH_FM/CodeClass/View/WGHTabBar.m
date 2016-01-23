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
        self.circleButton.backgroundColor = [UIColor whiteColor];
        [self.circleButton setImage:[UIImage imageNamed:@"wgh_tabbar_bofang×64"] forState:UIControlStateNormal];
        [self.circleButton setImage:[UIImage imageNamed:@"wgh_tabbar_bofang×64_h"] forState:UIControlStateHighlighted];
        
        self.circleButton.frame = CGRectMake(0, 0, 50, 50);
        
        //按钮的监听事件
        [self.circleButton addTarget:self action:@selector(CircleClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.circleButton];
        
        //设置观察者
        [[WGHBroadcastTools shareBroadcastPlayer].player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
        
        
    }
    return self;
}

- (void)CircleClick
{
    
    [self.delegate tabBarDidClickCircleButton:self.circleButton];
    
    
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

#pragma mark ---观察者----
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"rate"]) {
        if ([change[@"new"] floatValue] == 0) {
            [self.circleButton setImage:[UIImage imageNamed:@"wgh_tabbar_bofang×64"] forState:UIControlStateNormal];
            [self.circleButton setImage:[UIImage imageNamed:@"wgh_tabbar_bofang×64_h"] forState:UIControlStateHighlighted];
        }else {
            
            [self.circleButton setImage:[UIImage imageNamed:@"wgh_tabbar_zanting×64"] forState:UIControlStateNormal];
            [self.circleButton setImage:[UIImage imageNamed:@"wgh_tabbar_wgh_tabbar_zanting×64_h"] forState:UIControlStateHighlighted];
        }
    }
}



@end
