//
//  WGHHotListDetailsTableViewCell.m
//  WGH_FM
//
//  Created by 韩明雨 on 16/1/16.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHHotListDetailsTableViewCell.h"
@interface WGHHotListDetailsTableViewCell ()
@property(strong,nonatomic)UIImageView *leftImgView;
@property(strong,nonatomic)UILabel *titleLabel;
@property(strong,nonatomic)UILabel *byLabel;

@end
@implementation WGHHotListDetailsTableViewCell
-(void)setHotDetailsModel:(WGHHotListDetailsModel *)hotDetailsModel
{
    if (_hotDetailsModel != nil) {
        _hotDetailsModel =nil;
        _hotDetailsModel =hotDetailsModel;
    }
    [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:hotDetailsModel.coverSmall]];
    self.titleLabel.text=hotDetailsModel.title;
    
    self.byLabel.text=[NSString stringWithFormat:@"by %@",hotDetailsModel.nickname];
    
    
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
    
    self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImgView.frame)+kGap_10, 5,kTitleWidth , kGap_40)];
    self.titleLabel.font=[UIFont systemFontOfSize:14];
    self.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
    self.titleLabel.numberOfLines=2;
    [self.contentView addSubview:self.titleLabel];
    
    self.byLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImgView.frame)+kGap_10, CGRectGetMaxY(self.titleLabel.frame), kTitleWidth, 15)];
    self.byLabel.font=[UIFont systemFontOfSize:13];
    self.byLabel.textColor=[UIColor grayColor];
    [self.contentView addSubview:_byLabel];
    
  
    
}







- (void)awakeFromNib {
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
