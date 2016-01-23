//
//  GD_BroadcastHistoryTableViewCell.h
//  WGH_FM
//
//  Created by lanou3g on 16/1/22.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDButton.h"
@interface GD_BroadcastHistoryTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *radioCoverLargeImgView;
@property (strong, nonatomic) UILabel *rnameLabel;
@property (strong, nonatomic) UILabel *programNameLabel;
@property (strong, nonatomic) UILabel *radioPlayCountLabel;
@property (strong, nonatomic) GDButton *playButton;

@end
