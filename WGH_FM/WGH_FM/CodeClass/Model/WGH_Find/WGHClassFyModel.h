//
//  WGHClassFyModel.h
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/13.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WGHClassFyModel : NSObject

//@property (strong, nonatomic) NSString *contentType;
@property (strong, nonatomic) NSString *coverPath; // 图片
@property (strong, nonatomic) NSNumber *ID;  // id
//@property (assign, nonatomic) BOOL *isChecked;
//@property (assign, nonatomic) BOOL *isFinished;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *orderNum;
//@property (assign, nonatomic) BOOL *selectedSwitch;
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
