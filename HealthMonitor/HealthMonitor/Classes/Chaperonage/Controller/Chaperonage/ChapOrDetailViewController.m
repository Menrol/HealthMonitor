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
#import "NetworkTool.h"
#import "RQProgressHUD.h"
#import "OrderDetailModel.h"
#import "MedicineModel.h"
#import <YYModel/YYModel.h>
#import <Masonry/Masonry.h>

@interface ChapOrDetailViewController ()<ChapOrderUpViewDelegate> {
    CLLocationCoordinate2D     _parentCoordinate;
}
@property(strong,nonatomic) ChapOrderUpView     *upView;
@property(strong,nonatomic) ChapOrderDownView   *downView;
@property(strong,nonatomic) OrderDetailModel    *model;

@end

@implementation ChapOrDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [RQProgressHUD rq_show];
    
    __weak typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] orderDetailWithOrderNo:_orderNo finished:^(id  _Nullable result, NSError * _Nullable error) {
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
        strongSelf.model = model;
        
        NSString *orderStatusStr;
        if (model.orderStatus == 0) {
            orderStatusStr = @"未接单";
        }else if (model.orderStatus == 1) {
            orderStatusStr = @"请尽快赶往地点";
        }else if (model.orderStatus == 2) {
            orderStatusStr = @"陪护中";
        }else {
            orderStatusStr = @"陪护完成";
        }
        strongSelf.upView.orderStatusLabel.text = orderStatusStr;
        strongSelf.downView.addressLabel.text = model.address;

        if ([model.position componentsSeparatedByString:@" "].count == 2) {
            double latitude = [[model.position componentsSeparatedByString:@" "][0] doubleValue];
            double longitude = [[model.position componentsSeparatedByString:@" "][1] doubleValue];
            strongSelf->_parentCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
            
            MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
            pointAnnotation.coordinate = strongSelf->_parentCoordinate;
            [strongSelf.upView.mapView addAnnotation:pointAnnotation];
            
            CLLocationCoordinate2D userCoordinate = strongSelf.upView.mapView.userLocation.location.coordinate;
            if (userCoordinate.latitude != 0 || userCoordinate.longitude != 0) {
                CLLocationCoordinate2D center = CLLocationCoordinate2DMake((userCoordinate.latitude + strongSelf->_parentCoordinate.latitude) / 2, (userCoordinate.longitude + strongSelf->_parentCoordinate.longitude) / 2);
                MACoordinateSpan span = MACoordinateSpanMake(ABS(userCoordinate.latitude - strongSelf->_parentCoordinate.latitude) * 2, ABS(userCoordinate.longitude - strongSelf->_parentCoordinate.longitude) * 2);
                MACoordinateRegion region = MACoordinateRegionMake(center, span);
                
                [strongSelf.upView.mapView setRegion:region animated:YES];
            }
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
            strongSelf.downView.medicineLabel.text = @"无";
        }else {
            MedicineModel *medicineModel = model.medicationComplianceList[0];
            strongSelf.downView.medicineLabel.text = [NSString stringWithFormat:@"%@每日%@次",medicineModel.medicine, medicineModel.count];
        }
        strongSelf.downView.orderNumLabel.text = model.orderNo;
    }];
}

- (void)clickReturn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    
    if (_parentCoordinate.latitude == 0 && _parentCoordinate.longitude == 0) {
        return;
    }
    
    CLLocationCoordinate2D userCoordinate = userLocation.location.coordinate;
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((userCoordinate.latitude + _parentCoordinate.latitude) / 2, (userCoordinate.longitude + _parentCoordinate.longitude) / 2);
    MACoordinateSpan span = MACoordinateSpanMake(ABS(userCoordinate.latitude - _parentCoordinate.latitude) * 2, ABS(userCoordinate.longitude - _parentCoordinate.longitude) * 2);
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
