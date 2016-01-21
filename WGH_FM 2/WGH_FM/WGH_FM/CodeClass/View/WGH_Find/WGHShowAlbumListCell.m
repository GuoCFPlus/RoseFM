//
//  WGHShowAlbumListCell.m
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/14.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHShowAlbumListCell.h"

@interface WGHShowAlbumListCell ()

@property(strong,nonatomic)UIImageView *albumImgView;
@property(strong,nonatomic)UILabel *titleLabel;
@property(strong,nonatomic)UILabel *playtimesLabel;
@property(strong,nonatomic)UILabel *commentsLabel;
@property(strong,nonatomic)UILabel *durationLabel;


@end
@implementation WGHShowAlbumListCell


- (void)setAlbumModel:(WGHAlbumListModel *)albumModel {
    
    if (_albumModel != nil) {
        _albumModel = nil;
        _albumModel = albumModel;
    }
    [self.albumImgView sd_setImageWithURL:[NSURL URLWithString:albumModel.coverSmall] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.titleLabel.text = albumModel.title;
    self.playtimesLabel.text = [NSString stringWithFormat:@"%.1f万",[albumModel.playtimes doubleValue]/10000];
    self.durationLabel.text = [NSString stringWithFormat:@"%d:%d",(int)albumModel.duration/60,(int)albumModel.duration%60];
    self.commentsLabel.text = [NSString stringWithFormat:@"%d",[albumModel.comments intValue]];    
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup_subViews];
    }
    return self;
}

#define kImgViewWidth 65
#define kTitleWidth kScreenWidth-kGap_40-50

// 绘制cell
- (void)setup_subViews {
    
    
    self.albumImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kGap_10, kGap_10, kImgViewWidth, kImgViewWidth)];
    [self.contentView addSubview:self.albumImgView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.albumImgView.frame)+kGap_10, kGap_10, kTitleWidth, kGap_40)];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    UIImageView *playCounts = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.albumImgView.frame)+kGap_10, CGRectGetMaxY(self.titleLabel.frame)+5, 15, 15)];
    playCounts.image = [UIImage imageNamed:@"playsCounts"];
    [self.contentView addSubview:playCounts];
    
    self.playtimesLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(playCounts.frame)+5, CGRectGetMaxY(self.titleLabel.frame)+5, kGap_40, 15)];
    self.playtimesLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.playtimesLabel];
    
    UIImageView *durationImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.playtimesLabel.frame)+5, CGRectGetMaxY(self.titleLabel.frame)+5, 15, 15)];
    durationImg.image = [UIImage imageNamed:@"wgh_album_shichang"];
    [self.contentView addSubview:durationImg];
    
    self.durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(durationImg.frame)+5, CGRectGetMaxY(self.titleLabel.frame)+5, kGap_40, 15)];
    self.durationLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.durationLabel];
    UIImageView *commentsImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.durationLabel.frame)+5, CGRectGetMaxY(self.titleLabel.frame)+5, 15, 15)];
    commentsImg.image = [UIImage imageNamed:@"wgh_album_pinglun"];
    [self.contentView addSubview:commentsImg];
    
    self.commentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(commentsImg.frame)+5, CGRectGetMaxY(self.titleLabel.frame)+5, kGap_30, 15)];
    self.commentsLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.commentsLabel];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
