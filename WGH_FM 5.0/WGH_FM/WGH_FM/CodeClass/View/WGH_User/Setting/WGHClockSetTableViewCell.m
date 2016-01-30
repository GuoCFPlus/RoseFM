//
//  WGHClockSetTableViewCell.m
//  WGH_FM
//
//  Created by lanou3g on 16/1/26.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHClockSetTableViewCell.h"
#define kLabelWidth (kScreenWidth - 100)
#define kLineHeight 20

@implementation WGHClockSetTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self drawView];
    }
    return self;
}

-(void)drawView{
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kGap_10, 15, kGap_50, kLineHeight)];
    self.titleLabel.text = @"重复";
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.titleLabel];
    
    self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 15, kLabelWidth, kLineHeight)];
    self.detailLabel.text = @"不重复";
    self.detailLabel.font = [UIFont systemFontOfSize:13];
    self.detailLabel.textColor = [UIColor grayColor];
    self.detailLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.detailLabel];
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
