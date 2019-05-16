//
//  NetworkTool.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/25.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "NetworkTool.h"

@protocol NetworkToolProxy <NSObject>

@optional
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

@end

@interface NetworkTool()<NetworkToolProxy>

@end

@implementation NetworkTool

#pragma mark - 单例
+ (instancetype)sharedTool {
    static NetworkTool *tool;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:@"http://182.254.208.159:8080/escort/"];
        
        tool = [[self alloc] initWithBaseURL:baseURL];
        
        tool.requestSerializer = [AFJSONRequestSerializer serializer];
    });
    
    return tool;
}

#pragma mark - 父母子女关联请求
- (void)parentChildBindingSaveWithChildCode:(NSString *)childCode parentCode:(NSString *)parentCode finished:(FinishedCallBack)finished {
    NSString *url = @"parent/child/save";
    NSDictionary *parameters = @{@"child": childCode,
                                 @"parent": parentCode,
                                 @"status": @(1)
                                 };
    
    [self requestWithHTTPMethod:POST URLString:url parameters:parameters finished:finished];
}

- (void)parentChildBindingDeleteWithChildCode:(NSString *)childCode parentCode:(NSString *)parentCode finished:(FinishedCallBack)finished {
    NSString *url = @"parent/child/delete";
    NSDictionary *parameters = @{@"child": childCode,
                                 @"parent": parentCode};
    
    [self requestWithHTTPMethod:DELETE URLString:url parameters:parameters finished:finished];
}

#pragma mark - 父母相关请求
- (void)parentGetChildWithNickname:(NSString *)nickname finished:(FinishedCallBack)finished {
    NSString *url = @"parent/batch/child";
    NSDictionary *parameters = @{@"nickname": nickname};
    
    [self requestWithHTTPMethod:GET URLString:url parameters:parameters finished:finished];
}

- (void)parentMessageWithNickname:(NSString *)nickname finished:(FinishedCallBack)finished {
    NSString *url = @"parent/batch";
    NSDictionary *parameters = @{@"nickname": nickname};
    
    [self requestWithHTTPMethod:GET URLString:url parameters:parameters finished:finished];
}

- (void)parentCheckWithNickname:(NSString *)nickName finished:(FinishedCallBack)finished {
    NSString *url = @"parent/check";
    NSDictionary *parameters = @{@"nickname": nickName};
    
    [self requestWithHTTPMethod:GET URLString:url parameters:parameters finished:finished];
}

- (void)parentRegisterWithNickname:(NSString *)nickname password:(NSString *)password birthday:(NSString *)birthday gender:(NSString *)gender healthStatus:(NSInteger)healthStatus medicine:(NSInteger) medicine name:(NSString *)name finished:(FinishedCallBack)finished {
    NSString *url = @"parent/register";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat  = @"yyyy-MM-dd";
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDate *nowDate = [NSDate date];
    NSDate *startDate = [formatter dateFromString:birthday];
    NSDateComponents *compoents = [calender components:NSCalendarUnitYear fromDate:startDate toDate:nowDate options:0];
    NSInteger age = [compoents year];
    if ([compoents month] < 0 || ([compoents month] == 0 && [compoents day] < 0)) {
        age -= 1;
    }
    
    NSDictionary *parameters = @{@"nickname": nickname,
                                 @"password": password,
                                 @"birthday": birthday,
                                 @"age": @(age),
                                 @"gender": gender,
                                 @"healthStatus": @(healthStatus),
                                 @"medicine": @(medicine),
                                 @"name": name
                                 };
    
    [self requestWithHTTPMethod:POST URLString:url parameters:parameters finished:finished];
}

- (void)parentUpdateWithParamters:(NSDictionary *)parameters finished:(FinishedCallBack)finished {
    NSString *url = @"parent/update";
    
    [self requestWithHTTPMethod:PUT URLString:url parameters:parameters finished:finished];
}

- (void)parentLoginWithNickname:(NSString *)nickName password:(NSString *)password finished:(FinishedCallBack)finished {
    NSString *url = @"parent/login";
    NSDictionary *parameters = @{@"nickname": nickName, @"password": password};
    
    [self requestWithHTTPMethod:GET URLString:url parameters:parameters finished:finished];
}

#pragma mark - 子女相关请求
- (void)childCheckWithNickname:(NSString *)nickname finished:(FinishedCallBack)finished {
    NSString *url = @"child/check";
    NSDictionary *parameters = @{@"nickname": nickname};
    
    [self requestWithHTTPMethod:GET URLString:url parameters:parameters finished:finished];
}

- (void)childRegisterWithNickname:(NSString *)nickname password:(NSString *)password age:(NSInteger)age gender:(NSString *)gender name:(NSString *)name finished:(FinishedCallBack)finished {
    NSString *url = @"child/register";
    NSDictionary *parameters = @{@"age": @(age),
                                 @"gender": gender,
                                 @"name": name,
                                 @"nickname": nickname,
                                 @"password": password
                                 };
    
    [self requestWithHTTPMethod:POST URLString:url parameters:parameters finished:finished];
}

- (void)childMessageWithNickname:(NSString *)nickname finished:(FinishedCallBack)finished {
    NSString *url = @"child/batch";
    NSDictionary *parameters = @{@"nickname": nickname};
    
    [self requestWithHTTPMethod:GET URLString:url parameters:parameters finished:finished];
}

- (void)childLoginWithNickname:(NSString *)nickName password:(NSString *)password finished:(FinishedCallBack)finished {
    NSString *url = @"child/login";
    NSDictionary *parameters = @{@"nickname": nickName, @"password": password};
    
    [self requestWithHTTPMethod:GET URLString:url parameters:parameters finished:finished];
}

- (void)childUpdateWithParamters:(NSDictionary *)parameters finished:(FinishedCallBack)finished {
    NSString *url = @"child/update";
    
    [self requestWithHTTPMethod:PUT URLString:url parameters:parameters finished:finished];
}

- (void)childGetParentWithNickname:(NSString *)nickname finished:(FinishedCallBack)finished {
    NSString *url = @"child/batch/parent";
    NSDictionary *parameters = @{@"nickname": nickname};
    
    [self requestWithHTTPMethod:GET URLString:url parameters:parameters finished:finished];
}

#pragma mark - 陪护相关请求
- (void)chapCheckWithNickname:(NSString *)nickname finished:(FinishedCallBack)finished {
    NSString *url = @"escort/check";
    NSDictionary *parameters = @{@"nickname": nickname};
    
    [self requestWithHTTPMethod:GET URLString:url parameters:parameters finished:finished];
}

- (void)chapRegisterWithAge:(NSInteger)age gender:(NSString *)gender name:(NSString *)name nickname:(NSString *)nickname password:(NSString *)password workExperience:(NSString *)workExperience workTime:(NSString *)workTime workType:(NSInteger)workType finished:(FinishedCallBack)finished {
    NSString *url = @"escort/register";
    NSDictionary *parameters = @{@"age": @(age),
                                 @"gender": gender,
                                 @"name": name,
                                 @"nickname": nickname,
                                 @"password": password,
                                 @"workExperience": workExperience,
                                 @"workTime": workTime,
                                 @"workType": @(workType)
                                 };
    
    [self requestWithHTTPMethod:POST URLString:url parameters:parameters finished:finished];
}

- (void)chapGetMessageWithNickname:(NSString *)nickname finished:(FinishedCallBack)finished {
    NSString *url = @"escort/batch";
    NSDictionary *parameters = @{@"nickname": nickname};
    
    [self requestWithHTTPMethod:GET URLString:url parameters:parameters finished:finished];
}

- (void)chapLoginWithNickname:(NSString *)nickname password:(NSString *)password finished:(FinishedCallBack)finished {
    NSString *url = @"escort/login";
    NSDictionary *parameters = @{@"nickname": nickname,
                                 @"password": password
                                 };
    
    [self requestWithHTTPMethod:GET URLString:url parameters:parameters finished:finished];
}

- (void)chapUpdateWithParamters:(NSDictionary *)parameters finished:(FinishedCallBack)finished {
    NSString *url = @"escort/update";
    
    [self requestWithHTTPMethod:PUT URLString:url parameters:parameters finished:finished];
}

- (void)chapGetParentMessageWithNickname:(NSString *)nickname finished:(FinishedCallBack)finished {
    NSString *url = @"escort/batch/parent";
    NSDictionary *parameters = @{@"nickname": nickname};
    
    [self requestWithHTTPMethod:GET URLString:url parameters:parameters finished:finished];
}

#pragma mark - 订单相关请求
- (void)sendOrderWithAddress:(NSString *)address desc:(NSString *)desc emergencyStatus:(NSInteger)emergencyStatus escortEnd:(NSInteger)escortEnd escortStart:(NSInteger)escortStart escortType:(NSInteger)escortType healthStatus:(NSInteger)healthStatus parentEscort:(NSString *)parentEscort position:(NSString *)position finished:(FinishedCallBack)finished {
    NSString *url = @"order/save";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"address": address,
                           @"emergencyStatus": @(emergencyStatus),
                                 @"escortEnd": @(escortEnd),
                               @"escortStart": @(escortStart),
                                @"escortType": @(escortType),
                              @"healthStatus": @(healthStatus),
                              @"parentEscort": parentEscort,
                                  @"position": position}];
    
    if (desc.length > 0) {
        [parameters addEntriesFromDictionary:@{@"desc": desc}];
    }
    
    NSLog(@"%@",parameters);
    
    [self requestWithHTTPMethod:POST URLString:url parameters:parameters finished:finished];
}

- (void)getParentOrderWithNickname:(NSString *)nickname finished:(FinishedCallBack)finished {
    NSString *url = @"order/parent";
    NSDictionary *parameters = @{@"nickname": nickname};
    
    [self requestWithHTTPMethod:GET URLString:url parameters:parameters finished:finished];
}

- (void)orderDetailWithOrderNo:(NSString *)orderNo finished:(FinishedCallBack)finished {
    NSString *url = [NSString stringWithFormat:@"order/%@",orderNo];
    
    [self requestWithHTTPMethod:GET URLString:url parameters:nil finished:finished];
}

- (void)getOrderListWithFinished:(FinishedCallBack)finished {
    NSString *url = @"order/batch/list";
    NSDictionary *parameters = @{@"page": @(1),
                                 @"limit": @(INT_MAX)
                                 };
    
    [self requestWithHTTPMethod:GET URLString:url parameters:parameters finished:finished];
}

- (void)getReceivingOrderWithFinished:(FinishedCallBack)finished {
    NSString *url = @"order/valid";
    
    [self requestWithHTTPMethod:GET URLString:url parameters:nil finished:finished];
}

- (void)updateOrderStatusWithOrderStatus:(NSInteger)orderStatus orderID:(NSInteger)orderID finished:(FinishedCallBack)finished {
    NSString *url = [NSString stringWithFormat:@"%@?orderStatus=%ld&id=%ld",@"order/update/status",orderStatus,orderID];
    
    [self requestWithHTTPMethod:PUT URLString:url parameters:nil finished:finished];
}

- (void)chapReceiveOrderWithNickname:(NSString *)nickname orderID:(NSInteger)orderID finished:(FinishedCallBack)finished {
    NSString *url = [NSString stringWithFormat:@"%@?nickname=%@&id=%ld",@"order/update/escort",nickname,orderID];
    
    [self requestWithHTTPMethod:PUT URLString:url parameters:nil finished:finished];
}

#pragma mark - 陪护老人绑定相关请求
- (void)parentChapBindingSaveWithChapCode:(NSString *)chapCode parentCode:(NSString *)parentCode finished:(FinishedCallBack)finished {
    NSString *url = @"parent/escort/save";
    NSDictionary *parameters = @{@"escort": chapCode,
                                 @"parent": parentCode,
                                 @"status": @(1)
                                 };
    
    [self requestWithHTTPMethod:POST URLString:url parameters:parameters finished:finished];
}

- (void)parentChapBindingDeleteWithChapCode:(NSString *)chapCode parentCode:(NSString *)parentCode finished:(FinishedCallBack)finished {
    NSString *url = @"parent/escort/delete";
    NSDictionary *parameters = @{@"escort": chapCode,
                                 @"parent": parentCode};
    
    [self requestWithHTTPMethod:DELETE URLString:url parameters:parameters finished:finished];
}

#pragma mark - 父母步数相关请求
- (void)saveParentStepCountWithDate:(NSInteger)date nickname:(NSString *)nickname walkCount:(NSInteger)walkCount finished:(FinishedCallBack)finished {
    NSString *url = @"parent/record/save";
    NSDictionary *parameters = @{@"date": @(date),
                                 @"nickname": nickname,
                                 @"walkCount": @(walkCount)
                                 };
    
    [self requestWithHTTPMethod:POST URLString:url parameters:parameters finished:finished];
}

- (void)getParentStepCountWithNickname:(NSString *)nickname finished:(FinishedCallBack)finished {
    NSString *url = @"parent/record/batch/list";
    NSDictionary *parameters = @{@"nickname": nickname};
    
    [self requestWithHTTPMethod:GET URLString:url parameters:parameters finished:finished];
}

- (void)updatePatentStepCountWithStepID:(NSInteger)stepID walkCount:(NSInteger)walkCount finished:(FinishedCallBack)finished {
    NSString *url = @"parent/record/update";
    NSDictionary *parameters = @{@"id": @(stepID),
                                 @"walkCount": @(walkCount)
                                 };
    
    [self requestWithHTTPMethod:PUT URLString:url parameters:parameters finished:finished];
}

#pragma mark - 封装AFN
- (void)requestWithHTTPMethod:(HTTPMethod)method  URLString:(NSString *)URLString parameters:(nullable id)parameters finished:(FinishedCallBack)finished {
    NSString *methodStr;
    
    switch (method) {
        case GET:
            methodStr = @"GET";
            break;
        case POST:
            methodStr = @"POST";
            break;
        case PUT:
            methodStr = @"PUT";
            break;
        case DELETE:
            methodStr = @"DELETE";
            break;
        default:
            break;
    }
    
    [[self dataTaskWithHTTPMethod:methodStr URLString:URLString parameters:parameters uploadProgress:nil downloadProgress:nil success:^(NSURLSessionDataTask *task, id result) {
        finished(result, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finished(nil, error);
    }] resume];
}


@end
