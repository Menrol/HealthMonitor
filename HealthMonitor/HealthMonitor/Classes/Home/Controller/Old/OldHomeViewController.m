//
//  OldHomeViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/8.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "OldHomeViewController.h"
#import "StepView.h"
#import "TipView.h"
#import "MainViewController.h"
#import "ParentModel.h"
#import "NetworkTool.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <Masonry/Masonry.h>

@interface OldHomeViewController ()<AMapSearchDelegate, MAMapViewDelegate>
@property(strong,nonatomic) MAMapView       *mapView;
@property(strong,nonatomic) UILabel         *addressLabel;
@property(strong,nonatomic) AMapSearchAPI   *search;
@property(strong,nonatomic) ParentModel     *model;

@end

@implementation OldHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    MainViewController *vc = (MainViewController *)self.tabBarController;
    _model = vc.model;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    NSString *position = [NSString stringWithFormat:@"%lf %lf",userLocation.coordinate.latitude,userLocation.coordinate.longitude];
    [[NetworkTool sharedTool] parentUpdateWithParamters:@{@"id": @(_model.userID), @"position": position} finished:^(id  _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
            
            return;
        }
        
        NSLog(@"%@",result);
    }];
    
    AMapReGeocodeSearchRequest *rego = [[AMapReGeocodeSearchRequest alloc] init];
    rego.location = [AMapGeoPoint locationWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
    rego.requireExtension = YES;
    
    [self.search AMapReGoecodeSearch:rego];
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if (response.regeocode != nil) {
        AMapReGeocode *r = response.regeocode;
        // TODO: 地址获取不到
        if ([r.addressComponent.district isEqualToString:@""] || [r.addressComponent.streetNumber.street isEqualToString:@""]) {
            NSLog(@"获取不到地址");
        }else {
            self.addressLabel.text = [NSString stringWithFormat:@"%@,%@",r.addressComponent.district,r.addressComponent.streetNumber.street];
        }
    }
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"Error: %@",error);
}

- (AMapSearchAPI *)search {
    if (!_search) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    
    return _search;
}

- (void)setupUI {
    // 创建控件
    _mapView = [[MAMapView alloc] init];
    _mapView.layer.borderColor = [UIColor blackColor].CGColor;
    _mapView.layer.borderWidth = 0.5;
    _mapView.showsUserLocation = YES;
    _mapView.showsCompass = NO;
    _mapView.showsScale = NO;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    _mapView.delegate = self;
    [_mapView setZoomLevel:15.f];
    [self.view addSubview:_mapView];
    
    // 自定义定位点
    MAUserLocationRepresentation * r = [[MAUserLocationRepresentation alloc] init];
    r.showsAccuracyRing = NO;
    r.showsHeadingIndicator = NO;
    r.image = [UIImage imageNamed:@"location"];
    [_mapView updateUserLocationRepresentation:r];
    
    _addressLabel = [[UILabel alloc] init];
    _addressLabel.backgroundColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00];
    _addressLabel.textColor = [UIColor whiteColor];
    _addressLabel.font = [UIFont boldSystemFontOfSize:25.f];
    // TODO: 测试数据
    _addressLabel.text = @"北海区，西河路";
    [self.mapView addSubview:_addressLabel];
    
    StepView *stepView = [[StepView alloc] init];
    stepView.layer.borderColor = [UIColor blackColor].CGColor;
    stepView.layer.borderWidth = 0.5;
    [self.view addSubview:stepView];
    
    TipView *physicalTipView = [[TipView alloc] init];
    physicalTipView.layer.borderColor = [UIColor blackColor].CGColor;
    physicalTipView.layer.borderWidth = 0.5;
    physicalTipView.titleLabel.text = @"您的健康状况：";
    physicalTipView.tipLabel.text = @"良好！请继续保持";
    [self.view addSubview:physicalTipView];
    
    TipView *healthTipView = [[TipView alloc] init];
    healthTipView.layer.borderColor = [UIColor blackColor].CGColor;
    healthTipView.layer.borderWidth = 0.5;
    healthTipView.titleLabel.text = @"健康提醒：";
    healthTipView.tipLabel.text = @"现在是中午，到您使用XXX药的时候了";
    [self.view addSubview:healthTipView];
    
    
    // 设置布局
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(getRectNavAndStatusHeight);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(200.f);
    }];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mapView.mas_top).offset(20.f);
        make.left.equalTo(self.mapView.mas_left).offset(10.f);
        make.height.mas_equalTo(25.f);
    }];
    
    [stepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mapView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(250.f);
    }];
    
    [physicalTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stepView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(healthTipView.mas_height);
    }];
    
    [healthTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(physicalTipView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-TabBarHeight);
    }];
}

@end
