//
//  GD_BroadcastRecommendViewCell.m
//  WGH_FM
//
//  Created by lanou3g on 16/1/16.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "GD_BroadcastRecommendViewCell.h"
#define kLineHeight 20
#define kImgWidth 80

@implementation GD_BroadcastRecommendViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self drawView];
    }
    return self;
}

-(void)drawView{
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.picPathImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kGap_10, kImgWidth, kImgWidth)];
    
    
    self.picPathImgView.layer.borderWidth = 1;
    self.picPathImgView.layer.borderColor = [[UIColor colorWithRed:253/255.0 green:120/255.0 blue:99/255.0 alpha:1] CGColor];
    self.picPathImgView.image = [UIImage imageNamed:@"placeholder"];
    [self addSubview:self.picPathImgView];
    
    self.rnameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.picPathImgView.frame)+kGap_10, kImgWidth, kLineHeight)];
    self.rnameLabel.text = @"海南音乐广播";
    self.rnameLabel.textAlignment = NSTextAlignmentCenter;
    self.rnameLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.rnameLabel];
}


@end
