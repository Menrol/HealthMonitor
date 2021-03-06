//
//  AppDelegate.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/4.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <HealthKit/HealthKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[LoginViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    // 设置地图
    [AMapServices sharedServices].apiKey = @"7a3b0f6d93712c79f2857377d91189e8";
    [AMapServices sharedServices].enableHTTPS = YES;
    
    // 获取步数权限
    if (![HKHealthStore isHealthDataAvailable]) {
        NSLog(@"该设备不支持HealthKit");
        _canGetStep = NO;
    }else {
        HKHealthStore *healthStore = [[HKHealthStore alloc] init];
        
        HKObjectType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
        NSSet *healthSet = [NSSet setWithObjects:stepType, nil];
        
        __weak typeof(self) weakSelf = self;
        [healthStore requestAuthorizationToShareTypes:nil readTypes:healthSet completion:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                weakSelf.canGetStep = YES;
            }else {
                NSLog(@"获取步数权限失败");
                weakSelf.canGetStep = NO;
            }
        }];
    }
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
