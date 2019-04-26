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

- (void)parentRegisterWithParameters:(id)parameters finished:(FinishedCallBack)finished {
    NSString *url = @"parent/register";
    
    [self requestWithHTTPMethod:POST URLString:url paramters:parameters finished:finished];
}

- (void)requestWithHTTPMethod:(HTTPMethod)method  URLString:(NSString *)URLString paramters:(nullable id)parameters finished:(FinishedCallBack)finished {
    NSString *methodStr = (method == GET) ? @"GET" : @"POST";
    
    [[self dataTaskWithHTTPMethod:methodStr URLString:URLString parameters:parameters uploadProgress:nil downloadProgress:nil success:^(NSURLSessionDataTask *task, id result) {
        finished(result, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finished(nil, error);
    }] resume];
}


@end
