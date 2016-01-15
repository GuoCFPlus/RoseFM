//
//  WGHRequestData.m
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/13.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHRequestData.h"

@implementation WGHRequestData

static WGHRequestData *request = nil;
+ (instancetype)shareRequestData {
    
    if (request == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            request = [[WGHRequestData alloc] init];
        });
    }
    return request;
}

- (void)requestRecommendScrollWithURL:(NSString *)urlStr block:(void (^)(NSMutableArray *))block {
    AFHTTPRequestOperationManager * manger = [AFHTTPRequestOperationManager manager];
    [manger GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        NSArray * array = [dic[@"focusImages"] objectForKey:@"list"];
        self.dataArray=[NSMutableArray array];
        for (NSDictionary *dict in array) {
            WGHRecommendSrollModel * model = [WGHRecommendSrollModel new];
            [model setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:model];
        }
        
        block(self.dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


//请求数据
- (void)requestListParsenDataWithURL:(NSString *)urlStr block:(void (^)(NSMutableArray *))block {
    AFHTTPRequestOperationManager * manger = [AFHTTPRequestOperationManager manager];
    [manger GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        NSArray * array = dic[@"list"];
        self.dataArray=[NSMutableArray array];
        for (NSDictionary *dict in array) {
            WGHShowListModel * showListModel = [WGHShowListModel new];
            [showListModel setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:showListModel];
        }
        block(self.dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}

- (void)requestClassFyListDataWithURL:(NSString *)urlStr block:(void (^)(NSMutableArray *))block {
    
    AFHTTPRequestOperationManager * manger = [AFHTTPRequestOperationManager manager];
    [manger GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        NSArray * array = dic[@"list"];
        self.dataArray=[NSMutableArray array];
        for (NSDictionary *dict in array) {
            WGHClassFyModel * model = [WGHClassFyModel new];
            [model setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:model];
        }
        block(self.dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}























@end
