//
//  GD_BroadcastRecommandRadioList.m
//  WGH_FM
//
//  Created by lanou3g on 16/1/15.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "GD_BroadcastRecommandRadioList.h"

@implementation GD_BroadcastRecommandRadioList

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    DLog(@"%@",key);
}

@end
