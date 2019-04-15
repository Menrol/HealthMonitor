//
//  OldOrderUpView.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/11.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "OldOrderUpView.h"
#import <Masonry/Masonry.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface OldOrderUpView()
@property(strong,nonatomic) MAMapView      *mapView;

@end

@implementation OldOrderUpView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
        
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void)clickDetailButton {
    [_delegate didClickDetailButton];
}

- (void)setupUI {
    // 创建控件
    _orderStatusLabel = [[UILabel alloc] init];
    _orderStatusLabel.font = [UIFont boldSystemFontOfSize:28.f];
    _orderStatusLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_orderStatusLabel];
    
    _mapView = [[MAMapView alloc] init];
    _mapView.layer.borderColor = [UIColor blackColor].CGColor;
    _mapView.layer.borderWidth = 0.5;
    _mapView.showsUserLocation = YES;
    _mapView.showsCompass = NO;
    _mapView.showsScale = NO;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [self addSubview:_mapView];
    
    // 自定义定位点
    MAUserLocationRepresentation * r = [[MAUserLocationRepresentation alloc] init];
    r.showsAccuracyRing = NO;
    r.showsHeadingIndicator = NO;
    r.image = [UIImage imageNamed:@"location"];
    [_mapView updateUserLocationRepresentation:r];
    
    UILabel *chapTitleLabel = [[UILabel alloc] init];
    chapTitleLabel.text = @"陪护员：";
    chapTitleLabel.font = [UIFont boldSystemFontOfSize:23.f];
    [self addSubview:chapTitleLabel];
    
    _chaperonageLabel = [[UILabel alloc] init];
    _chaperonageLabel.font = [UIFont boldSystemFontOfSize:23.f];
    [self addSubview:_chaperonageLabel];
    
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [detailButton setTitle:@"查看详情" forState:UIControlStateNormal];
    [detailButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    detailButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
    detailButton.layer.borderColor = [UIColor blackColor].CGColor;
    detailButton.layer.borderWidth = 1;
    detailButton.layer.cornerRadius = 5;
    detailButton.layer.masksToBounds = YES;
    [detailButton addTarget:self action:@selector(clickDetailButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:detailButton];
    
    
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
        make.height.mas_equalTo(200.f);
    }];
    
    [chapTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mapView.mas_bottom).offset(20.f);
        make.left.equalTo(self.mas_left).offset(15.f);
        make.height.mas_equalTo(23.f);
    }];
    
    [_chaperonageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(chapTitleLabel.mas_right);
        make.top.equalTo(chapTitleLabel.mas_top);
        make.height.equalTo(chapTitleLabel.mas_height);
    }];
    
    [detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.chaperonageLabel.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15.f);
        make.height.mas_equalTo(30.f);
        make.width.mas_equalTo(100.f);
    }];
}

@end
