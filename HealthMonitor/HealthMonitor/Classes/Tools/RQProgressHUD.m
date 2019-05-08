//
//  RQProgressHUD.m
//  HealthMonitor
//
//  Created by WRQ on 2019/5/7.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "RQProgressHUD.h"

NSTimeInterval const RQProgressHUDDelay = 1.f;

@implementation RQProgressHUD

+ (void)rq_show {
    [self show];
    [self setDefaultStyle:SVProgressHUDStyleDark];
    [self setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

+ (void)rq_showInfoWithStatus:(NSString *)status {
    [self showInfoWithStatus:status];
    [self dismissWithDelay:RQProgressHUDDelay];
    [self setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

+ (void)rq_showInfoWithStatus:(NSString *)status completion:(nullable SVProgressHUDDismissCompletion)completion {
    [self showInfoWithStatus:status];
    [self dismissWithDelay:RQProgressHUDDelay completion:completion];
    [self setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

+ (void)rq_showErrorWithStatus:(NSString *)status {
    [self showErrorWithStatus:status];
    [self dismissWithDelay:RQProgressHUDDelay];
    [self setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

+ (void)rq_showErrorWithStatus:(NSString *)status completion:(nullable SVProgressHUDDismissCompletion)completion {
    [self showErrorWithStatus:status];
    [self dismissWithDelay:RQProgressHUDDelay completion:completion];
    [self setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

+ (void)rq_showSuccessWithStatus:(NSString *)status {
    [self showSuccessWithStatus:status];
    [self dismissWithDelay:RQProgressHUDDelay];
    [self setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

+ (void)rq_showSuccessWithStatus:(NSString *)status completion:(nullable SVProgressHUDDismissCompletion)completion {
    [self showSuccessWithStatus:status];
    [self dismissWithDelay:RQProgressHUDDelay completion:completion];
    [self setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

@end
