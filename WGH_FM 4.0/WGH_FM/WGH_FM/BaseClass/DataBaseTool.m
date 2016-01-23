//
//  DataBaseTool.m
//  KQ_MusicPlayer
//
//  Created by 吴凯强 on 15/12/28.
//  Copyright © 2015年 吴凯强. All rights reserved.
//

#import "DataBaseTool.h"

static DataBaseTool * dbHandle = nil;

@implementation DataBaseTool

static sqlite3 *db = nil;

+(instancetype) shareDataBase
{
    if (dbHandle == nil) {
        dbHandle = [[DataBaseTool alloc] init];
    }
    return dbHandle;
}

-(int)connectDB:(NSString *)filePath{
    
    int result = sqlite3_open(filePath.UTF8String, &db);
    if (result == SQLITE_OK) {
        return 0;
    }
    else
    {
        return -1;
    }
}

-(int)disconnectDB
{
    int result = sqlite3_close(db);
    if (result != SQLITE_OK) {
        return -1;
    }
    db = nil;
    return 0;
}

-(int)execDDLSql:(NSString *)sql
{
    char * errmsg = NULL;
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errmsg);
    if (result == SQLITE_OK) {
        return 0 ;
    }
    else
    {
        NSLog(@"%s",errmsg); // 这里应该是写日志的. mypantone
        return -1;
    }
}

-(int)execDMLSql:(NSString *)sql
{
    char * errmsg = NULL;
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errmsg);
    if (result == SQLITE_OK) {
        return 0 ;
    }
    else
    {
        NSLog(@"%s",errmsg); // 这里应该是写日志的. mypantone
        // rollback;
        return -1;
    }
}

-(int)sqlCount:(NSString *)sql
{
    sqlite3_stmt * stmt = nil;
    
    int result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
    
    int count = -1;
    
    if (result == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            count = sqlite3_column_int(stmt, 0);
        }
    }
    sqlite3_finalize(stmt);
    return count;
}

-(NSString *)sqlFieldText:(NSString *)sql
{
    sqlite3_stmt * stmt = nil;
    
    int result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
    
    NSString * string = nil;
    
    if (result == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            string = [NSString stringWithFormat:@"%s",sqlite3_column_text(stmt, 0)];
        }
    }
    sqlite3_finalize(stmt);
    return string;
}

-(NSInteger)sqlFieldInt:(NSString *)sql
{
    sqlite3_stmt * stmt = nil;
    
    int result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
    
    NSInteger i = -1;
    
    if (result == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            i = sqlite3_column_int(stmt, 0);
        }
    }
    sqlite3_finalize(stmt);
    return i;
}

-(NSMutableArray *)selectString:(NSString *)sql
{
    NSMutableArray *array = nil;
    sqlite3_stmt * stmt = nil;
    int result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        array = [[NSMutableArray alloc] init];
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSString * string = [NSString string];
            string = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 0)];
            [array addObject:string];
        }
    }
    sqlite3_finalize(stmt);
    return array;
}

#pragma mark --- 音乐表
- (void)createMusicList {
    
    // 准备SQL语句
    NSString *sqlWord = @"create table if not exists MusicPlayerList (\
    trackId INTEGER not null,\
    uid INTEGER,\
    playPathAacv164 text not null,\
    downloadAacUrl text,\
    title text,\
    duration INTEGER,\
    coverSmall text,\
    coverMiddle text,\
    nickname text,\
    smallLogo text,\
    albumId INTEGER,\
    albumTitle text,\
    likes INTEGER,\
    playtimes INTEGER,\
    comments INTEGER,\
    commentsCounts INTEGER,\
    favoritesCounts INTEGER,\
    ID INTEGER,\
    playsCounts INTEGER,\
    sharesCounts INTEGER,\
    primary key (playPathAacv164)\
    )";
    
    //执行SQL语句
    int result = sqlite3_exec(db, [sqlWord UTF8String], NULL, NULL, NULL);
    
    if (result == SQLITE_OK) {
        //NSLog(@"创建表成功!");
    }else {
        // NSLog(@"创建表失败,错误代码:%d",result);
    }
    
}

- (void)createMusicCollectList {
    
    // 准备SQL语句
    NSString *sqlWord = @"create table if not exists MusicCollectList (\
    trackId INTEGER not null,\
    uid INTEGER,\
    playPathAacv164 text not null,\
    downloadAacUrl text,\
    title text,\
    duration INTEGER,\
    coverSmall text,\
    coverMiddle text,\
    nickname text,\
    smallLogo text,\
    albumId INTEGER,\
    albumTitle text,\
    likes INTEGER,\
    playtimes INTEGER,\
    comments INTEGER,\
    commentsCounts INTEGER,\
    favoritesCounts INTEGER,\
    ID INTEGER,\
    playsCounts INTEGER,\
    sharesCounts INTEGER,\
    primary key (playPathAacv164)\
    )";
    
    //执行SQL语句
    int result = sqlite3_exec(db, [sqlWord UTF8String], NULL, NULL, NULL);
    
    if (result == SQLITE_OK) {
        //NSLog(@"创建表成功!");
    }else {
        // NSLog(@"创建表失败,错误代码:%d",result);
    }
    
    
}


- (int)insertMusicPlayer:(WGHAlbumListModel *)model {
    
    //设置错误码
    int result = 0;
    //拼写执行的sql
    NSString *sql = @"insert into MusicPlayerList (trackId,\
    uid,\
    playPathAacv164,\
    downloadAacUrl,\
    title,\
    duration,\
    coverSmall,\
    coverMiddle,\
    nickname,\
    smallLogo,\
    albumId,\
    albumTitle,\
    likes,\
    playtimes,\
    comments,\
    commentsCounts,\
    favoritesCounts,\
    ID,\
    playsCounts,\
    sharesCounts) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    //定义声明伴随指针
    sqlite3_stmt * stmt = nil;
    //开始逐一绑定参数
    if (sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        
        sqlite3_bind_text(stmt, 1, [model.trackId stringValue].UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 2, [model.uid stringValue].UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 3, model.playPathAacv164.UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 4, model.downloadAacUrl.UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 5, model.title.UTF8String, -1, NULL);
        sqlite3_bind_double(stmt, 6, model.duration);
        sqlite3_bind_text(stmt, 7, model.coverSmall.UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 8, model.coverMiddle.UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 9, model.nickname.UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 10, model.smallLogo.UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 11, [model.albumId stringValue].UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 12, model.albumTitle.UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 13, [model.likes stringValue].UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 14, [model.playtimes stringValue].UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 15, [model.comments stringValue].UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 16, [model.commentsCounts stringValue].UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 17, [model.favoritesCounts stringValue].UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 18, [model.ID stringValue].UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 19, [model.playsCounts stringValue].UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 20, [model.sharesCounts stringValue].UTF8String, -1, NULL);
        
        result = sqlite3_step(stmt);
        if (result == SQLITE_DONE) {
            NSLog(@"插入数据成功");
            result = SQLITE_DONE;
        }else if (result == SQLITE_CONSTRAINT) {
            NSLog(@"已经插入过");
            result = SQLITE_CONSTRAINT;
        }
        //关闭伴随指针
        sqlite3_finalize(stmt);
    }else {
        
        NSLog(@"预执行失败");
        result = -1;
    }
    return result;
    
    
    
}
- (NSMutableArray *)selectAllMusicPlaye:(NSString *)condition {
    
    NSMutableArray *array = [NSMutableArray array];
    //准备伴随指针
    sqlite3_stmt *stmt = nil;
    
    //拼写sql
    NSString *sql = @"select trackId,\
    uid,\
    playPathAacv164,\
    downloadAacUrl,\
    title,\
    duration,\
    coverSmall,\
    coverMiddle,\
    nickname,\
    smallLogo,\
    albumId,\
    albumTitle,\
    likes,\
    playtimes,\
    comments,\
    commentsCounts,\
    favoritesCounts,\
    ID,\
    playsCounts,\
    sharesCounts  from MusicPlayerList where ? ";
    
    //预执行
    int result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
    //如果预执行成功则开始移动游标
    if (result == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, condition.UTF8String, -1, NULL);
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            WGHAlbumListModel *model = [[WGHAlbumListModel alloc] init];
            model.trackId = [NSNumber numberWithInteger:sqlite3_column_int(stmt, 0)];
            model.uid = [NSNumber numberWithInteger:sqlite3_column_int(stmt, 1)];
            model.playPathAacv164 = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            model.downloadAacUrl = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
            model.title = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
            
            model.duration = sqlite3_column_double(stmt, 5);
            
            model.coverSmall = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 6)];
            model.coverMiddle = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 7)];
            model.nickname = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 8)];
            model.smallLogo = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 9)];
            
            model.albumId = [NSNumber numberWithInteger:sqlite3_column_int(stmt, 10)];
            model.albumTitle = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 11)];
            model.likes = [NSNumber numberWithInteger:sqlite3_column_int(stmt, 12)];
            model.playtimes = [NSNumber numberWithInteger:sqlite3_column_int(stmt, 13)];
            model.comments = [NSNumber numberWithInteger:sqlite3_column_int(stmt, 14)];
            model.commentsCounts = [NSNumber numberWithInteger:sqlite3_column_int(stmt, 15)];
            model.favoritesCounts = [NSNumber numberWithInteger:sqlite3_column_int(stmt, 16)];
            model.ID = [NSNumber numberWithInteger:sqlite3_column_int(stmt, 17)];
            model.playsCounts = [NSNumber numberWithInteger:sqlite3_column_int(stmt, 18)];
            model.sharesCounts = [NSNumber numberWithInteger:sqlite3_column_int(stmt, 19)];
            
            //将model加入到数组,等待数组返回
            [array addObject:model];
        }
    }
    
    return array;
    
}

- (int)insertCollectMusicPlayer:(WGHAlbumListModel *)model {
    
    //设置错误码
    int result = 0;
    //拼写执行的sql
    NSString *sql = @"insert into MusicCollectList (trackId,\
    uid,\
    playPathAacv164,\
    downloadAacUrl,\
    title,\
    duration,\
    coverSmall,\
    coverMiddle,\
    nickname,\
    smallLogo,\
    albumId,\
    albumTitle,\
    likes,\
    playtimes,\
    comments,\
    commentsCounts,\
    favoritesCounts,\
    ID,\
    playsCounts,\
    sharesCounts) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    //定义声明伴随指针
    sqlite3_stmt * stmt = nil;
    //开始逐一绑定参数
    if (sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        
        sqlite3_bind_text(stmt, 1, [model.trackId stringValue].UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 2, [model.uid stringValue].UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 3, model.playPathAacv164.UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 4, model.downloadAacUrl.UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 5, model.title.UTF8String, -1, NULL);
        sqlite3_bind_double(stmt, 6, model.duration);
        sqlite3_bind_text(stmt, 7, model.coverSmall.UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 8, model.coverMiddle.UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 9, model.nickname.UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 10, model.smallLogo.UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 11, [model.albumId stringValue].UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 12, model.albumTitle.UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 13, [model.likes stringValue].UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 14, [model.playtimes stringValue].UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 15, [model.comments stringValue].UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 16, [model.commentsCounts stringValue].UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 17, [model.favoritesCounts stringValue].UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 18, [model.ID stringValue].UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 19, [model.playsCounts stringValue].UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 20, [model.sharesCounts stringValue].UTF8String, -1, NULL);
        
        result = sqlite3_step(stmt);
        if (result == SQLITE_DONE) {
            NSLog(@"插入数据成功");
            result = SQLITE_DONE;
        }else if (result == SQLITE_CONSTRAINT) {
            NSLog(@"已经插入过");
            result = SQLITE_CONSTRAINT;
        }
        //关闭伴随指针
        sqlite3_finalize(stmt);
    }else {
        
        NSLog(@"预执行失败");
        result = -1;
    }
    return result;
    
}

- (NSMutableArray *)selectAllCollectMusicPlaye:(NSString *)condition {
    
    NSMutableArray *array = [NSMutableArray array];
    //准备伴随指针
    sqlite3_stmt *stmt = nil;
    
    //拼写sql
    NSString *sql = @"select trackId,\
    uid,\
    playPathAacv164,\
    downloadAacUrl,\
    title,\
    duration,\
    coverSmall,\
    coverMiddle,\
    nickname,\
    smallLogo,\
    albumId,\
    albumTitle,\
    likes,\
    playtimes,\
    comments,\
    commentsCounts,\
    favoritesCounts,\
    ID,\
    playsCounts,\
    sharesCounts  from MusicCollectList where ? ";
    
    //预执行
    int result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
    //如果预执行成功则开始移动游标
    if (result == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, condition.UTF8String, -1, NULL);
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            WGHAlbumListModel *model = [[WGHAlbumListModel alloc] init];
            model.trackId = [NSNumber numberWithInteger:sqlite3_column_int(stmt, 0)];
            model.uid = [NSNumber numberWithInteger:sqlite3_column_int(stmt, 1)];
            model.playPathAacv164 = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            model.downloadAacUrl = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
            model.title = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
            model.duration = sqlite3_column_double(stmt, 5);
            model.coverSmall = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 6)];
            model.coverMiddle = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 7)];
            model.nickname = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 8)];
            model.smallLogo = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 9)];
            
            model.albumId = [NSNumber numberWithInteger:sqlite3_column_int(stmt, 10)];
            model.albumTitle = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 11)];
            model.likes = [NSNumber numberWithInteger:sqlite3_column_int(stmt, 12)];
            model.playtimes = [NSNumber numberWithInteger:sqlite3_column_int(stmt, 13)];
            model.comments = [NSNumber numberWithInteger:sqlite3_column_int(stmt, 14)];
            model.commentsCounts = [NSNumber numberWithInteger:sqlite3_column_int(stmt, 15)];
            model.favoritesCounts = [NSNumber numberWithInteger:sqlite3_column_int(stmt, 16)];
            model.ID = [NSNumber numberWithInteger:sqlite3_column_int(stmt, 17)];
            model.playsCounts = [NSNumber numberWithInteger:sqlite3_column_int(stmt, 18)];
            model.sharesCounts = [NSNumber numberWithInteger:sqlite3_column_int(stmt, 19)];
            
            
            //将model加入到数组,等待数组返回
            [array addObject:model];
        }
    }
    
    return array;
    
}


#pragma mark ------广播播放历史-------
//创建表
- (void)createBroadcastHistoryList {
    /*
     CREATE TABLE "BroadcastHistoryList" ("radioId" TEXT PRIMARY KEY NOT NULL, "picPath" TEXT, "radioPlayCount" TEXT, "radioPlayUrl" TEXT, "rname" TEXT, "programId" TEXT, "programName" TEXT, "programScheduleId" TEXT, "radioCoverLarge" TEXT, "radioCoverSmall" TEXT);
     */
    
    
    // 准备SQL语句
    NSString *sqlWord = @"create table if not exists BroadcastHistoryList (\
    radioId TEXT PRIMARY KEY NOT NULL,\
    radioPlayCount TEXT,\
    radioPlayUrl BLOB,\
    rname TEXT,\
    programId TEXT,\
    programName TEXT,\
    programScheduleId TEXT,\
    radioCoverLarge TEXT,\
    radioCoverSmall TEXT,\
    picPath text\
    )";
    
    //执行SQL语句
    int result = sqlite3_exec(db, [sqlWord UTF8String], NULL, NULL, NULL);
    
    if (result == SQLITE_OK) {
        DLog(@"创建表成功!");
    }else {
        DLog(@"创建表失败,错误代码:%d",result);
    }
    
}


//插入排行播放数据
- (int)insertBroadcastHistoryTop:(GD_BroadcastTopRadioModel *)model {
    
    //设置错误码
    int result = 0;
    //拼写执行的sql
    NSString *sql = @"insert into BroadcastHistoryList (\
    radioId,\
    radioPlayCount,\
    radioPlayUrl,\
    rname,\
    programId,\
    programName,\
    programScheduleId,\
    radioCoverLarge,\
    radioCoverSmall,\
    picPath\
    ) values (?,?,?,?,?,?,?,?,?,?)";
    //定义声明伴随指针
    sqlite3_stmt * stmt = nil;
    //开始逐一绑定参数
    if (sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        
        sqlite3_bind_text(stmt, 1, [model.radioId stringValue].UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 2, [model.radioPlayCount stringValue].UTF8String, -1, NULL);
        
        //插入字典
        //将广播URL归档为NSData类型
        NSData *radioPlayUrlData = [NSKeyedArchiver archivedDataWithRootObject:model.radioPlayUrl];
        //向表中插入二进制
        sqlite3_bind_blob(stmt, 3, [radioPlayUrlData bytes], (int)[radioPlayUrlData length], NULL);
        
        sqlite3_bind_text(stmt, 4, model.rname.UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 5, [model.programId stringValue]
                          .UTF8String,-1,NULL);
        sqlite3_bind_text(stmt, 6, model.programName.UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 7, [model.programScheduleId stringValue].UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 8, model.radioCoverLarge.UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 9, model.radioCoverSmall.UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 10, model.picPath.UTF8String, -1, NULL);

        result = sqlite3_step(stmt);
        if (result == SQLITE_DONE) {
            NSLog(@"插入数据成功");
            result = SQLITE_DONE;
        }else if (result == SQLITE_CONSTRAINT) {
            NSLog(@"已经插入过");
            result = SQLITE_CONSTRAINT;
        }
        //关闭伴随指针
        sqlite3_finalize(stmt);
    }else {
        DLog(@"预执行失败");
        result = -1;
    }
    return result;
}



//查询数据
- (NSMutableArray *)selectAllBroadcastHistoryPlaye:(NSString *)condition {
    
    NSMutableArray *array = [NSMutableArray array];
    //准备伴随指针
    sqlite3_stmt *stmt = nil;
    
    //拼写sql
    NSString *sql = @"select\
    radioId,\
    radioPlayCount,\
    radioPlayUrl,\
    rname,\
    programId,\
    programName,\
    programScheduleId,\
    radioCoverLarge,\
    radioCoverSmall,\
    picPath\
    from BroadcastHistoryList where ? ";
    
    //预执行
    int result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
    //如果预执行成功则开始移动游标
    if (result == SQLITE_OK) {
        //开始绑定参数
        sqlite3_bind_text(stmt, 1, condition.UTF8String, -1, NULL);
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            GD_BroadcastTopRadioModel *topModel = [[GD_BroadcastTopRadioModel alloc]init];
            topModel.radioId = [NSNumber numberWithInteger:sqlite3_column_int(stmt, 0)];
            topModel.radioPlayCount = [NSNumber numberWithInteger:sqlite3_column_int(stmt, 1)];
            
            //取Blob类型的广播地址
            int length = sqlite3_column_bytes(stmt, 2);
            //将数据库中二进制取出，转换成NSData类型
            NSData *radioPlayUrlData = [NSData dataWithBytes:sqlite3_column_blob(stmt, 2) length:length];
            //将NSData反归档为NSDictionary
            topModel.radioPlayUrl = [NSKeyedUnarchiver unarchiveObjectWithData:radioPlayUrlData];
            
            topModel.rname = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
            topModel.programId = [NSNumber numberWithInteger:sqlite3_column_int(stmt, 4)];
            topModel.programName = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 5)];
            topModel.programScheduleId = [NSNumber numberWithInteger:sqlite3_column_int(stmt, 6)];
            topModel.radioCoverLarge = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 7)];
            topModel.radioCoverSmall = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 8)];
            topModel.picPath = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 8)];
            //将model加入数组，等待数组返回
            [array addObject:topModel];
        
        }
    }
    return array;
}






#pragma mark --- 存录音
- (int)insertRecordName:(NSString *)recordName {
    
    //设置错误码
    int result = 0;
    //拼写执行的sql
    NSString *sql = @"insert into RecordList (name) values (?)";
    //定义声明伴随指针
    sqlite3_stmt * stmt = nil;
    //开始逐一绑定参数
    if (sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        
        sqlite3_bind_text(stmt, 1, recordName.UTF8String, -1, NULL);
        
        result = sqlite3_step(stmt);
        if (result == SQLITE_DONE) {
            NSLog(@"插入数据成功");
            result = SQLITE_DONE;
        }else if (result == SQLITE_CONSTRAINT) {
            NSLog(@"已经插入过");
            result = SQLITE_CONSTRAINT;
        }
        //关闭伴随指针
        sqlite3_finalize(stmt);
    }else {
        
        NSLog(@"预执行失败");
        result = -1;
    }
    return result;
    
}
- (NSMutableArray *)selectAllRecord:(NSString *)condition {
    
    NSMutableArray *array = [NSMutableArray array];
    //准备伴随指针
    sqlite3_stmt *stmt = nil;
    
    //拼写sql
    NSString *sql = @"select name  from RecordList where ? ";
    
    //预执行
    int result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
    //如果预执行成功则开始移动游标
    if (result == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, condition.UTF8String, -1, NULL);
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            RecordListModel *model = [RecordListModel new];
            model.name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 0)];
            //将model加入到数组,等待数组返回
            [array addObject:model];
        }
    }
    
    return array;
    
}





@end
