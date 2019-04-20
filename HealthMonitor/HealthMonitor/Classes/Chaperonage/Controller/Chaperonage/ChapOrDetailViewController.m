//
//  ChapOrDetailViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/16.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "ChapOrDetailViewController.h"
#import "ChapOrderUpView.h"
#import "ChapOrderDownView.h"
#import <Masonry/Masonry.h>

@interface ChapOrDetailViewController ()<ChapOrderUpViewDelegate> {
    CLLocationCoordinate2D     _chapCoordinate;
}
@property(strong,nonatomic) ChapOrderUpView     *upView;
@property(strong,nonatomic) ChapOrderDownView   *downView;

@end

@implementation ChapOrDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    // TODO: 测试数据
    _chapCoordinate = CLLocationCoordinate2DMake(22.52, 113.92);
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = _chapCoordinate;
    [_upView.mapView addAnnotation:pointAnnotation];
}

- (void)clickReturn {
    [self.navigationController popViewControllerAnimated:YES];
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
    self.title = @"订单详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrows_left"] style:UIBarButtonItemStylePlain target:self action:@selector(clickReturn)];
    
    // 创建控件
    _upView = [[ChapOrderUpView alloc] init];
    // TODO: 测试数据
    _upView.orderStatusLabel.text = @"请尽快赶往地点";
    _upView.delegate = self;
    [self.view addSubview:_upView];
    
    _downView = [ChapOrderDownView chapOrderDownView];
    [self.view addSubview:_downView];
    
    // 添加布局
    [_upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(getRectNavAndStatusHeight);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(230.f);
    }];
    
    [_downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.upView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(335.f);
    }];
}

@end
