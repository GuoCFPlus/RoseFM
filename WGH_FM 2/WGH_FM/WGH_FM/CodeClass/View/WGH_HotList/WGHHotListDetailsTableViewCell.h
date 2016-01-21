//
//  WGHHotListDetailsTableViewCell.h
//  WGH_FM
//
//  Created by 韩明雨 on 16/1/16.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WGHHotListDetailsModel.h"
@interface WGHHotListDetailsTableViewCell : UITableViewCell
@property(strong,nonatomic)WGHHotListDetailsModel *hotDetailsModel;
@property(strong,nonatomic)UILabel *numberLabel;
@end
