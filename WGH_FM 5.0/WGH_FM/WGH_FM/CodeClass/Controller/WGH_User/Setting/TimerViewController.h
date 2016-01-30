//
//  TimerViewController.h
//  AudioShare
//
//  Created by lanou3g on 15/8/8.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerViewController : UIViewController
@property (nonatomic, assign)BOOL isModal;
@property (nonatomic, assign)NSTimeInterval time;
@property (nonatomic, assign)NSTimeInterval timeManual;
@end
