//
//  NetworkTool.h
//  HealthMonitor
//
//  Created by WRQ on 2019/4/25.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSUInteger, HTTPMethod) {
    GET = 0,
    POST,
    PUT,
    DELETE,
};

NS_ASSUME_NONNULL_BEGIN

@interface NetworkTool : AFHTTPSessionManager

typedef void (^FinishedCallBack) (id _Nullable result, NSError * _Nullable error);

+ (instancetype)sharedTool;

- (void)parentMessageWithNickname:(NSString *)nickname finished:(FinishedCallBack)finished;

- (void)parentCheckWithNickname:(NSString *)nickName finished:(FinishedCallBack)finished;

- (void)parentUpdateWithNickname:(NSString *)nickname
                        password:(NSString *)password
                        birthday:(NSString *)birthday
                          gender:(NSString *)gender
                    healthStatus:(NSInteger)healthStatus
                        medicine:(NSInteger) medicine
                            name:(NSString *)name
                        finished:(FinishedCallBack)finished;

- (void)parentRegisterWithNickname:(NSString *)nickname
                          password:(NSString *)password
                          birthday:(NSString *)birthday
                            gender:(NSString *)gender
                      healthStatus:(NSInteger)healthStatus
                          medicine:(NSInteger) medicine
                              name:(NSString *)name
                          finished:(FinishedCallBack)finished;

- (void)parentLoginWithNickname:(NSString *)nickName password:(NSString *)password finished:(FinishedCallBack)finished;

@end

NS_ASSUME_NONNULL_END
