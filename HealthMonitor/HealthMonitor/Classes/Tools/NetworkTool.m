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

- (void)parentMessageWithNickname:(NSString *)nickname finished:(FinishedCallBack)finished {
    NSString *url = @"parent/batch";
    NSDictionary *parameters = @{@"nickname": nickname};
    
    [self requestWithHTTPMethod:GET URLString:url paramters:parameters finished:finished];
}

- (void)parentCheckWithNickname:(NSString *)nickName finished:(FinishedCallBack)finished {
    NSString *url = @"parent/check";
    NSDictionary *parameters = @{@"nickname": nickName};
    
    [self requestWithHTTPMethod:GET URLString:url paramters:parameters finished:finished];
}

- (void)parentRegisterWithNickname:(NSString *)nickname password:(NSString *)password birthday:(NSString *)birthday gender:(NSString *)gender healthStatus:(NSInteger)healthStatus medicine:(NSInteger) medicine name:(NSString *)name finished:(FinishedCallBack)finished {
    NSString *url = @"parent/register";
    
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat  = @"yyyy-MM-dd";
    NSString *nowStr = [formatter stringFromDate:nowDate];
    NSDate *endDate = [formatter dateFromString:nowStr];
    NSDate *startDate;
    if (birthday.length > 0) {
        startDate = [formatter dateFromString:birthday];
    }else {
        startDate = endDate;
    }
    NSDateComponents *compoents = [calender components:NSCalendarUnitYear fromDate:startDate toDate:endDate options:0];
    NSInteger age = [compoents year];
    NSDictionary *parameters = @{@"nickname": nickname,
                                 @"password": password,
                                 @"birthday": birthday,
                                 @"age": @(age),
                                 @"gender": gender,
                                 @"healthStatus": @(healthStatus),
                                 @"medicine": @(medicine),
                                 @"name": name
                                 };
    
    [self requestWithHTTPMethod:POST URLString:url paramters:parameters finished:finished];
}

- (void)parentUpdateWithNickname:(NSString *)nickname password:(NSString *)password birthday:(NSString *)birthday gender:(NSString *)gender healthStatus:(NSInteger)healthStatus medicine:(NSInteger) medicine name:(NSString *)name finished:(FinishedCallBack)finished {
    NSString *url = @"parent/update";
    
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat  = @"yyyy-MM-dd";
    NSString *nowStr = [formatter stringFromDate:nowDate];
    NSDate *endDate = [formatter dateFromString:nowStr];
    NSDate *startDate;
    if (birthday.length > 0) {
        startDate = [formatter dateFromString:birthday];
    }else {
        startDate = endDate;
    }
    NSDateComponents *compoents = [calender components:NSCalendarUnitYear fromDate:startDate toDate:endDate options:0];
    NSInteger age = [compoents year];
    NSDictionary *parameters = @{@"nickname": nickname,
                                 @"password": password,
                                 @"birthday": birthday,
                                 @"age": @(age),
                                 @"gender": gender,
                                 @"healthStatus": @(healthStatus),
                                 @"medicine": @(medicine),
                                 @"name": name
                                 };
    
    [self requestWithHTTPMethod:PUT URLString:url paramters:parameters finished:finished];
}

- (void)parentLoginWithNickname:(NSString *)nickName password:(NSString *)password finished:(FinishedCallBack)finished {
    NSString *url = @"parent/login";
    NSDictionary *parameters = @{@"nickname": nickName, @"password": password};
    
    [self requestWithHTTPMethod:GET URLString:url paramters:parameters finished:finished];
}

- (void)requestWithHTTPMethod:(HTTPMethod)method  URLString:(NSString *)URLString paramters:(nullable id)parameters finished:(FinishedCallBack)finished {
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
