//
//  WGHTabBar.h
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/13.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol WGHTabBarDelegate <UITabBarDelegate>

@optional

- (void)tabBarDidClickCircleButton:(UIButton *)tabBar;

@end

@interface WGHTabBar : UITabBar

@property (strong,nonatomic) UIButton *circleButton;

@property (weak,nonatomic) id<WGHTabBarDelegate> delegate;


@end
