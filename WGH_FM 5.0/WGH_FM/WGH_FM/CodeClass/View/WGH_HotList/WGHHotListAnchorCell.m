//
//  WGHHotListAnchorCell.m
//  WGH_FM
//
//  Created by 韩明雨 on 16/1/18.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHHotListAnchorCell.h"
@interface WGHHotListAnchorCell ()
@property(strong,nonatomic)UIImageView *leftImgView;
@property(strong,nonatomic)UILabel *nameLabel;
@property(strong,nonatomic)UILabel *introLabel;
@property(strong,nonatomic)UILabel *friendLabel;
@property(strong,nonatomic)UIImageView *nameImgView;

@end
@implementation WGHHotListAnchorCell

-(void)setAlbumListModel:(WGHHotAnchorModel *)albumListModel {
    if (_albumListModel != nil) {
        _albumListModel = nil;
        _albumListModel = albumListModel;
    }
    [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:albumListModel.middleLogo]];
    self.nameLabel.text = albumListModel.nickname;
    CGSize labelsize = [self.nameLabel.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(200, kGap_20) lineBreakMode:NSLineBreakByCharWrapping];
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.leftImgView.frame)+kGap_10, 5, labelsize.width, kGap_20);
    
    self.nameImgView.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame)+2, 5, 15, 15);
    self.introLabel.text = albumListModel.personDescribe;
    self.friendLabel.text = [NSString stringWithFormat:@"%@万",albumListModel.tracksCounts];
    
    
    
    
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
#define kTitleWidth kScreenWidth-kImgViewWidth-kGap_50-kGap_10
-(void)drawView
{
    self.numberLabel=[[UILabel alloc]initWithFrame:CGRectMake(kGap_10, 5, kGap_30, kImgViewHeight)];
    [self.contentView addSubview:_numberLabel];
    
    self.leftImgView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.numberLabel.frame), 5, kImgViewWidth, kImgViewHeight)];
    self.leftImgView.layer.cornerRadius=30;
    self.leftImgView.layer.masksToBounds=YES;
    [self.contentView addSubview:_leftImgView];
    
    
    
    self.nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImgView.frame)+kGap_10, 5, kTitleWidth, kGap_20)];
    self.nameLabel.font=[UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.nameLabel];
    
    self.nameImgView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame), 5, kGap_20, kGap_20)];
    self.nameImgView.image=[UIImage imageNamed:@"v"];
    [self.contentView addSubview:self.nameImgView];
    
    self.introLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImgView.frame)+kGap_10, CGRectGetMaxY(self.nameLabel.frame), kTitleWidth, kGap_20)];
    self.introLabel.font=[UIFont systemFontOfSize:13];
    self.introLabel.textColor=[UIColor grayColor];
    [self.contentView addSubview:self.introLabel];
    
    UIImageView *friendImgView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImgView.frame)+kGap_10, CGRectGetMaxY(self.introLabel.frame)+5, kGap_10, kGap_10)];
    friendImgView.image=[UIImage imageNamed:@"wgh_haoyou"];
    [self.contentView addSubview:friendImgView];
    
    self.friendLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(friendImgView.frame), CGRectGetMaxY(self.introLabel.frame), kGap_40, kGap_20)];
    self.friendLabel.textColor=[UIColor grayColor];
    self.friendLabel.font=[UIFont systemFontOfSize:9];
    [self.contentView addSubview:self.friendLabel];
    
    
}


- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
