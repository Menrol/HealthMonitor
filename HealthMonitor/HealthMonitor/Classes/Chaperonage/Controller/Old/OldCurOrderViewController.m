//
//  OldCurOrderViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/11.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "OldCurOrderViewController.h"
#import "CurOrderUpView.h"
#import "CurOrderDownView.h"
#import "ChapDetailViewController.h"
#import <Masonry/Masonry.h>

@interface OldCurOrderViewController ()<CurOrderUpViewDelegate> {
    CLLocationCoordinate2D     _chapCoordinate;
}
@property(strong,nonatomic) CurOrderUpView    *upView;
@property(strong,nonatomic) CurOrderDownView  *downView;

@end

@implementation OldCurOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    // TODO: 测试数据
    _chapCoordinate = CLLocationCoordinate2DMake(22.52, 113.92);
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = _chapCoordinate;
    [_upView.mapView addAnnotation:pointAnnotation];
}

- (void)didClickDetailButton {
    NSLog(@"查看详情");
    
    ChapDetailViewController *vc = [[ChapDetailViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    
    if (_chapCoordinate.latitude == 0 && _chapCoordinate.longitude == 0) {
        return;
    }
    
    CLLocationCoordinate2D userCoordinate = userLocation.location.coordinate;
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((userCoordinate.latitude + _chapCoordinate.latitude) / 2, (userCoordinate.longitude + _chapCoordinate.longitude) / 2);
    MACoordinateSpan span = MACoordinateSpanMake(ABS(userCoordinate.latitude - _chapCoordinate.latitude) + 0.3, ABS(userCoordinate.longitude - _chapCoordinate.longitude) + 0.3);
    MACoordinateRegion region = MACoordinateRegionMake(center, span);
    
    [_upView.mapView setRegion:region animated:YES];
}

- (void)setupUI {
    // 创建控件
    _upView = [[CurOrderUpView alloc] init];
    _upView.layer.borderColor = [UIColor blackColor].CGColor;
    _upView.layer.borderWidth = 0.5;
    _upView.delegate = self;
    // TODO: 测试数据
    _upView.orderStatusLabel.text = @"陪护员已接单";
    _upView.chaperonageLabel.text = @"王悦";
    [self.view addSubview:_upView];
    
    _downView = [CurOrderDownView oldOrderDownView];
    _downView.layer.borderColor = [UIColor blackColor].CGColor;
    _downView.layer.borderWidth = 0.5;
    [self.view addSubview:_downView];
    
    // 添加布局
    [_upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(340.f);
    }];
    
    [_downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.upView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

@end
