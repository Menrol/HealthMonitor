//
//  ReOrderDetailViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/20.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "ReOrderDetailViewController.h"
#import "ChapOrderUpView.h"
#import "ChapOrderDownView.h"
#import <Masonry/Masonry.h>

@interface ReOrderDetailViewController ()<ChapOrderUpViewDelegate> {
    CLLocationCoordinate2D     _chapCoordinate;
}
@property(strong,nonatomic) ChapOrderUpView     *upView;
@property(strong,nonatomic) ChapOrderDownView   *downView;
@property(strong,nonatomic) UIButton            *recieveButton;

@end

@implementation ReOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    // TODO: 测试数据
    _chapCoordinate = CLLocationCoordinate2DMake(22.52, 113.92);
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = _chapCoordinate;
    [_upView.mapView addAnnotation:pointAnnotation];
}

- (void)clickRecieveButton {
    NSLog(@"接单");
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
    _upView.orderStatusLabel.hidden = YES;
    _upView.delegate = self;
    [self.view addSubview:_upView];
    
    _downView = [ChapOrderDownView chapOrderDownView];
    [self.view addSubview:_downView];
    
    _recieveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_recieveButton setTitle:@"接单" forState:UIControlStateNormal];
    [_recieveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _recieveButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    _recieveButton.layer.borderWidth = 1;
    _recieveButton.layer.borderColor = [UIColor blackColor].CGColor;
    _recieveButton.layer.cornerRadius = 5;
    _recieveButton.layer.masksToBounds = YES;
    [_recieveButton addTarget:self action:@selector(clickRecieveButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recieveButton];
    
    // 添加布局
    [_upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(getRectNavAndStatusHeight);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(160.f);
    }];
    
    [_upView.orderStatusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [_upView.mapView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.upView.mas_top);
    }];
    
    [_downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.upView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(335.f);
    }];
    
    [_recieveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.downView.mas_bottom).offset(15.f);
        make.left.equalTo(self.view.mas_left).offset(15.f);
        make.right.equalTo(self.view.mas_right).offset(-15.f);
        make.height.mas_equalTo(45.f);
    }];
}

@end
