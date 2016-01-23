//
//  WGHHistoryBroadcastView.h
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/22.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WGHChangeHistoryBroadcastDelegate <NSObject>

- (void)changeBroadcastView:(NSMutableArray *)dataArray index:(NSInteger)index;


@end


@interface WGHHistoryBroadcastView : UIView

+(instancetype)shareShowHistoryBroadcastView:(CGRect)fram;

- (void)refreshTableView;

@property (weak, nonatomic) id<WGHChangeHistoryBroadcastDelegate> delegate;



@end
