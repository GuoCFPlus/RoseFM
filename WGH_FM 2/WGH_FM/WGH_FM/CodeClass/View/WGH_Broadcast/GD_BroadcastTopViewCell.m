//
//  GD_BroadcastTopViewCell.m
//  WGH_FM
//
//  Created by lanou3g on 16/1/16.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "GD_BroadcastTopViewCell.h"

#define kImgWidth (kScreenWidth/4 - kGap_20)
#define kLabelWidth kScreenWidth/2
#define kLineHeight 20

@implementation GD_BroadcastTopViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self drawView];
    }
    return self;
}

-(void)drawView{
    
    self.radioCoverLargeImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"placeholder"]];
    self.radioCoverLargeImgView.frame = CGRectMake(kGap_10, kGap_10, kImgWidth, kImgWidth);
    self.radioCoverLargeImgView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.radioCoverLargeImgView.layer.borderWidth = 1;
    [self addSubview:self.radioCoverLargeImgView];
    
    self.rnameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.radioCoverLargeImgView.frame)+kGap_10, kGap_10, kLabelWidth, kLineHeight)];
    self.rnameLabel.text = @"中国之声";
    [self addSubview:self.rnameLabel];
    
    self.programNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.radioCoverLargeImgView.frame)+kGap_10, CGRectGetMaxY(self.rnameLabel.frame), kLabelWidth, kLineHeight)];
    self.programNameLabel.text = @"直播中：央广新闻";
    self.programNameLabel.font = [UIFont systemFontOfSize:15];
    self.programNameLabel.textColor = [UIColor grayColor];
    [self addSubview:self.programNameLabel];
    
    self.radioPlayCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.radioCoverLargeImgView.frame)+kGap_10, CGRectGetMaxY(self.programNameLabel.frame), kLabelWidth, kLineHeight)];
    self.radioPlayCountLabel.text = @"收听人数：565.7万人";
    self.radioPlayCountLabel.font = [UIFont systemFontOfSize:13];
    self.radioPlayCountLabel.textColor = [UIColor grayColor];
    [self addSubview:self.radioPlayCountLabel];
    
    self.playButton = [[GDButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.rnameLabel.frame)+kGap_20, kGap_30, kGap_30, kGap_30)];
    [self.playButton setImage:[UIImage imageNamed:@"wgh_guangbo_play"] forState:UIControlStateNormal];
    [self addSubview:self.playButton];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.radioCoverLargeImgView.frame)+kGap_10, CGRectGetMaxY(self.radioPlayCountLabel.frame)+kGap_10, kScreenWidth - kImgWidth, 1)];
    lineLabel.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self addSubview:lineLabel];
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
