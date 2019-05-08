//
//  RQProgressHUD.h
//  HealthMonitor
//
//  Created by WRQ on 2019/5/7.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "SVProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface RQProgressHUD : SVProgressHUD

+ (void)rq_show;

+ (void)rq_showInfoWithStatus:(NSString *)status;

+ (void)rq_showInfoWithStatus:(NSString *)status
                   completion:(nullable SVProgressHUDDismissCompletion)completion;

+ (void)rq_showErrorWithStatus:(NSString *)status;

+ (void)rq_showErrorWithStatus:(NSString *)status
                    completion:(nullable SVProgressHUDDismissCompletion)completion;

+ (void)rq_showSuccessWithStatus:(NSString *)status;

+ (void)rq_showSuccessWithStatus:(NSString *)status
                      completion:(nullable SVProgressHUDDismissCompletion)completion;

@end

NS_ASSUME_NONNULL_END
