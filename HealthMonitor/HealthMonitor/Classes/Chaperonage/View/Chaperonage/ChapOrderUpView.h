//
//  ChapOrderUpView.h
//  HealthMonitor
//
//  Created by WRQ on 2019/4/15.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ChapOrderUpViewDelegate <NSObject>

- (void)didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation;

@end

@interface ChapOrderUpView : UIView
@property(strong,nonatomic) UILabel                    *orderStatusLabel;
@property(strong,nonatomic) MAMapView                  *mapView;
@property(weak,nonatomic) id<ChapOrderUpViewDelegate>  delegate;

@end

NS_ASSUME_NONNULL_END
