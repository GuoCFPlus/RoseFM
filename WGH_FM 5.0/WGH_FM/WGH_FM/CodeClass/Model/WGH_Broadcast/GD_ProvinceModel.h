//
//  GD_ProvinceModel.h
//  WGH_FM
//
//  Created by lanou3g on 16/1/18.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GD_ProvinceModel : NSObject

//"provinceCode": 110000,
//"provinceName": "北京"

@property (strong, nonatomic) NSString *provinceCode;
@property (strong, nonatomic) NSString *provinceName;

-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end
