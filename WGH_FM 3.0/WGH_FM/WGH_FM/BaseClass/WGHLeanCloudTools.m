//
//  WGHLeanCloudTools.m
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/21.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHLeanCloudTools.h"

@implementation WGHLeanCloudTools

static WGHLeanCloudTools *lp = nil;
+ (instancetype)sharedLeanUserTools {
    if (lp == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            lp = [[WGHLeanCloudTools alloc] init];
        });
    }
    return lp;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    @synchronized(lp) {
        if (!lp) {
            lp = [super allocWithZone:zone];
        }
        return lp;
    }
}

- (instancetype)init {
    @synchronized(self) {
        self = [super init];
    }
    return self;
}

- (id)copy {
    return self;
}

- (id)mutableCopy {
    return self;
}

//通过NSDictionnary登录
- (void)loginWithUsername:(NSDictionary *)dict passVlueBlock:(passValue)passvalue{
    [AVUser logInWithUsernameInBackground:dict[@"username"] password:dict[@"password"] block:^(AVUser *user, NSError *error) {
        if (user != nil) {
            passvalue(YES);
        } else {
            passvalue(NO);
        }
    }];
}
//通过phonenumber登录
- (void)loginWithPhone:(NSDictionary *)dict passVlueBlock:(passValue)passvalue{
    [AVUser logInWithMobilePhoneNumberInBackground:dict[@"mobilePhoneNumber"] password:dict[@"password"] block:^(AVUser *user, NSError *error) {
        if (user != nil) {
            passvalue(YES);
        } else {
            passvalue(NO);
        }
    }];
}

//是否已经登录
- (BOOL)isLoggedIn {
    BOOL result = 0;
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser != nil) {
        result = YES;
    }
    return result;
    
}
//退出登录
- (void)logOut {
    [AVUser logOut];  //清除缓存用户对象
    
}

//当前用户名
- (NSString *)user {
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser != nil) {
        return currentUser.username;
    }
    return @"currentuserisnil";
}


//通过NSDictionary注册
- (void)registWithDictionary:(NSDictionary *)dict passVlueBlock:(passValue)passvalue{
    AVUser *user = [AVUser user];
    user.username = dict[@"username"];
    user.password =  dict[@"password"];
    user.email = dict[@"email"];    
//    user.mobilePhoneNumber = dict[@"mobilePhoneNumber"];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            passvalue(YES);
        } else {
            passvalue(NO);
        }
    }];
}


//通过邮箱找回密码
- (void)resetPasswordWithEmail:(NSString *)email passVlueBlock:(passValue)passvalue{
    [AVUser requestPasswordResetForEmailInBackground:email block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            passvalue(YES);
        } else {
            passvalue(NO);
        }
    }];
}
//通过NSDictionary修改密码
- (void)changePassWordWithDictionary:(NSDictionary *)dict passVlueBlock:(passValue)passvalue{
    if ([self isLoggedIn]) {
        [[AVUser currentUser] updatePassword:dict[@"password"] newPassword:dict[@"newpassword"] block:^(id object, NSError *error) {
            if (error) {
                passvalue(NO);
            }else {
                passvalue(YES);
            }
        }];
    }else {
        passvalue(NO);
    }
}

// 通过手机重置密码
- (void)resetPasswordWithPhoneNumber:(NSString *)phone passVlueBlock:(passValue)passvalue{
    
    [AVUser requestPasswordResetWithPhoneNumber:phone block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            passvalue(YES);
            
        } else {
            passvalue(NO);
            NSLog(@"%@",error);
        }
    }];
}

// 验证邮箱
- (void)requestUserWithEmail:(NSString *)email passVlueBlock:(passValue)passvalue{
    if ([self isLoggedIn]) {
        [AVUser requestEmailVerify:email withBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                passvalue(YES);
            }else {
                passvalue(NO);
            }
        }];
    }
}

// 验证手机号
- (void)requestUserWithPhone:(NSString *)phone passVlueBlock:(passValue)passvalue{
    
    if ([self isLoggedIn]) {
        [AVUser requestMobilePhoneVerify:phone withBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                passvalue(YES);
            }else {
                passvalue(NO);
            }
        }];
    }
}
// 发送验证码
- (void)sendPhoneVerificationCode:(NSString *)code passVlueBlock:(passValue)passvalue{
    
    if ([self isLoggedIn]) {
        [AVUser  verifyMobilePhone:code withBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                passvalue(YES);
            }else {
                passvalue(NO);
            }
        }];
    }
    
}















@end
