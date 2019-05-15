//
//  MainViewController.h
//  HealthMonitor
//
//  Created by WRQ on 2019/4/8.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainViewController : UITabBarController
@property(assign,nonatomic) NSInteger           userType;
@property(strong,nonatomic) id                  model;
@property(strong,nonatomic) NSString            *parentNickname;

@end

NS_ASSUME_NONNULL_END
