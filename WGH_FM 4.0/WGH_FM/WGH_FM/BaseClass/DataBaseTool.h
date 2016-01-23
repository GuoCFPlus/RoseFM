//
//  DataBaseTool.h
//  KQ_MusicPlayer
//
//  Created by 吴凯强 on 15/12/28.
//  Copyright © 2015年 吴凯强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "WGHAlbumListModel.h"
#import "GD_BroadcastTopRadioModel.h"
@interface DataBaseTool : NSObject

+(instancetype) shareDataBase;

// 根据传入的 路径 和 数据库文件名, 连接数据库.
// -1 失败, 0 成功,1重复打开(不算错误).
-(int)connectDB:(NSString *)filePath;

// -1 失败,0成功.
-(int)disconnectDB;

// 对于增删改,你需要自己传入语句. 0 成功 -1 失败.
-(int)execDDLSql:(NSString *)sql;

// 对于增删改,你需要自己传入语句. 0 成功 -1 失败.
-(int)execDMLSql:(NSString *)sql;

// 根据你的查询语句判断数据库中这样的条数有多少条.
-(int)sqlCount:(NSString *)sql;

// 根据你的 sql, 返回一个字段,这个字段是 nsstring( 你自己得知道)
-(NSString *)sqlFieldText:(NSString *)sql;

// 根据你的 sql, 返回一个字段,这个字段是 nsstring( 你自己得知道)
-(NSInteger)sqlFieldInt:(NSString *)sql;

// 选出一列,该列都是字符串
-(NSMutableArray *)selectString:(NSString *)sql;

//=================================存音乐======================================
- (void)createMusicList;// 创建表
- (void)createMusicCollectList; // 创建收藏表
- (int)insertMusicPlayer:(WGHAlbumListModel *)model;
- (int)insertCollectMusicPlayer:(WGHAlbumListModel *)model;
- (NSMutableArray *)selectAllMusicPlaye:(NSString *)condition;
- (NSMutableArray *)selectAllCollectMusicPlaye:(NSString *)condition;

//=================================存广播======================================
#pragma mark ------广播播放历史-------
//创建表
- (void)createBroadcastHistoryList;
//插入推荐播放数据
- (int)insertBroadcastHistoryTop:(GD_BroadcastTopRadioModel *)model;
//查询数据
- (NSMutableArray *)selectAllBroadcastHistoryPlaye:(NSString *)condition;



//=================================存下载======================================



//=================================存录音======================================
- (int)insertRecordName:(NSString *)recordName;
- (NSMutableArray *)selectAllRecord:(NSString *)condition;



@end
