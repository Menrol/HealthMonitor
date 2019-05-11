//
//  CurOrderUpView.h
//  HealthMonitor
//
//  Created by WRQ on 2019/4/11.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CurOrderUpViewDelegate <NSObject>

- (void)didClickDetailButton;
- (void)didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation;

@end

@interface CurOrderUpView : UIView
@property(strong,nonatomic) UILabel                   *orderStatusLabel;
@property(strong,nonatomic) UILabel                   *chapTitleLabel;
@property(strong,nonatomic) UILabel                   *chaperonageLabel;
@property(strong,nonatomic) UIButton                  *detailButton;
@property(strong,nonatomic) MAMapView                 *mapView;
@property(weak,nonatomic) id<CurOrderUpViewDelegate>  delegate;

@end

NS_ASSUME_NONNULL_END
