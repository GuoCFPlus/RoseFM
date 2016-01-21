//
//  WGHHotListDetailsCell.h
//  WGH_FM
//
//  Created by 韩明雨 on 16/1/18.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WGHHotListDetailsModel.h"
@interface WGHHotListDetailsCell : UITableViewCell
@property(strong,nonatomic)WGHShowListModel *hotDetailsModel;
@property(strong,nonatomic)UILabel *numberLabel;
@end
