//
//  WGHChatRoom.h
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/21.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudIM/AVOSCloudIM.h>

typedef void(^backArray)(NSArray * roomList);
typedef void(^Success)(BOOL success,NSError * error);


@interface WGHChatRoom : NSObject

@property(nonatomic,strong)AVIMClient * imClient;

// 创建的聊天室连接
@property(nonatomic,strong)AVIMConversation *conversation;

// 聊天室的 ID
@property(nonatomic,strong)NSString * conversationID;

// 该用户收到的消息数组
@property(nonatomic,strong)NSMutableArray * messageArray;

// 返回所有聊天列表
-(void)printChatRoomList:(backArray)backArray;

// 创建聊天室
-(void)createRoomWithClientID:(NSString *)aClientID RoomName:(NSString *)roomName callback:(Success)success;

// 创建长连接
-(void)connectServerWithClientID:(NSString *)aClientID :(Success)success;

//// 加入聊天室
-(void)joinConversation:(Success)success;

// 发送消息
-(void)sendMessage:(NSString *)amessage callback:(Success)success;

// 查找聊天室是否存在并且加入
-(void)findChatRoomWithnameID:(NSString *)nameID callback:(Success)success;

// 退出聊天室
-(void)logOut:(Success)success;

// 单例方法
+ (instancetype)shareChatRoomHandle;





@end
