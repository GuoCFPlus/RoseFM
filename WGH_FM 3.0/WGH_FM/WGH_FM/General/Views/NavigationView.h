//
//  NavigationView.h
//  KDG__FM
//
//  Created by 吴凯强 on 16/1/20.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WGHNavigationViewDelegete <NSObject>
@optional

- (void)downBtnClick;
- (void)moveLabel;

@end


@interface NavigationView : UIView


@property (nonatomic,strong)UIView *backgroundView;

@property (nonatomic,strong)NSString *string;

@property (nonatomic,strong)UILabel *label;
@property (nonatomic,weak)id<WGHNavigationViewDelegete>delegate;



- (instancetype)initWithFrame:(CGRect)frame Text:(NSString *)text;






@end
