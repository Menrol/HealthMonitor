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

- (void)parentGetChildWithNickname:(NSString *)nickname finished:(FinishedCallBack)finished;

- (void)parentMessageWithNickname:(NSString *)nickname finished:(FinishedCallBack)finished;

- (void)parentCheckWithNickname:(NSString *)nickName finished:(FinishedCallBack)finished;

- (void)parentUpdateWithParamters:(NSDictionary *)parameters
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

- (void)childCheckWithNickname:(NSString *)nickname finished:(FinishedCallBack)finished;

- (void)childRegisterWithNickname:(NSString *)nickname
                         password:(NSString *)password
                              age:(NSInteger)age
                           gender:(NSString *)gender
                             name:(NSString *)name
                         finished:(FinishedCallBack)finished;

- (void)childMessageWithNickname:(NSString *)nickname finished:(FinishedCallBack)finished;

- (void)childLoginWithNickname:(NSString *)nickName password:(NSString *)password finished:(FinishedCallBack)finished;

- (void)childUpdateWithParamters:(NSDictionary *)parameters finished:(FinishedCallBack)finished;

- (void)childGetParentWithNickname:(NSString *)nickname finished:(FinishedCallBack)finished;

- (void)parentChildBindingSaveWithChildCode:(NSString *)childCode
                                     userID:(NSInteger)userID
                                 parentCode:(NSString *)parentCode
                                     status:(NSInteger)status
                                   finished:(FinishedCallBack)finished;

- (void)parentChildBindingDeleteWithChildCode:(NSString *)childCode parentCode:(NSString *)parentCode finished:(FinishedCallBack)finished;

- (void)chapCheckWithNickname:(NSString *)nickname finished:(FinishedCallBack)finished;

- (void)chapRegisterWithAge:(NSInteger)age
                     gender:(NSString *)gender
                       name:(NSString *)name
                   nickname:(NSString *)nickname
                   password:(NSString *)password
             workExperience:(NSString *)workExperience
                   workTime:(NSString *)workTime
                   workType:(NSInteger)workType
                   finished:(FinishedCallBack)finished;

- (void)chapGetMessageWithNickname:(NSString *)nickname finished:(FinishedCallBack)finished;

- (void)chapLoginWithNickname:(NSString *)nickname password:(NSString *)password finished:(FinishedCallBack)finished;

- (void)chapUpdateWithParamters:(NSDictionary *)parameters finished:(FinishedCallBack)finished;

- (void)chapGetParentMessageWithNickname:(NSString *)nickname finished:(FinishedCallBack)finished;

- (void)sendOrderWithAddress:(NSString *)address
                        desc:(NSString *)desc
             emergencyStatus:(NSInteger)emergencyStatus
                   escortEnd:(NSInteger)escortEnd
                 escortStart:(NSInteger)escortStart
                  escortType:(NSInteger)escortType
                healthStatus:(NSInteger)healthStatus
                parentEscort:(NSString *)parentEscort
                    position:(NSString *)position
                    finished:(FinishedCallBack)finished ;

- (void)getParentOrderWithNickname:(NSString *)nickname finished:(FinishedCallBack)finished;

- (void)orderDetailWithOrderNo:(NSString *)orderNo finished:(FinishedCallBack)finished;

- (void)getOrderListWithFinished:(FinishedCallBack)finished;

- (void)getReceivingOrderWithFinished:(FinishedCallBack)finished;

- (void)updateOrderStatusWithOrderStatus:(NSInteger)orderStatus orderID:(NSInteger)orderID finished:(FinishedCallBack)finished;

- (void)chapReceiveOrderWithNickname:(NSString *)nickname orderID:(NSInteger)orderID finished:(FinishedCallBack)finished;

- (void)parentChapBindingSaveWithChapCode:(NSString *)chapCode parentCode:(NSString *)parentCode finished:(FinishedCallBack)finished;

- (void)parentChapBindingDeleteWithChapCode:(NSString *)chapCode parentCode:(NSString *)parentCode finished:(FinishedCallBack)finished;

@end

NS_ASSUME_NONNULL_END
