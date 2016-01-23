//
//  WGHHotListAnchorCell.h
//  WGH_FM
//
//  Created by 韩明雨 on 16/1/18.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WGHHotAnchorModel.h"
@interface WGHHotListAnchorCell : UITableViewCell

@property(strong,nonatomic)WGHHotAnchorModel *albumListModel;
@property(strong,nonatomic)UILabel *numberLabel;

@end
