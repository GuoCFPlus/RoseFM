//
//  WGHHotListDetailsTableViewCell.h
//  WGH_FM
//
//  Created by 韩明雨 on 16/1/16.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WGHAlbumListModel.h"
@interface WGHHotListDetailsTableViewCell : UITableViewCell
@property(strong,nonatomic)WGHAlbumListModel *albumListModel;
@property(strong,nonatomic)UILabel *numberLabel;
@end
