//
//  WGHChatRoom.m
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/21.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHChatRoom.h"


static WGHChatRoom *sd = nil;

@interface WGHChatRoom ()<AVIMClientDelegate>


@end


@implementation WGHChatRoom

-(instancetype)init
{
    self = [super init];
    if (self) {
        _imClient = [[AVIMClient alloc] init];
        _imClient.delegate = self;
        _messageArray = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)shareChatRoomHandle // 用这个.
{
    if (sd == nil) {
        sd = [[WGHChatRoom alloc] init];
    }
    return sd;
}

// 长连接
-(void)connectServerWithClientID:(NSString *)aClientID :(Success)success; {
    [_imClient openWithClientId:aClientID callback:^(BOOL succeeded, NSError *error){
        if (!succeeded) {
            success(NO,error);
        } else {
            success(YES,error);
        }
    }];
}

// 显示所有的聊天室列表
-(void)printChatRoomList:(backArray)backArray {
    
    AVQuery *query = [AVQuery queryWithClassName:@"qiangweiFM"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // 检索成功
            backArray(objects);
        } else {
            // 输出错误信息
            NSLog(@"返回聊天室列表错误:%@", error);
        }
    }];
}

// 创建房间并且自动加入
-(void)createRoomWithClientID:(NSString *)aClientID RoomName:(NSString *)roomName callback:(Success)success{
    NSMutableArray *convMembers = [NSMutableArray arrayWithObjects:aClientID, nil];
    [_imClient createConversationWithName:roomName
                                clientIds:convMembers
                               attributes:@{@"type":@(1)}
                                  options:AVIMConversationOptionNone callback:^(AVIMConversation *conversation, NSError *error)
     {
         if (error) {
             // 出错了 :(
             if (success!=nil) {
                 success(NO,error);
             }
         } else {
             _conversation = conversation;
             if (success!=nil) {
                 success(YES,error);
             }
         }
     }];
}
// 查找聊天室是否存在并进入
-(void)findChatRoomWithnameID:(NSString *)nameID callback:(Success)success
{
    // 根据这个 aConversationID, 搜索到聊天室的 converstion.
    AVIMConversationQuery *query = [self.imClient conversationQuery];
    [query whereKey:@"name" equalTo:nameID];
    [query findConversationsWithCallback:^(NSArray *objects, NSError *error) {
        if (objects.count >0 ) {
            self.conversation = objects[0];
            [self joinConversation:^(BOOL success1, NSError *error) {
                if (success1) {
                    if (success!=nil) {
                        success(YES,error);
                    }
                }
            }];
        }else
        {
            // 查找聊天室失败
            if (success!=nil) {
                success(NO,error);
            }
        }
    }];
}


#pragma mark 加入聊天室
-(void)joinConversation:(Success)success
{
    [_conversation joinWithCallback:^(BOOL succeeded, NSError *error){
        if (!succeeded) {
            // 出错了 :(
            if (success!=nil) {
                success(NO,error);
            }
        } else {
            // 成功！
            if (success!=nil) {
                success(YES,error);
            }
        }
    }];
}

#pragma mark 发送消息
-(void)sendMessage:(NSString *)amessage callback:(Success)success
{
    // 构造消息
    AVIMMessage * message = [AVIMMessage messageWithContent:amessage];
    
    // 发送消息
    [_conversation sendMessage:message callback:^(BOOL succeeded, NSError *error){
        if (!succeeded) {
            // 出错了 :(
            if (success!=nil) {
                success(NO,error);
            }
        } else {
            // 成功！
            if (success!=nil) {
                success(YES,error);
            }
        }
    }];
}

#pragma mark 接收消息-- 代理方法
-(void)conversation:(AVIMConversation *)conversation didReceiveCommonMessage:(AVIMMessage *)message {
    [self.messageArray addObject:message];
}

#pragma  mark 退出聊天室
-(void)logOut:(Success)success
{
    [_conversation quitWithCallback:^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            if (success!= nil) {
                success(NO,error);
            }
        } else {
            if (success!= nil) {
                success(YES,error);
            }
        }
    }];
}

@end
