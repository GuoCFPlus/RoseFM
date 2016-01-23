//
//  WGHHistoryMusicView.h
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/22.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WGHChangeHistoryMusicDelegate <NSObject>

- (void)changeAudioView:(NSMutableArray *)dataArray index:(NSInteger)index;


@end


@interface WGHHistoryMusicView : UIView

+(instancetype)shareShowHistoryMusictView:(CGRect)fram;

- (void)refreshTableView;

@property (weak, nonatomic) id<WGHChangeHistoryMusicDelegate> delegate;




@end
