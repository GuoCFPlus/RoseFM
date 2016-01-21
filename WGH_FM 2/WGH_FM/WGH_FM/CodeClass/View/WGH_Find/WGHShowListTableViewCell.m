//
//  WGHShowListTableViewCell.m
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/13.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHShowListTableViewCell.h"


@interface WGHShowListTableViewCell ()


@property(strong,nonatomic)UIImageView *leftImgView;
@property(strong,nonatomic)UILabel *mainTitleLabel;
@property(strong,nonatomic)UILabel *subTitleLabel;
@property(strong,nonatomic)UILabel *playsCountsLabel;
@property(strong,nonatomic)UILabel *tracksCountsLabel;

@end


@implementation WGHShowListTableViewCell



- (void)setShowListModel:(WGHShowListModel *)showListModel {
    
    if (_showListModel != nil) {
        _showListModel = nil;
        _showListModel = showListModel;
    }
    
    [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:showListModel.albumCoverUrl290] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.mainTitleLabel.text = showListModel.title;
    self.subTitleLabel.text = showListModel.intro;
    self.playsCountsLabel.text = [NSString stringWithFormat:@"%.1f万",[showListModel.playsCounts floatValue]/10000];
    self.tracksCountsLabel.text = [NSString stringWithFormat:@"%d集",[showListModel.tracksCounts  intValue]];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup_subViews];
        
        
    }
    
    return self;
}

#define kImgViewWidth 60
#define kImgViewHeight 60
#define kTitleLabelWidth (kScreenWidth - 120)

//绘制cell
- (void)setup_subViews {
    
    
    self.leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kGap_10, 5, kImgViewWidth, kImgViewHeight)];
    [self.contentView addSubview:self.leftImgView];
    
    self.mainTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImgView.frame)+kGap_20, 5, kTitleLabelWidth, 20)];
    self.mainTitleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.mainTitleLabel];
    
    self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImgView.frame)+kGap_20, CGRectGetMaxY(self.mainTitleLabel.frame)+5, kTitleLabelWidth, 20)];
    self.subTitleLabel.font = [UIFont systemFontOfSize:14];
    self.subTitleLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.subTitleLabel];
    
    
    UIImageView *playsCountsImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImgView.frame)+kGap_20, CGRectGetMaxY(self.subTitleLabel.frame)+5, kGap_10, kGap_10)];
    playsCountsImgView.image = [UIImage imageNamed:@"playsCounts"];
    [self.contentView addSubview:playsCountsImgView];
    
    
    self.playsCountsLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(playsCountsImgView.frame)+kGap_10, CGRectGetMaxY(self.subTitleLabel.frame)+5, kGap_40, kGap_10)];
    self.playsCountsLabel.textColor = [UIColor grayColor];
    self.playsCountsLabel.font = [UIFont systemFontOfSize:9];
    [self.contentView addSubview:self.playsCountsLabel];
    
    UIImageView *tracksCountsImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.playsCountsLabel.frame)+kGap_10, CGRectGetMaxY(self.subTitleLabel.frame)+5, kGap_10, kGap_10)];
    tracksCountsImgView.image = [UIImage imageNamed:@"tracksCounts"];
    [self.contentView addSubview:tracksCountsImgView];
    
    self.tracksCountsLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tracksCountsImgView.frame)+kGap_10, CGRectGetMaxY(self.subTitleLabel.frame)+5, kGap_40, kGap_10)];
    self.tracksCountsLabel.textColor = [UIColor grayColor];
    self.tracksCountsLabel.font = [UIFont systemFontOfSize:9];
    [self.contentView addSubview:self.tracksCountsLabel];
}


- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
