//
//  GD_BroadcastPlayModel.h
//  WGH_FM
//
//  Created by lanou3g on 16/1/20.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GD_BroadcastPlayModel : NSObject
/*
 
 "announcerList": [
 {
 "announcerId": 192,
 "announcerName": "长悦"
 },
 {
 "announcerId": 216,
 "announcerName": "胡凡"
 },
 {
 "announcerId": 2852,
 "announcerName": "刘鹤佳"
 }
 ],
 "endTime": "16:30",
 "fmuid": 19414524,
 "playBackgroundPic": "http://fdfs.xmcdn.com/group6/M08/84/D2/wKgDhFT_oxGzpBYYAABn8GON2wI270_mobile_large.jpg",
 "programId": 94339,
 "programName": "央广新闻（午后版）",
 "programScheduleId": 5221,
 "startTime": "13:00"
 
 */
@property (strong, nonatomic) NSArray *announcerList;
@property (strong, nonatomic) NSString *endTime;
@property (strong, nonatomic) NSString *fmuid;
@property (strong, nonatomic) NSString *playBackgroundPic;
@property (strong, nonatomic) NSString *programId;
@property (strong, nonatomic) NSString *programName;
@property (strong, nonatomic) NSString *programScheduleId;
@property (strong, nonatomic) NSString *startTime;


-(instancetype)initWithDictionary:(NSDictionary *)dict;

@end
