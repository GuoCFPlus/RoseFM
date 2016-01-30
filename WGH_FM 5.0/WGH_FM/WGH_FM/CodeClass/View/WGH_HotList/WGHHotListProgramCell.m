//
//  WGHHotListProgramCell.m
//  WGH_FM
//
//  Created by 韩明雨 on 16/1/14.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHHotListProgramCell.h"

@interface WGHHotListProgramCell ()
@property(strong,nonatomic)UIImageView *leftImgView;//top图片
@property(strong,nonatomic)UILabel *titleLabel;//标题
@property(strong,nonatomic)UILabel *intro1Label;//简介1
@property(strong,nonatomic)UILabel *intro2Label;//简介2

@end

@implementation WGHHotListProgramCell
-(void)setHotListModel:(WGHHotListModel *)hotListModel
{
    if (_hotListModel!= nil) {
        _hotListModel = nil;
        _hotListModel = hotListModel;
    }
    [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:hotListModel.coverPath]];
    self.titleLabel.text = hotListModel.title;
    self.intro1Label.text = [NSString stringWithFormat:@"1. %@",hotListModel.subtitle1];
    self.intro2Label.text = [NSString stringWithFormat:@"2. %@",hotListModel.subtitle2];
  
    
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
#define kTitleWidth kScreenWidth-kImgViewWidth-kGap_20 - kGap_30
-(void)drawView
{
    self.leftImgView=[[UIImageView alloc]initWithFrame:CGRectMake(kGap_10, 5, kImgViewWidth, kImgViewHeight)];
    [self.contentView addSubview:self.leftImgView];
    
    self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImgView.frame)+kGap_10, 5, kTitleWidth, kGap_30)];
    [self.contentView addSubview:self.titleLabel];
    
    self.intro1Label=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImgView.frame)+kGap_10, CGRectGetMaxY(self.titleLabel.frame), kTitleWidth, 15)];
    self.intro1Label.textColor = [UIColor grayColor];
    self.intro1Label.font=[UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.intro1Label];
    
    self.intro2Label=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImgView.frame)+kGap_10, CGRectGetMaxY(self.intro1Label.frame), kTitleWidth, 15)];
    self.intro2Label.textColor = [UIColor grayColor];
    self.intro2Label.font=[UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.intro2Label];
    
    
}




- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
