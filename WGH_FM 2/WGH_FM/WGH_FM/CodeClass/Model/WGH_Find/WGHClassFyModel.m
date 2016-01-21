//
//  WGHClassFyModel.m
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/13.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHClassFyModel.h"

@implementation WGHClassFyModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end
