//
//  WGHHotListDetailsCell.m
//  WGH_FM
//
//  Created by 韩明雨 on 16/1/18.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHHotListDetailsCell.h"
@interface WGHHotListDetailsCell ()


@property(strong,nonatomic)UIImageView *leftImgView;
@property(strong,nonatomic)UILabel *mainTitleLabel;
@property(strong,nonatomic)UILabel *subTitleLabel;
@property(strong,nonatomic)UILabel *playsCountsLabel;
@property(strong,nonatomic)UILabel *tracksCountsLabel;

@end
@implementation WGHHotListDetailsCell
- (void)setAlbumListModel:(WGHShowListModel *)albumListModel {
    if (_albumListModel != nil) {
        _albumListModel = nil;
        _albumListModel = albumListModel;
    }
   [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:albumListModel.albumCoverUrl290] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.mainTitleLabel.text = albumListModel.title;
    self.subTitleLabel.text = albumListModel.intro;
    self.playsCountsLabel.text = [NSString stringWithFormat:@"%.1f万",[albumListModel.playsCounts floatValue]/10000];
    self.tracksCountsLabel.text = [NSString stringWithFormat:@"%d集",[albumListModel.tracksCounts  intValue]];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self drawView];
    }
    return self;
}
#define kImgViewWidth 60
#define kImgViewHeight 60
#define kTitleWidth kScreenWidth-kImgViewWidth-kGap_50-kGap_20
-(void)drawView
{
    self.numberLabel=[[UILabel alloc]initWithFrame:CGRectMake(kGap_10, 5, kGap_30, kImgViewHeight)];
    [self.contentView addSubview:_numberLabel];
    
    self.leftImgView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.numberLabel.frame), 5, kImgViewWidth, kImgViewHeight)];
    [self.contentView addSubview:_leftImgView];
    
    self.mainTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImgView.frame)+kGap_10, 3,kTitleWidth , kGap_40)];
    self.mainTitleLabel.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.mainTitleLabel];
    
    self.subTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImgView.frame)+kGap_10, CGRectGetMaxY(self.mainTitleLabel.frame)-7, kTitleWidth, 15)];
    self.subTitleLabel.font=[UIFont systemFontOfSize:13];
    self.subTitleLabel.textColor=[UIColor grayColor];
    [self.contentView addSubview:_subTitleLabel];
    
    
    UIImageView *playsCountsImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImgView.frame)+kGap_10, CGRectGetMaxY(self.subTitleLabel.frame)+5, kGap_10, kGap_10)];
    playsCountsImgView.image = [UIImage imageNamed:@"playsCounts"];
    [self.contentView addSubview:playsCountsImgView];
    
    
    self.playsCountsLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(playsCountsImgView.frame)+kGap_10, CGRectGetMaxY(self.subTitleLabel.frame)+5, kGap_50, kGap_10)];
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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
