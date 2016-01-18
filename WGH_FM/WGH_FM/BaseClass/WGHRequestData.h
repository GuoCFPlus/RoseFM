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

@interface WGHRequestData : NSObject

@property (strong, nonatomic) NSMutableArray *dataArray;

+ (instancetype)shareRequestData;


// 请求主界面轮播图
- (void)requestRecommendScrollWithURL:(NSString *)urlStr block:(void (^)(NSMutableArray * array))block;



// 数据请求
- (void)requestListParsenDataWithURL:(NSString *)urlStr block:(void (^)(NSMutableArray * array))block;

// 分类数据请求
- (void)requestClassFyListDataWithURL:(NSString *)urlStr block:(void (^)(NSMutableArray *))block;

#pragma mark ------广播-------
//推荐
- (void)requestClassBRDataWithURL:(NSString *)urlStr block:(void (^)(NSMutableArray *))block;
//排行榜
- (void)requestClassBTDataWithURL:(NSString *)urlStr block:(void (^)(NSMutableArray *))block;

//本地台解析
- (void)requestClassBroadcastTypeDataWithURL:(NSString *)urlStr block:(void (^)(NSMutableArray *))block;
//省市解析
- (void)requestClassBroadcastProvinceDataWithURL:(NSString *)urlStr block:(void (^)(NSMutableArray *))block;

@end
