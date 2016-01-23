//
//  WGHHotListModel.h
//  WGH_FM
//
//  Created by 韩明雨 on 16/1/14.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WGHHotListModel : NSObject

@property(strong,nonatomic)NSNumber *categoryId;
@property(strong,nonatomic)NSString *contentType;
@property(strong,nonatomic)NSString *coverPath;
@property(strong,nonatomic)NSNumber *firstId;
@property(strong,nonatomic)NSString *firstTitle;
@property(strong,nonatomic)NSString *key;
@property(strong,nonatomic)NSNumber *orderNum;
@property(strong,nonatomic)NSNumber *period;
@property(strong,nonatomic)NSString *rankingRule;
@property(strong,nonatomic)NSString *subtitle;
@property(strong,nonatomic)NSString *title;
@property(strong,nonatomic)NSString *top;
@property(strong,nonatomic)NSString *subtitle1;
@property(strong,nonatomic)NSString *subtitle2;
@property(strong,nonatomic)NSString *subtitle3;
//
//"categoryId": 0,
//"contentType": "track",
//"coverPath": "http://fdfs.xmcdn.com/group16/M04/23/1C/wKgDbFV-qWnymdMFAABWkqxY2as195.png",
//"firstId": 11418829,
//"firstKResults": [
//                  {
//                      "contentType": "track",
//                      "id": 11418829,
//                      "title": "段子来了丨​证监会不相信眼泪，老司机不相信快播有罪60108（采采）"
//                  },
//                  {
//                      "contentType": "track",
//                      "id": 11425685,
//                      "title": "时间的朋友2015跨年演讲（上）[罗辑思维]No.154"
//                  },
//                  {
//                      "contentType": "track",
//                      "id": 11522971,
//                      "title": "《因为遇见你》王源"
//                  }
//                  ],
//"firstTitle": "段子来了丨​证监会不相信眼泪，老司机不相信快播有罪60108（采采）",
//"key": "ranking:track:played:1:0",
//"orderNum": 1,
//"period": 1,
//"rankingRule": "played",
//"subtitle": "每日更新最火的热门节目",
//"title": "最火节目飙升榜",
//"top": 100




@end
