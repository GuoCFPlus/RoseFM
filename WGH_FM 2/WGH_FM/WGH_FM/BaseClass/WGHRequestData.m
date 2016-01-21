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

// 解析某个分类下的titlenames

- (void)requestOneClassFyTitleNamesWithIDURL:(NSString *)urlStr block:(void (^)(NSMutableDictionary *))block {
    
    AFHTTPRequestOperationManager * manger = [AFHTTPRequestOperationManager manager];
    [manger GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        NSArray * array = dic[@"list"];
        NSMutableArray *titles =[NSMutableArray array];
        NSNumber *ID = nil;
        self.dictionary = [NSMutableDictionary dictionary];
        for (NSDictionary *dict in array) {
            [titles addObject:dict[@"tname"]];
            ID = dict[@"category_id"];
        }
        [self.dictionary setObject:titles forKey:ID];
        block(self.dictionary);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}


- (void)requestAlbumListDataWithURL:(NSString *)urlStr block:(AlbumBlock)block {
    
    AFHTTPRequestOperationManager * manger = [AFHTTPRequestOperationManager manager];
    [manger GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        NSArray * array = [dic[@"tracks"] objectForKey:@"list"];
        self.dataArray=[NSMutableArray array];
        self.dictionary = [NSMutableDictionary dictionary];
        self.dictionary = dic[@"album"];
        for (NSDictionary *dict in array) {
            WGHAlbumListModel * model = [WGHAlbumListModel new];
            [model setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:model];
        }
        
        block(self.dataArray,self.dictionary);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}


#pragma mark ------广播-------
//推荐电台
- (void)requestClassBRDataWithURL:(NSString *)urlStr block:(void (^)(NSMutableArray *))block {
    
    AFHTTPRequestOperationManager * manger = [AFHTTPRequestOperationManager manager];
    [manger GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        NSArray * array = [dic[@"result"] valueForKey:@"recommandRadioList"];
        self.dataArray=[NSMutableArray array];
        for (NSDictionary *dict in array) {
            GD_BroadcastRecommandRadioList * model = [[GD_BroadcastRecommandRadioList alloc]initWithDictionary:dict];
            [self.dataArray addObject:model];
        }
        block(self.dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

//排行榜
- (void)requestClassBTDataWithURL:(NSString *)urlStr block:(void (^)(NSMutableArray *))block {
    
    AFHTTPRequestOperationManager * manger = [AFHTTPRequestOperationManager manager];
    [manger GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        NSArray * array = [dic[@"result"] valueForKey:@"topRadioList"];
        self.dataArray=[NSMutableArray array];
        for (NSDictionary *dict in array) {
            GD_BroadcastTopRadioModel * model = [[GD_BroadcastTopRadioModel alloc]initWithDictionary:dict];
            [self.dataArray addObject:model];
        }
        block(self.dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

//广播播放页
- (void)requestClassBPDataWithURL:(NSString *)urlStr block:(void (^)(GD_BroadcastPlayModel *))block {
    
    AFHTTPRequestOperationManager * manger = [AFHTTPRequestOperationManager manager];
    [manger GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        
        GD_BroadcastPlayModel * model = [[GD_BroadcastPlayModel alloc]initWithDictionary:dic[@"result"]];
        block(model);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

//本地台解析
- (void)requestClassBroadcastTypeDataWithURL:(NSString *)urlStr block:(void (^)(NSMutableArray *))block {
    
    AFHTTPRequestOperationManager * manger = [AFHTTPRequestOperationManager manager];
    [manger GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        NSArray * array = dic[@"result"];
        self.dataArray=[NSMutableArray array];
        for (NSDictionary *dict in array) {
            GD_BroadcastTopRadioModel * model = [[GD_BroadcastTopRadioModel alloc]initWithDictionary:dict];
            [self.dataArray addObject:model];
        }
        block(self.dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

//省市解析
- (void)requestClassBroadcastProvinceDataWithURL:(NSString *)urlStr block:(void (^)(NSMutableArray *))block {
    
    AFHTTPRequestOperationManager * manger = [AFHTTPRequestOperationManager manager];
    [manger GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        NSArray * array = dic[@"result"];
        self.dataArray=[NSMutableArray array];
        for (NSDictionary *dict in array) {
            GD_ProvinceModel * model = [[GD_ProvinceModel alloc]initWithDictionary:dict];
            [self.dataArray addObject:model];
        }
        block(self.dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}


// 榜单 数据解析
// 主页面

- (void)requestHotListDataWithURL:(NSString *)urlStr block:(AlbumBlock)block {
    
    AFHTTPRequestOperationManager * manger = [AFHTTPRequestOperationManager manager];
    [manger GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        NSArray * array = dic[@"datas"];
        self.dataArray = [NSMutableArray array];
        self.dictionary = [NSMutableDictionary dictionary];
        self.dictionary = [[dic[@"focusImages"] objectForKey:@"list"] firstObject];
        for (NSDictionary *dict1 in array) {
            NSMutableArray *arr = [NSMutableArray array];
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            for (NSDictionary *dict2 in dict1[@"list"]) {
                WGHHotListModel * model = [WGHHotListModel new];
                model.subtitle1 = [dict2[@"firstKResults"][0] objectForKey:@"title"];
                model.subtitle2 = [dict2[@"firstKResults"][1] objectForKey:@"title"];
                model.subtitle3 = [dict2[@"firstKResults"][2] objectForKey:@"title"];
                [model setValuesForKeysWithDictionary:dict2];
                [arr addObject:model];
            }
            [dictionary setObject:arr forKey:dict1[@"title"]];
            [self.dataArray addObject:dictionary];
        }
        block(self.dataArray,self.dictionary);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    
}

// 具体某个排行榜榜单
- (void)requestOneHotListDataWithURL:(NSString *)urlStr block:(void (^)(NSMutableArray *))block {
    
    AFHTTPRequestOperationManager * manger = [AFHTTPRequestOperationManager manager];
    [manger GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        NSArray * array = dic[@"list"];
        self.dataArray=[NSMutableArray array];
        for (NSDictionary *dict in array) {
            WGHHotListDetailsModel * model = [WGHHotListDetailsModel new];
            [model setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:model];
        }
        
        block(self.dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    
}



@end
