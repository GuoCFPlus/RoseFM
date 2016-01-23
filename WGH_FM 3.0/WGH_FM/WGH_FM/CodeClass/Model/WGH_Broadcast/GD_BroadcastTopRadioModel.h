//
//  GD_BroadcastTopRadioModel.h
//  WGH_FM
//
//  Created by lanou3g on 16/1/16.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GD_BroadcastTopRadioModel : NSObject
/*
"programId": 44157,
"programName": "股市大家谈",
"programScheduleId": 66419,
"radioCoverLarge": "http://fdfs.xmcdn.com/group6/M06/84/C9/wKgDhFT_ooCjkmmkAAA4E0ludxE638_mobile_large.jpg",
"radioCoverSmall": "http://fdfs.xmcdn.com/group6/M06/84/C9/wKgDhFT_ooCjkmmkAAA4E0ludxE638_mobile_small.jpg",
"radioId": 56,
"radioPlayCount": 379187,
"radioPlayUrl": {
    "radio_24_aac": "http://live.xmcdn.com/live/56/24.m3u8",
    "radio_24_ts": "http://live.xmcdn.com/live/56/24.m3u8?transcode=ts",
    "radio_64_aac": "http://live.xmcdn.com/live/56/64.m3u8",
    "radio_64_ts": "http://live.xmcdn.com/live/56/64.m3u8?transcode=ts"
},
"rname": "上海第一财经频率"
*/

@property (strong, nonatomic) NSNumber *programId;
@property (strong, nonatomic) NSString *programName;
@property (strong, nonatomic) NSNumber *programScheduleId;
@property (strong, nonatomic) NSString *radioCoverLarge;
@property (strong, nonatomic) NSString *radioCoverSmall;
@property (strong, nonatomic) NSNumber *radioId;
@property (strong, nonatomic) NSNumber *radioPlayCount;
@property (strong, nonatomic) NSDictionary *radioPlayUrl;
@property (strong, nonatomic) NSString *rname;


-(instancetype)initWithDictionary:(NSDictionary *)dict;


@end
