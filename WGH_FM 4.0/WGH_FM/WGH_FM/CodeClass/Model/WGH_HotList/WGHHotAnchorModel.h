//
//  WGHHotAnchorModel.h
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/21.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WGHHotAnchorModel : NSObject


@property(strong,nonatomic)NSString *intro;
@property(strong,nonatomic)NSNumber *tracksCounts;
@property(strong,nonatomic)NSString *personDescribe;
@property(strong,nonatomic)NSString *middleLogo;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSNumber *uid;
@property (strong, nonatomic) NSNumber *followersCounts;
@property (strong, nonatomic) NSString *largeLogo;

//
//"followersCounts": 369148,
//"isVerified": true,
//"largeLogo": "http://fdfs.xmcdn.com/group9/M01/DE/87/wKgDZlaLjvSwqwBcAAZ_M3IUPH4764_mobile_x_large.jpg",
//"middleLogo": "http://fdfs.xmcdn.com/group9/M01/DE/87/wKgDZlaLjvSwqwBcAAZ_M3IUPH4764_web_x_large.jpg",
//"nickname": "晓希982",
//"personDescribe": "两个人，一些事，爱情的故事",
//"tracksCounts": 184,
//"uid": 7725987
@end
