//
//  KQCarouselFigureView.m
//  Lesson_CarouselFigureView(轮播图)
//
//  Created by 吴凯强 on 15/12/12.
//  Copyright © 2015年 吴凯强. All rights reserved.
//

#import "KQCarouselFigureView.h"

@interface KQCarouselFigureView ()<UIScrollViewDelegate>

@property(strong,nonatomic) UIScrollView *scrollView;

@property(strong,nonatomic) UIPageControl *pageControl;


@end



@implementation KQCarouselFigureView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}



/**
 *  pictureArray的setter,当对其赋值时触发
 *
 *  @param picturesAraay 图片数组
 */
- (void)setPicturesAraay:(NSArray *)picturesAraay {
    
    if (_picturesAraay != picturesAraay) {
        _picturesAraay = nil;
        _picturesAraay = picturesAraay;
    }
    
    //在外界对图片数组进行赋值的时候,开始绘图
    [self drawView];

}

/**
 *  绘制视图的方法
 */

- (void)drawView {
    
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    
}

//当前视图的宽度
#define kWidth self.bounds.size.width
//当前视图高度
#define kHeight self.bounds.size.height
//当前图片个数
#define kCount self.picturesAraay.count

//懒加载ScrollView
- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(kWidth * kCount, kHeight);
        _scrollView.delegate =self;
        //添加图片
        for (int i = 0; i < kCount; i++) {
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth * i, 0, kWidth, kHeight)];
            imgView.image = self.picturesAraay[i];
            imgView.userInteractionEnabled = YES;
            if (i == kCount-1) {
                self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kWidth, 60)];
                self.button.center = CGPointMake(kWidth/2, kHeight-kHeight/6);
                
                [imgView addSubview:self.button];
            }
            
            [_scrollView addSubview:imgView];
            
        }
    }
    
    
    return _scrollView;
}

//懒加载pageControl
#define kGap 10
#define kPageHeight 29
-(UIPageControl *)pageControl {
    
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, kWidth, kPageHeight)];
        _pageControl.center = CGPointMake(kWidth/2, kHeight - kPageHeight);
        
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.numberOfPages = kCount;
        
    }
    
    
    return _pageControl;
    
}


#pragma mark ---UIScrollViewDelegate---


//结束减速时
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //根据视图的偏移量校正当前下标
    self.currentIndex = scrollView.contentOffset.x / kWidth;
    //根据新的下标校正pageControl当前页
    self.pageControl.currentPage = self.currentIndex;
    
    
}






@end
