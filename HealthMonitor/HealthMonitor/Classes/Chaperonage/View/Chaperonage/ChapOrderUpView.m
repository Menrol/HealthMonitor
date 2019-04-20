//
//  ChapOrderUpView.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/15.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "ChapOrderUpView.h"
#import <Masonry/Masonry.h>

@interface ChapOrderUpView()<MAMapViewDelegate>

@end

@implementation ChapOrderUpView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
        
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    [_delegate didUpdateUserLocation:userLocation updatingLocation:updatingLocation];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
    }else if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *reuseIndetifier = @"chapPointReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        
        annotationView.image = [UIImage imageNamed:@"person"];
        
        return annotationView;
    }
    
    return nil;
}

- (void)setupUI {
    // 创建控件
    _orderStatusLabel = [[UILabel alloc] init];
    _orderStatusLabel.font = [UIFont boldSystemFontOfSize:28.f];
    _orderStatusLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_orderStatusLabel];
    
    _mapView = [[MAMapView alloc] init];
    _mapView.showsUserLocation = YES;
    _mapView.showsCompass = NO;
    _mapView.showsScale = NO;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    _mapView.delegate = self;
    [self addSubview:_mapView];
    
    // 自定义定位点
    MAUserLocationRepresentation * r = [[MAUserLocationRepresentation alloc] init];
    r.showsAccuracyRing = NO;
    r.showsHeadingIndicator = NO;
    r.image = [UIImage imageNamed:@"location"];
    [_mapView updateUserLocationRepresentation:r];
    
    // 设置布局
    [_orderStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(25.f);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(25.f);
    }];
    
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderStatusLabel.mas_bottom).offset(15.f);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(160.f);
    }];
}

@end
