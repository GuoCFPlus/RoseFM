//
//  WGHShowClassFyModel.h
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/13.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WGHShowClassFyModel : NSObject

@property (strong, nonatomic) NSString *contentType;
@property (strong, nonatomic) NSString *coverPath;
@property (strong, nonatomic) NSNumber *ID;
@property (strong, nonatomic) NSString *isChecked;
@property (strong, nonatomic) NSString *isFinished;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *orderNum;
@property (strong, nonatomic) NSString *selectedSwitch;
@property (strong, nonatomic) NSString *title;

//"contentType": "album",
//"coverPath": "http://fdfs.xmcdn.com/group16/M00/65/C2/wKgDalXeyw2S5ihtAADtrVK2Q1w613.png",
//"id": 3,
//"isChecked": false,
//"isFinished": true,
//"name": "book",
//"orderNum": 1,
//"selectedSwitch": false,
//"title": "有声书"


@end
