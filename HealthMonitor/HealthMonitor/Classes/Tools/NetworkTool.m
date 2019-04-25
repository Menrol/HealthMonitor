//
//  NetworkTool.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/25.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "NetworkTool.h"

static NetworkTool *instance;

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

@interface NetworkTool()<NSCopying, NSMutableCopying, NetworkToolProxy>

@end

@implementation NetworkTool

+ (instancetype)sharedTool {
    NSURL *baseURL = [NSURL URLWithString:@"/escort"];
    
    return [[self alloc] initWithBaseURL:baseURL];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    
    return instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return instance;
}

- (void)requestWithHTTPMethod:(HTTPMethod)method  URLString:(NSString *)URLString paramters:(nullable id)parameters finished:(FinishedCallBack)finished {
    NSString *methodStr = (method == GET) ? @"GET" : @"POST";
    
    [self dataTaskWithHTTPMethod:methodStr URLString:URLString parameters:parameters uploadProgress:nil downloadProgress:nil success:^(NSURLSessionDataTask *task, id result) {
        finished(result, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finished(nil, error);
    }];
}


@end
