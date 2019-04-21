//
//  ChangeAddressViewController.h
//  HealthMonitor
//
//  Created by WRQ on 2019/4/21.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ChangeAddressViewControllerDelegate <NSObject>

- (void)didClickSearchWithAddress:(NSString *)address City:(NSString *)city;
- (void)didClickCancelButton;
- (void)didCleanText;

@end

@interface ChangeAddressViewController : UIViewController
@property(assign,nonatomic) CLLocationCoordinate2D                 userCoordinate;
@property(strong,nonatomic) NSString                               *city;
@property(weak,nonatomic)id<ChangeAddressViewControllerDelegate>   delegate;

@end

NS_ASSUME_NONNULL_END
