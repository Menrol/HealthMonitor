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
};

NS_ASSUME_NONNULL_BEGIN

@interface NetworkTool : AFHTTPSessionManager

typedef void (^FinishedCallBack) (id _Nullable result, NSError * _Nullable error);

+ (instancetype)sharedTool;

- (void)parentRegisterWithParameters:(id)paremeters finished:(FinishedCallBack)finished;

@end

NS_ASSUME_NONNULL_END
