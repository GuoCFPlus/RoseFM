//
//  WGHClassFyCollectionViewCell.m
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/13.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHClassFyCollectionViewCell.h"


@interface WGHClassFyCollectionViewCell ()


@property(strong,nonatomic)UIImageView *leftImgView;
@property(strong,nonatomic)UILabel *titleLabel;

@end

@implementation WGHClassFyCollectionViewCell

- (void)setModel:(WGHClassFyModel *)model {
    
    if (_model != nil) {
        _model = nil;
        _model = model;
    }
    
    [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:model.coverPath]];
    
    self.titleLabel.text = model.title;
    
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupSubViews];
    }
    return self;
}

#define kWidth kScreenWidth/2-kGap_10

- (void)setupSubViews {
    
    self.leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kGap_10, kGap_10, kGap_30, kGap_30)];
    [self addSubview:self.leftImgView];
    
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImgView.frame)+kGap_10, kGap_10, kWidth-kGap_50, kGap_30)];
    [self addSubview:self.titleLabel];
    
    
    
    
    
}



@end
