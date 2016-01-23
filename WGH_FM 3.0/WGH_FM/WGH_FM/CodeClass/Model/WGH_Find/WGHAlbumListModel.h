//
//  WGHAlbumListModel.h
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/14.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WGHAlbumListModel : NSObject

@property (strong, nonatomic) NSNumber *trackId;  // 1
@property (strong, nonatomic) NSNumber *uid;  // 1
//@property (strong, nonatomic) NSString *playUrl64;
//@property (strong, nonatomic) NSString *playUrl32;
//@property (strong, nonatomic) NSString *downloadUrl;  //下载
@property (strong, nonatomic) NSString *playPathAacv164;  // 1   存
//@property (strong, nonatomic) NSString *playPathAacv224;  // 1
@property (strong, nonatomic) NSString *downloadAacUrl;   // 存
@property (strong, nonatomic) NSString *title;  // 1  // 存
@property (assign, nonatomic) float duration;  // 1
//@property (strong, nonatomic) NSNumber *processState;
//@property (strong, nonatomic) NSNumber *createdAt;  // 1
@property (strong, nonatomic) NSString *coverSmall;  // 1 // 存
@property (strong, nonatomic) NSString *coverMiddle;
//@property (strong, nonatomic) NSString *coverLarge;
@property (strong, nonatomic) NSString *nickname;  // 1
@property (strong, nonatomic) NSString *smallLogo;
@property (strong, nonatomic) NSString *userSource;  // 1
@property (strong, nonatomic) NSNumber *albumId;  // 1
@property (strong, nonatomic) NSString *albumTitle;  // 1
//@property (strong, nonatomic) NSString *albumImage;
//@property (strong, nonatomic) NSNumber *orderNum;
//@property (strong, nonatomic) NSNumber *opType;
@property (strong, nonatomic) NSNumber *likes;
@property (strong, nonatomic) NSNumber *playtimes;
@property (strong, nonatomic) NSNumber *comments;
//@property (strong, nonatomic) NSNumber *shares;
//@property (strong, nonatomic) NSNumber *status;
//@property (strong, nonatomic) NSNumber *downloadSize;
//@property (strong, nonatomic) NSNumber *downloadAacSize;

@property(strong,nonatomic)NSNumber *commentsCounts;
@property(strong,nonatomic)NSNumber *favoritesCounts;
@property(strong,nonatomic)NSNumber *ID;
@property(strong,nonatomic)NSString *playPath32;
@property(strong,nonatomic)NSString *playPath64;
@property(strong,nonatomic)NSNumber *playsCounts;
@property(strong,nonatomic)NSNumber *sharesCounts;
@property(strong,nonatomic)NSString *tags;
@property(strong,nonatomic)NSNumber *updatedAt;


//"trackId": 10812244,
//"uid": 10778196,
//"playUrl64": "http://fdfs.xmcdn.com/group12/M0A/CB/EB/wKgDW1ZwCnqhK24NAH6DLt7ZOyE895.mp3",
//"playUrl32": "http://fdfs.xmcdn.com/group13/M02/CC/55/wKgDXlZwCvqycCOFAD9BtiS7W9E731.mp3",
//"downloadUrl": "http://download.xmcdn.com/group12/M0A/CB/EB/wKgDW1ZwCnKDPAg3AEGj-BO_km8166.aac",
//"playPathAacv164": "http://audio.xmcdn.com/group12/M0A/CB/EC/wKgDW1ZwCn-DX1cSAH_mdZHwd3o120.m4a",
//"playPathAacv224": "http://audio.xmcdn.com/group12/M06/CB/F7/wKgDW1ZwElWwdmZJADDTBD5SVxo718.m4a",
//"downloadAacUrl": "http://audio.xmcdn.com/group12/M06/CB/F7/wKgDW1ZwElWwdmZJADDTBD5SVxo718.m4a",
//"title": "风的预谋 片花引子（新书第一章求收藏，可以从第二集听起）",
//"duration": 1036.36,
//"processState": 2,
//"createdAt": 1450183357000,
//"coverSmall": "http://fdfs.xmcdn.com/group7/M01/D7/A3/wKgDX1Z-oHeh27DDAAEt7RydP2c259_web_meduim.jpg",
//"coverMiddle": "http://fdfs.xmcdn.com/group7/M01/D7/A3/wKgDX1Z-oHeh27DDAAEt7RydP2c259_web_large.jpg",
//"coverLarge": "http://fdfs.xmcdn.com/group7/M01/D7/A3/wKgDX1Z-oHeh27DDAAEt7RydP2c259_mobile_large.jpg",
//"nickname": "头陀渊讲故事",
//"smallLogo": "http://fdfs.xmcdn.com/group15/M06/E3/40/wKgDaFaWEz-Aj_HPAAETcu7RTgk254_mobile_small.jpg",
//"userSource": 1,
//"albumId": 3366901,
//"albumTitle": "风的预谋-多人小说剧",
//"albumImage": "http://fdfs.xmcdn.com/group16/M09/CB/52/wKgDalZvenyxmff0AAHOcZsWIGc376_mobile_small.jpg",
//"orderNum": 99999999,
//"opType": 1,
//"isPublic": true,
//"likes": 596,
//"playtimes": 60324,
//"comments": 172,
//"shares": 0,
//"status": 1,
//"downloadSize": 4301816,
//"downloadAacSize": 3199748



@end
