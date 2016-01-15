//
//  GD_BroadcastRecommendCell.m
//  WGH_FM
//
//  Created by lanou3g on 16/1/15.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "GD_BroadcastRecommendCell.h"
#define kLineHeight 20
#define kFlowLayoutWidth ((kScreenWidth - kGap_40)/3)
#define kFlowLayoutHeight (kFlowLayoutWidth + kLineHeight)

@implementation GD_BroadcastRecommendCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self drawView];
    }
    return self;
}

-(void)drawView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    //每个单元格的大小
    flowLayout.itemSize = CGSizeMake(kFlowLayoutWidth, kFlowLayoutHeight);
    //设置分区距离上下左右的间距
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    
    self.recommendCV = [[UICollectionView alloc]initWithFrame:self.frame collectionViewLayout:flowLayout];
    
    
    [self addSubview:self.recommendCV];
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
