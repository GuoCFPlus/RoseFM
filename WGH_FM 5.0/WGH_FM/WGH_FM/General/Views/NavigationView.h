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
- (void)downLoadBtnClick;
- (void)moveLabel;

@end


@interface NavigationView : UIView

+(instancetype)shareNavigationViewWithFrame:(CGRect)frame Text:(NSString *)text;

@property (nonatomic,strong)UIView *backgroundView;

@property (nonatomic,strong)NSString *string;

@property (nonatomic,strong)UILabel *label;
@property (nonatomic,weak)id<WGHNavigationViewDelegete>delegate;

@property (strong, nonatomic) UIButton *moreBtn;

- (instancetype)initWithFrame:(CGRect)frame Text:(NSString *)text;

//- (void)closeUserEnabel;
//
//- (void)openUserEnabel;


@end
