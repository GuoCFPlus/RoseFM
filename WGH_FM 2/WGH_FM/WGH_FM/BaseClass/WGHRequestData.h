//
//  WGHRequestData.h
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/13.
//  Copyright © 2016年 吴凯强. All rights reserved.
//
/// 数据解析  ***********
//***********************************
//***********************************
//***********************************
//***********************************
//***********************************
//***********************************


#import <Foundation/Foundation.h>
#import "GD_BroadcastPlayModel.h"

typedef void(^AlbumBlock)(NSMutableArray *array,NSMutableDictionary *dictionary);
@interface WGHRequestData : NSObject

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableDictionary *dictionary;

+ (instancetype)shareRequestData;



// 请求主界面轮播图
- (void)requestRecommendScrollWithURL:(NSString *)urlStr block:(void (^)(NSMutableArray * array))block;



// 数据请求
- (void)requestListParsenDataWithURL:(NSString *)urlStr block:(void (^)(NSMutableArray * array))block;

// 分类数据请求
- (void)requestClassFyListDataWithURL:(NSString *)urlStr block:(void (^)(NSMutableArray *))block;
// 解析某个分类下的titleNames
- (void)requestOneClassFyTitleNamesWithIDURL:(NSString *)urlStr block:(void (^)(NSMutableDictionary *dictionary))block;



// 专辑列表数据请求
- (void)requestAlbumListDataWithURL:(NSString *)urlStr block:(AlbumBlock)block;

// 广播
#pragma mark ------广播-------
//推荐
- (void)requestClassBRDataWithURL:(NSString *)urlStr block:(void (^)(NSMutableArray *))block;
//排行榜
- (void)requestClassBTDataWithURL:(NSString *)urlStr block:(void (^)(NSMutableArray *))block;

//本地台解析
- (void)requestClassBroadcastTypeDataWithURL:(NSString *)urlStr block:(void (^)(NSMutableArray *))block;
//省市解析
- (void)requestClassBroadcastProvinceDataWithURL:(NSString *)urlStr block:(void (^)(NSMutableArray *))block;

//广播播放页
- (void)requestClassBPDataWithURL:(NSString *)urlStr block:(void (^)(GD_BroadcastPlayModel *))block;



//  榜单  数据解析方法

// 主页面
- (void)requestHotListDataWithURL:(NSString *)urlStr block:(AlbumBlock)block;

// 解析  具体某个榜单 排行榜数据
- (void)requestOneHotListDataWithURL:(NSString *)urlStr block:(void (^)(NSMutableArray * array))block;







@end
