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
#import "NetworkTool.h"
#import "RQProgressHUD.h"
#import "OrderDetailModel.h"
#import "MedicineModel.h"
#import <YYModel/YYModel.h>
#import <Masonry/Masonry.h>

@interface ReOrderDetailViewController ()
@property(strong,nonatomic) ChapOrderUpView     *upView;
@property(strong,nonatomic) ChapOrderDownView   *downView;
@property(strong,nonatomic) UIButton            *recieveButton;
@property(strong,nonatomic) OrderDetailModel    *model;

@end

@implementation ReOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [RQProgressHUD rq_show];
    
    __strong typeof(self) weakSelf = self;
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
        
        NSDictionary *dataDic = result[@"data"];
        OrderDetailModel *model = [OrderDetailModel yy_modelWithDictionary:dataDic];
        weakSelf.model = model;
        
        weakSelf.downView.addressLabel.text = model.address;
        
        if ([model.position componentsSeparatedByString:@" "].count == 2) {
            double latitude = [[model.position componentsSeparatedByString:@" "][0] doubleValue];
            double longitude = [[model.position componentsSeparatedByString:@" "][1] doubleValue];
            CLLocationCoordinate2D parentCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
            
            MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
            pointAnnotation.coordinate = parentCoordinate;
            [weakSelf.upView.mapView addAnnotation:pointAnnotation];
            
            [weakSelf.upView.mapView setCenterCoordinate:parentCoordinate animated:YES];
        }
        
        weakSelf.downView.beChapNameLabel.text = model.parentName;
        weakSelf.downView.ageLabel.text = [NSString stringWithFormat:@"%ld", model.parentAge];
        weakSelf.downView.sexLabel.text = model.parentGender;
        weakSelf.downView.chapTimeLabel.text = [NSString stringWithFormat:@"%@至%@",model.escortStart, model.escortEnd];
        NSString *healthStr;
        if (model.healthStatus == 0) {
            healthStr = @"健康";
        }else {
            healthStr = @"患病";
        }
        weakSelf.downView.healthConditionLabel.text = healthStr;
        NSString *chapTypeStr;
        if (model.escortType == 0) {
            chapTypeStr = @"临时陪护";
        }else {
            chapTypeStr = @"长期陪护";
        }
        weakSelf.downView.chapTypeLabel.text = chapTypeStr;
        weakSelf.downView.sicknessHistoryLabel.text = model.illness;
        if (model.medicationComplianceList.count == 0) {
            weakSelf.downView.medicineLabel.text = @"无";
        }else {
            MedicineModel *medicineModel = model.medicationComplianceList[0];
            weakSelf.downView.medicineLabel.text = [NSString stringWithFormat:@"%@每日%@次",medicineModel.medicine, medicineModel.count];
        }
        weakSelf.downView.orderNumLabel.text = model.orderNo;
    }];
}

- (void)clickRecieveButton {
    NSLog(@"接单");
    
    __weak typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] chapReceiveOrderWithNickname:_nickname orderID:_orderID finished:^(id  _Nullable result, NSError * _Nullable error) {
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
        
        [[NetworkTool sharedTool] updateOrderStatusWithOrderStatus:weakSelf.model.orderStatus + 1 orderID:weakSelf.orderID finished:^(id  _Nullable result, NSError * _Nullable error) {
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
            
            [RQProgressHUD rq_showSuccessWithStatus:@"接单成功" completion:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }];
    }];
    
    NSString *position = [NSString stringWithFormat:@"%lf %lf",_upView.mapView.userLocation.coordinate.latitude,_upView.mapView.userLocation.coordinate.longitude];
    [[NetworkTool sharedTool] chapUpdateWithParamters:@{@"id": @(_chapID), @"escortPosition": position} finished:^(id  _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
            
            return;
        }
        
        NSLog(@"%@",result);
    }];
}

- (void)clickReturn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupUI {
    self.title = @"订单详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrows_left"] style:UIBarButtonItemStylePlain target:self action:@selector(clickReturn)];
    
    // 创建控件
    _upView = [[ChapOrderUpView alloc] init];
    _upView.orderStatusLabel.hidden = YES;
    _upView.mapView.showsUserLocation = NO;
    _upView.mapView.userTrackingMode = MAUserTrackingModeNone;
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
