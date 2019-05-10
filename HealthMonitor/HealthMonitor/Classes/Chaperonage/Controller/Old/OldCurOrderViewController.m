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
#import "NetworkTool.h"
#import "RQProgressHUD.h"
#import "MainViewController.h"
#import "ParentModel.h"
#import "OrderDetailModel.h"
#import "ChapDetailViewController.h"
#import "MedicineModel.h"
#import <Masonry/Masonry.h>
#import <YYModel/YYModel.h>

@interface OldCurOrderViewController ()<CurOrderUpViewDelegate> {
    CLLocationCoordinate2D     _chapCoordinate;
}
@property(strong,nonatomic) CurOrderUpView    *upView;
@property(strong,nonatomic) CurOrderDownView  *downView;
@property(strong,nonatomic) UILabel           *noOrderLabel;
@property(strong,nonatomic) OrderDetailModel  *model;

@end

@implementation OldCurOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    MainViewController *vc = (MainViewController *)self.tabBarController;
    ParentModel *parentModel = vc.model;
    
    [RQProgressHUD rq_show];
    
    __weak typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] getParentOrderWithNickname:parentModel.nickname finished:^(id  _Nullable result, NSError * _Nullable error) {

        if (error) {
            [RQProgressHUD dismiss];
            NSLog(@"%@",error);

            return;
        }

        NSLog(@"%@",result);

        NSInteger code = [result[@"code"] integerValue];
        if (code != 200) {
            [RQProgressHUD dismiss];
            [RQProgressHUD rq_showErrorWithStatus:result[@"msg"]];

            return;
        }

        NSArray *dataArray = result[@"data"];
        NSString *orderNo;

        for (NSDictionary *dic in dataArray) {
            NSInteger orderStatus = [dic[@"orderStatus"] integerValue];
            if (orderStatus == 1 || orderStatus == 2) {
                orderNo = dic[@"orderNo"];
                break;
            }
        }

        if (orderNo.length == 0) {
            weakSelf.noOrderLabel.hidden = NO;
            return;
        }else {
            weakSelf.noOrderLabel.hidden = YES;
        }

        [[NetworkTool sharedTool] orderDetailWithOrderNo:orderNo finished:^(id  _Nullable result, NSError * _Nullable error) {
            [RQProgressHUD dismiss];

            if (error) {
                NSLog(@"%@",error);

                return;
            }

            NSLog(@"%@",result);

            NSInteger code = [result[@"code"] integerValue];
            if (code != 200) {
                [RQProgressHUD rq_showErrorWithStatus:result[@"msg"]];

                return;
            }

            __strong typeof(self) strongSelf = weakSelf;

            NSDictionary *dataDic = result[@"data"];
            OrderDetailModel *model = [OrderDetailModel yy_modelWithDictionary:dataDic];
            weakSelf.model = model;

            NSString *orderStatusStr;
            if (model.orderStatus == 1) {
                orderStatusStr = @"陪护员已接单";
            }else {
                orderStatusStr = @"陪护中";
            }
            strongSelf.upView.orderStatusLabel.text = orderStatusStr;
            strongSelf.upView.chaperonageLabel.text = model.escortRealName;
            double latitude = [[model.position componentsSeparatedByString:@" "][0] doubleValue];
            double longitude = [[model.position componentsSeparatedByString:@" "][1] doubleValue];
            strongSelf->_chapCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
            MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
            pointAnnotation.coordinate = strongSelf->_chapCoordinate;
            [strongSelf.upView.mapView addAnnotation:pointAnnotation];
            CLLocationCoordinate2D userCoordinate = strongSelf.upView.mapView.userLocation.location.coordinate;
            if (userCoordinate.latitude != 0 || userCoordinate.longitude != 0) {
                CLLocationCoordinate2D center = CLLocationCoordinate2DMake((userCoordinate.latitude + strongSelf->_chapCoordinate.latitude) / 2, (userCoordinate.longitude + strongSelf->_chapCoordinate.longitude) / 2);
                MACoordinateSpan span = MACoordinateSpanMake(ABS(userCoordinate.latitude - strongSelf->_chapCoordinate.latitude) * 2, ABS(userCoordinate.longitude - strongSelf->_chapCoordinate.longitude) * 2);
                MACoordinateRegion region = MACoordinateRegionMake(center, span);

                [strongSelf.upView.mapView setRegion:region animated:YES];
            }

            strongSelf.downView.beChapNameLabel.text = model.parentName;
            strongSelf.downView.ageLabel.text = [NSString stringWithFormat:@"%ld", model.parentAge];
            strongSelf.downView.sexLabel.text = model.parentGender;
            strongSelf.downView.chapTimeLabel.text = [NSString stringWithFormat:@"%@至%@",model.escortStart, model.escortEnd];
            NSString *healthStr;
            if (model.healthStatus == 0) {
                healthStr = @"健康";
            }else {
                healthStr = @"患病";
            }
            strongSelf.downView.healthConditionLabel.text = healthStr;
            NSString *chapTypeStr;
            if (model.escortType == 0) {
                chapTypeStr = @"临时陪护";
            }else {
                chapTypeStr = @"长期陪护";
            }
            strongSelf.downView.chapTypeLabel.text = chapTypeStr;
            strongSelf.downView.sicknessHistoryLabel.text = model.illness;
            if (model.medicationComplianceList.count == 0) {
                strongSelf.downView.medicineConditionLabel.text = @"无";
            }else {
                MedicineModel *medicineModel = model.medicationComplianceList[0];
                strongSelf.downView.medicineConditionLabel.text = [NSString stringWithFormat:@"%@每日%@次",medicineModel.medicine, medicineModel.count];
            }
            strongSelf.downView.orderNumberLabel.text = model.orderNo;
        }];
    }];
}

- (void)didClickDetailButton {
    NSLog(@"查看详情");
    
    ChapDetailViewController *vc = [[ChapDetailViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.escortName = _model.escortName;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    
    if (_chapCoordinate.latitude == 0 && _chapCoordinate.longitude == 0) {
        return;
    }
    
    CLLocationCoordinate2D userCoordinate = userLocation.location.coordinate;
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((userCoordinate.latitude + _chapCoordinate.latitude) / 2, (userCoordinate.longitude + _chapCoordinate.longitude) / 2);
    MACoordinateSpan span = MACoordinateSpanMake(ABS(userCoordinate.latitude - _chapCoordinate.latitude) * 2, ABS(userCoordinate.longitude - _chapCoordinate.longitude) * 2);
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
    
    _noOrderLabel = [[UILabel alloc] init];
    _noOrderLabel.text = @"暂无订单";
    _noOrderLabel.textAlignment = NSTextAlignmentCenter;
    _noOrderLabel.font = [UIFont boldSystemFontOfSize:25.f];
    _noOrderLabel.textColor = [UIColor grayColor];
    _noOrderLabel.hidden = YES;
    [self.view addSubview:_noOrderLabel];
    
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
    
    [_noOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(25.f);
    }];
}

@end
