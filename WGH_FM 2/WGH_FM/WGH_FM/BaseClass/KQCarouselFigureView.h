//
//  KQCarouselFigureView.h
//  Lesson_CarouselFigureView(轮播图)
//
//  Created by 吴凯强 on 15/12/12.
//  Copyright © 2015年 吴凯强. All rights reserved.
//

/// 轮播图  ***********
//***********************************
//***********************************
//***********************************
//***********************************
//***********************************
//***********************************



#import <UIKit/UIKit.h>
@class KQCarouselFigureView;



@interface KQCarouselFigureView : UIView

/**
 *  图片数组,外界赋值轮播图片的时候用,或者获取轮播图片时使用
 */
@property (strong, nonatomic) NSArray *picturesAraay;


/**
 *  当前下标
 */
@property (assign, nonatomic) NSUInteger currentIndex;

@property (strong, nonatomic) UIButton *button;



@end
