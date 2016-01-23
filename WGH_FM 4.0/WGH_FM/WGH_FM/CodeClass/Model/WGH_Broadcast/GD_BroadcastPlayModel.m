//
//  GD_BroadcastPlayModel.m
//  WGH_FM
//
//  Created by lanou3g on 16/1/20.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "GD_BroadcastPlayModel.h"

@implementation GD_BroadcastPlayModel
-(instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    DLog(@"%@",key);
}

-(NSString *)description{
    return [NSString stringWithFormat:@"%@",_programName];
}


@end
