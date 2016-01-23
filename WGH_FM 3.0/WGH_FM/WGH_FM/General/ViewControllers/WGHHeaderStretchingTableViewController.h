//
//  WGHHeaderStretchingTableViewController.h
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/15.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WGHHeaderStretchingTableViewController : UITableViewController
/**
 *  导航栏背景图片名称
 */
@property(strong,nonatomic)NSString* navigation_backgroundImageName;

/**
 *  头部被拉伸图片控件的高度
 */
@property (assign, nonatomic) CGFloat stretchingImageHeight;

/**
 *  头部被拉伸图片名称
 */
@property (strong, nonatomic) NSString *stretchingImageName;


/** 顶部拉伸的图片 */
@property (strong, nonatomic) UIImageView *topView;





@end
