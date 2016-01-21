//
//  GD_BroadcastRecommandRadioList.h
//  WGH_FM
//
//  Created by lanou3g on 16/1/15.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GD_BroadcastRecommandRadioList : NSObject


/*
 "picPath": "http://fdfs.xmcdn.com/group10/M05/E2/B8/wKgDaVaV8zWCa2F_AAG0lLgEeUM844_mobile_large.jpg",
 "radioId": 1607,
 "radioPlayCount": 8737,
 "radioPlayUrl": {
 "radio_24_aac": "http://live.xmcdn.com/live/1708/24.m3u8",
 "radio_24_ts": "http://live.xmcdn.com/live/1708/24.m3u8?transcode=ts",
 "radio_64_aac": "http://live.xmcdn.com/live/1708/64.m3u8",
 "radio_64_ts": "http://live.xmcdn.com/live/1708/64.m3u8?transcode=ts"
 },
 "rname": "动感101泡菜电台"
 */

@property (strong, nonatomic) NSString *picPath;
@property (strong, nonatomic) NSString *radioId;
@property (strong, nonatomic) NSString *radioPlayCount;
@property (strong, nonatomic) NSDictionary *radioPlayUrl;
@property (strong, nonatomic) NSString *rname;


-(instancetype)initWithDictionary:(NSDictionary *)dict;

@end
