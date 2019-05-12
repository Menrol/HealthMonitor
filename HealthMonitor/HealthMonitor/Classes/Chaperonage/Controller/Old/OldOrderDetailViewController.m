//
//  OldOrderDetailViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/12.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "OldOrderDetailViewController.h"
#import "ChapDetailViewController.h"
#import "CurOrderUpView.h"
#import "CurOrderDownView.h"
#import "NetworkTool.h"
#import "RQProgressHUD.h"
#import "OrderDetailModel.h"
#import "MedicineModel.h"
#import <YYModel/YYModel.h>
#import <Masonry/Masonry.h>

@interface OldOrderDetailViewController ()<CurOrderUpViewDelegate>
@property(strong,nonatomic) CurOrderUpView    *upView;
@property(strong,nonatomic) CurOrderDownView  *downView;
@property(strong,nonatomic) OrderDetailModel  *model;

@end

@implementation OldOrderDetailViewController

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
        
        NSString *orderStatusStr;
        if (model.orderStatus == 0) {
            orderStatusStr = @"未接单";
            weakSelf.upView.chapTitleLabel.hidden = YES;
            weakSelf.upView.chaperonageLabel.hidden = YES;
            weakSelf.upView.detailButton.hidden = YES;
            
            [weakSelf.upView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.mas_top).offset(getRectNavAndStatusHeight);
                make.left.equalTo(self.view.mas_left);
                make.right.equalTo(self.view.mas_right);
                make.height.mas_equalTo(300.f);
            }];
            
            [weakSelf.downView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.upView.mapView.mas_bottom);
                make.left.equalTo(self.view.mas_left);
                make.right.equalTo(self.view.mas_right);
                make.bottom.equalTo(self.view.mas_bottom);
            }];
        }else if (model.orderStatus == 1) {
            orderStatusStr = @"陪护员已接单";
            weakSelf.upView.chaperonageLabel.text = model.escortRealName;
        }else if (model.orderStatus == 2) {
            orderStatusStr = @"陪护中";
            weakSelf.upView.chaperonageLabel.text = model.escortRealName;
        }else {
            orderStatusStr = @"陪护完成";
            weakSelf.upView.chaperonageLabel.text = model.escortRealName;
        }
        weakSelf.upView.orderStatusLabel.text = orderStatusStr;
        
        [weakSelf.upView.mapView removeAnnotations:weakSelf.upView.mapView.annotations];
        CLLocationCoordinate2D parentCoordinate = kCLLocationCoordinate2DInvalid;
        CLLocationCoordinate2D chapCoordinate = kCLLocationCoordinate2DInvalid;
        if ([model.position componentsSeparatedByString:@" "].count == 2) {
            parentCoordinate = CLLocationCoordinate2DMake([[model.position componentsSeparatedByString:@" "][0] doubleValue], [[model.position componentsSeparatedByString:@" "][1] doubleValue]);
            RQPointAnnotation *parentAnnotation = [[RQPointAnnotation alloc] initWithCoordinate:parentCoordinate index:0];
            [weakSelf.upView.mapView addAnnotation:parentAnnotation];
        }
        
        if ([model.escortPosition componentsSeparatedByString:@" "].count == 2) {
            chapCoordinate = CLLocationCoordinate2DMake([[model.escortPosition componentsSeparatedByString:@" "][0] doubleValue], [[model.escortPosition componentsSeparatedByString:@" "][1] doubleValue]);
            RQPointAnnotation *chapAnnotation = [[RQPointAnnotation alloc] initWithCoordinate:chapCoordinate index:1];
            [weakSelf.upView.mapView addAnnotation:chapAnnotation];
        }
        
        if (CLLocationCoordinate2DIsValid(parentCoordinate) && CLLocationCoordinate2DIsValid(chapCoordinate)) {
            CLLocationCoordinate2D center = CLLocationCoordinate2DMake((parentCoordinate.latitude + chapCoordinate.latitude) / 2, (parentCoordinate.longitude + chapCoordinate.longitude) / 2);
            MACoordinateSpan span = MACoordinateSpanMake(ABS(parentCoordinate.latitude - chapCoordinate.latitude) * 2, ABS(parentCoordinate.longitude - chapCoordinate.longitude) * 2);
            MACoordinateRegion region = MACoordinateRegionMake(center, span);
            [weakSelf.upView.mapView setRegion:region animated:YES];
        }
        
        if (CLLocationCoordinate2DIsValid(parentCoordinate) && !(CLLocationCoordinate2DIsValid(chapCoordinate))) {
            [weakSelf.upView.mapView setCenterCoordinate:parentCoordinate animated:YES];
        }
        
        if (CLLocationCoordinate2DIsValid(chapCoordinate) && !CLLocationCoordinate2DIsValid(parentCoordinate)) {
            [weakSelf.upView.mapView setCenterCoordinate:chapCoordinate animated:YES];
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
            weakSelf.downView.medicineConditionLabel.text = @"无";
        }else {
            MedicineModel *medicineModel = model.medicationComplianceList[0];
            weakSelf.downView.medicineConditionLabel.text = [NSString stringWithFormat:@"%@每日%@次",medicineModel.medicine, medicineModel.count];
        }
        weakSelf.downView.orderNumberLabel.text = model.orderNo;
    }];
}

- (void)didClickDetailButton {
    NSLog(@"查看详情");
    
    ChapDetailViewController *vc = [[ChapDetailViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.escortName = _model.escortName;
    [self.navigationController pushViewController:vc animated:YES];
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
        make.top.equalTo(self.view.mas_top).offset(getRectNavAndStatusHeight);
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
