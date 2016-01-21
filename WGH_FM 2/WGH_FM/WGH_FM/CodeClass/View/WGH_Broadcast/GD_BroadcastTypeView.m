//
//  GD_BroadcastTypeView.m
//  WGH_FM
//
//  Created by lanou3g on 16/1/14.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "GD_BroadcastTypeView.h"

#define kLineHeight 20
#define kImgButtonWidth 50
#define kImgButtonGap ((self.frame.size.width - kImgButtonWidth)/2)



@implementation GD_BroadcastTypeView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self drawView];
    }
    return self;
}


-(void)drawView{
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.imgButton = [[UIButton alloc]initWithFrame:CGRectMake(kImgButtonGap, kImgButtonGap, kImgButtonWidth, kImgButtonWidth)];
    DLog(@"%f",kImgButtonGap);
    self.imgButton.layer.cornerRadius = kImgButtonWidth/2;
    self.imgButton.layer.masksToBounds = YES;
    self.imgButton.layer.borderWidth = 1;
    self.imgButton.layer.borderColor = [[UIColor colorWithRed:253/255.0 green:120/255.0 blue:99/255.0 alpha:1] CGColor];
    [self.imgButton setImage:[UIImage imageNamed:@"wgh_guangbo_bendi"] forState:UIControlStateNormal];
    [self addSubview:self.imgButton];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(kImgButtonGap, CGRectGetMaxY(self.imgButton.frame)+kGap_10, kImgButtonWidth, kLineHeight)];
    self.nameLabel.text = @"本地台";
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont systemFontOfSize:13];
    self.nameLabel.textColor = [UIColor grayColor];
    [self addSubview:self.nameLabel];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
