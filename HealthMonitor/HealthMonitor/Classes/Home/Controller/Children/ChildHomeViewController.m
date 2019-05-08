//
//  ChildHomeViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/18.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "ChildHomeViewController.h"
#import "StepView.h"
#import "TipView.h"
#import "ChanageTableViewCell.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <Masonry/Masonry.h>

NSString * const ChildHomeTableViewCellID = @"ChildHomeTableViewCellID";

@interface ChildHomeViewController ()<AMapSearchDelegate, UITableViewDataSource, ChangeTableViewCellDelegate, MAMapViewDelegate>
@property(strong,nonatomic) MAMapView       *mapView;
@property(strong,nonatomic) UILabel         *nameLabel;
@property(strong,nonatomic) UILabel         *addressLabel;
@property(strong,nonatomic) AMapSearchAPI   *search;
@property(strong,nonatomic) UIView          *changeView;
@property(strong,nonatomic) UITableView     *changeTableView;

@end

@implementation ChildHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)clickChangeButton {
    NSLog(@"切换");
    self.changeView.hidden = NO;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    
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

- (void)clickChangeButtonWithCell:(ChanageTableViewCell *)cell {
    NSLog(@"切换");
    self.changeView.hidden = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // TODO: 测试数据
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChanageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChildHomeTableViewCellID forIndexPath:indexPath];
    cell.delegate = self;
    
    // TODO: 测试数据
    if (indexPath.row == 0) {
        cell.nameLabel.text = @"张三";
        cell.relationLabel.text = @"父亲";
        cell.changeButton.userInteractionEnabled =  NO;
        cell.changeButton.alpha = 0.4;
    }else {
        cell.nameLabel.text = @"李欣";
        cell.relationLabel.text = @"母亲";
    }
    
    return cell;
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
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.backgroundColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont boldSystemFontOfSize:22.f];
    // TODO: 测试数据
    _nameLabel.text = @"张三";
    [self.mapView addSubview:_nameLabel];
    
    _addressLabel = [[UILabel alloc] init];
    _addressLabel.backgroundColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00];
    _addressLabel.textColor = [UIColor whiteColor];
    _addressLabel.font = [UIFont boldSystemFontOfSize:22.f];
    // TODO: 测试数据
    _addressLabel.text = @"北海区，西河路";
    [self.mapView addSubview:_addressLabel];
    
    UIButton *chageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [chageButton setTitle:@"切换" forState:UIControlStateNormal];
    [chageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    chageButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    chageButton.layer.borderColor = [UIColor blackColor].CGColor;
    chageButton.layer.borderWidth = 1;
    chageButton.layer.cornerRadius = 5;
    chageButton.layer.masksToBounds = YES;
    chageButton.backgroundColor = [UIColor whiteColor];
    [chageButton addTarget:self action:@selector(clickChangeButton) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:chageButton];
    
    StepView *stepView = [[StepView alloc] init];
    stepView.layer.borderColor = [UIColor blackColor].CGColor;
    stepView.layer.borderWidth = 0.5;
    [self.view addSubview:stepView];
    
    _changeView = [[UIView alloc] init];
    _changeView.layer.borderColor = [UIColor blackColor].CGColor;
    _changeView.layer.borderWidth = 1;
    _changeView.backgroundColor = [UIColor whiteColor];
    _changeView.hidden = YES;
    [self.view addSubview:_changeView];
    
    _changeTableView = [[UITableView alloc] init];
    _changeTableView.dataSource = self;
    [_changeTableView registerClass:[ChanageTableViewCell class] forCellReuseIdentifier:ChildHomeTableViewCellID];
    _changeTableView.tableFooterView = [[UIView alloc] init];
    [_changeView addSubview:_changeTableView];
    
    
    TipView *physicalTipView = [[TipView alloc] init];
    physicalTipView.layer.borderColor = [UIColor blackColor].CGColor;
    physicalTipView.layer.borderWidth = 0.5;
    physicalTipView.titleLabel.text = @"老人当前健康状况：";
    physicalTipView.tipLabel.text = @"良好！请继续保持";
    [self.view addSubview:physicalTipView];
    
    TipView *healthTipView = [[TipView alloc] init];
    healthTipView.layer.borderColor = [UIColor blackColor].CGColor;
    healthTipView.layer.borderWidth = 0.5;
    healthTipView.tipLabel.text = @"现在是中午，到老人使用XXX药的时候了";
    [self.view addSubview:healthTipView];
    
    
    // 设置布局
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(getRectNavAndStatusHeight);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(200.f);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mapView.mas_top).offset(20.f);
        make.left.equalTo(self.mapView.mas_left).offset(10.f);
        make.height.mas_equalTo(22.f);
    }];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_top);
        make.left.equalTo(self.nameLabel.mas_right).offset(10.f);
        make.height.mas_equalTo(22.f);
    }];
    
    [chageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.addressLabel.mas_centerY);
        make.right.equalTo(self.mapView.mas_right).offset(-10.f);
        make.height.mas_equalTo(30.f);
        make.width.mas_equalTo(70.f);
    }];
    
    [stepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mapView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(250.f);
    }];
    
    [_changeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(stepView.mas_centerX);
        make.centerY.equalTo(stepView.mas_centerY);
        make.height.mas_equalTo(130);
        make.width.mas_equalTo(MainScreenWith - 30);
    }];
    
    [_changeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.changeView);
        make.size.mas_equalTo(CGSizeMake(MainScreenWith - 60, 100));
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
