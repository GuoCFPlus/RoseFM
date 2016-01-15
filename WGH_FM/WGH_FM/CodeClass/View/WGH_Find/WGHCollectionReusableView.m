//
//  WGHCollectionReusableView.m
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/14.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHCollectionReusableView.h"

@interface WGHCollectionReusableView ()

@end

@implementation WGHCollectionReusableView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup_subviews];
    }
    return self;
}

#define kBigImgWidth (kScreenWidth-kGap_30)/2
#define kSmallImgWidth (kBigImgWidth-kGap_10)/2

- (void)setup_subviews {
    
    self.firstImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kGap_10, kGap_10, kBigImgWidth, kBigImgWidth)];
    self.firstImgView.tag = 100;
    self.firstImgView.userInteractionEnabled = YES;
    [self addSubview:self.firstImgView];
    
    self.secondImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.firstImgView.frame)+kGap_10, kGap_10, kSmallImgWidth, kSmallImgWidth)];
    self.secondImgView.tag = 101;
    self.secondImgView.userInteractionEnabled = YES;
    [self addSubview:self.secondImgView];
    
    
    self.thirdImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.secondImgView.frame)+kGap_10, kGap_10, kSmallImgWidth, kSmallImgWidth)];
    self.thirdImgView.tag = 102;
    self.thirdImgView.userInteractionEnabled = YES;
    [self addSubview:self.thirdImgView];
    
    
    self.fourthImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.firstImgView.frame)+kGap_10, CGRectGetMaxY(self.secondImgView.frame)+kGap_10, kSmallImgWidth, kSmallImgWidth)];
    self.fourthImgView.tag = 103;
    self.fourthImgView.userInteractionEnabled = YES;
    [self addSubview:self.fourthImgView];
    
    
    self.fifthImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.fourthImgView.frame)+kGap_10, CGRectGetMaxY(self.secondImgView.frame)+kGap_10, kSmallImgWidth, kSmallImgWidth)];
    self.fifthImgView.tag = 104;
    self.fifthImgView.userInteractionEnabled = YES;
    [self addSubview:self.fifthImgView];
    
}


@end
