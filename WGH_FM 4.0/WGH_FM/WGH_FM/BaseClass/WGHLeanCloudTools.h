//
//  WGHLeanCloudTools.h
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/21.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^passValue)(BOOL result);
@interface WGHLeanCloudTools : NSObject

@property (nonatomic, strong) passValue passvalue;

+ (instancetype)sharedLeanUserTools;
//通过NSDictionnary登录
- (void)loginWithUsername:(NSDictionary *)dict passVlueBlock:(passValue)passvalue;
//通过phonenumber登录
- (void)loginWithPhone:(NSDictionary *)dict passVlueBlock:(passValue)passvalue;
//是否已经登录
- (BOOL)isLoggedIn;
//退出登录
- (void)logOut;
//当前用户名
- (NSString *)user;

//   /// ///   注册//////
//通过NSDictionary注册
- (void)registWithDictionary:(NSDictionary *)dict passVlueBlock:(passValue)passvalue;
//通过邮箱找回密码
- (void)resetPasswordWithEmail:(NSString *)email passVlueBlock:(passValue)passvalue;
//通过NSDictionary修改密码
- (void)changePassWordWithDictionary:(NSDictionary *)dict passVlueBlock:(passValue)passvalue;

//通过手机重置密码
- (void)resetPasswordWithPhoneNumber:(NSString *)phone passVlueBlock:(passValue)passvalue;


//验证邮箱地址
- (void)requestUserWithEmail:(NSString *)email passVlueBlock:(passValue)passvalue;
//验证手机号
- (void)requestUserWithPhone:(NSString *)phone passVlueBlock:(passValue)passvalue;
// 发送验证码
- (void)sendPhoneVerificationCode:(NSString *)code passVlueBlock:(passValue)passvalue;








@end
