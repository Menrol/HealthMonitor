//
//  ChapCurOrderViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/15.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "ChapCurOrderViewController.h"
#import "ChapOrderUpView.h"
#import "ChapOrderDownView.h"
#import "MainViewController.h"
#import "OrderDetailModel.h"
#import "MedicineModel.h"
#import "ChapModel.h"
#import "NetworkTool.h"
#import "RQProgressHUD.h"
#import "OrderModel.h"
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import <YYModel/YYModel.h>

@interface ChapCurOrderViewController ()<ChapOrderUpViewDelegate, UITableViewDataSource> {
    CLLocationCoordinate2D     _parentCoordinate;
}
@property(strong,nonatomic) ChapOrderUpView     *upView;
@property(strong,nonatomic) ChapOrderDownView   *downView;
@property(strong,nonatomic) UILabel             *noOrderLabel;
@property(strong,nonatomic) UIButton            *changeButton;
@property(strong,nonatomic) UITableView         *tableView;
@property(strong,nonatomic) OrderDetailModel    *model;
@property(strong,nonatomic) ChapModel           *chapModel;
@property(assign,nonatomic) NSInteger           orderID;
@property(strong,nonatomic) NSTimer             *timer;

@end

@implementation ChapCurOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    MainViewController *vc = (MainViewController *)self.tabBarController;
    _chapModel = vc.model;
    
    [_tableView.mj_header beginRefreshing];
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] getOrderListWithFinished:^(id  _Nullable result, NSError * _Nullable error) {
        if (error) {
            [weakSelf.tableView.mj_header endRefreshing];
            NSLog(@"%@",error);
            
            weakSelf.noOrderLabel.hidden = NO;
            weakSelf.upView.hidden = YES;
            weakSelf.downView.hidden = YES;
            weakSelf.changeButton.hidden = YES;
            weakSelf.tableView.backgroundColor = [UIColor whiteColor];
            weakSelf.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            return;
        }
        
        NSLog(@"%@",result);
        
        NSInteger code = [result[@"code"] integerValue];
        if (code != 0) {
            [weakSelf.tableView.mj_header endRefreshing];
            [RQProgressHUD rq_showErrorWithStatus:result[@"msg"]];
            
            weakSelf.noOrderLabel.hidden = NO;
            weakSelf.upView.hidden = YES;
            weakSelf.downView.hidden = YES;
            weakSelf.changeButton.hidden = YES;
            weakSelf.tableView.backgroundColor = [UIColor whiteColor];
            weakSelf.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            return;
        }
        
        NSArray *dataArray = result[@"data"];
        OrderModel *model;
        
        for (NSDictionary *dic in dataArray) {
            NSString *escortName = dic[@"escortName"];
            if ((NSNull *)escortName == [NSNull null]) {
                continue;
            }
            
            if ([weakSelf.chapModel.nickname isEqualToString:escortName] && ([dic[@"orderStatus"] integerValue] == 1 || [dic[@"orderStatus"] integerValue] == 2)) {
                model = [OrderModel yy_modelWithDictionary:dic];
            }
        }
        
        if (model == nil) {
            [weakSelf.tableView.mj_header endRefreshing];
            
            weakSelf.noOrderLabel.hidden = NO;
            weakSelf.upView.hidden = YES;
            weakSelf.downView.hidden = YES;
            weakSelf.changeButton.hidden = YES;
            weakSelf.tableView.backgroundColor = [UIColor whiteColor];
            weakSelf.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            return;
        }
        
        weakSelf.orderID = model.orderID;
        
        [[NetworkTool sharedTool] orderDetailWithOrderNo:model.orderNo finished:^(id  _Nullable result, NSError * _Nullable error) {
            [weakSelf.tableView.mj_header endRefreshing];
            
            if (error) {
                NSLog(@"%@",error);
                
                weakSelf.noOrderLabel.hidden = NO;
                weakSelf.upView.hidden = YES;
                weakSelf.downView.hidden = YES;
                weakSelf.changeButton.hidden = YES;
                weakSelf.tableView.backgroundColor = [UIColor whiteColor];
                weakSelf.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                
                return;
            }
            
            NSLog(@"%@",result);
            
            NSInteger code = [result[@"code"] integerValue];
            if (code != 200) {
                [RQProgressHUD rq_showErrorWithStatus:result[@"msg"]];
                
                weakSelf.noOrderLabel.hidden = NO;
                weakSelf.upView.hidden = YES;
                weakSelf.downView.hidden = YES;
                weakSelf.changeButton.hidden = YES;
                weakSelf.tableView.backgroundColor = [UIColor whiteColor];
                weakSelf.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                
                return;
            }
            
            weakSelf.noOrderLabel.hidden = YES;
            weakSelf.upView.hidden = NO;
            weakSelf.downView.hidden = NO;
            weakSelf.changeButton.hidden = NO;
            weakSelf.tableView.backgroundColor = [UIColor colorWithRed:0.95 green:0.94 blue:0.95 alpha:1.00];
            weakSelf.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            
            __strong typeof(self) strongSelf = weakSelf;
            
            NSDictionary *dataDic = result[@"data"];
            OrderDetailModel *model = [OrderDetailModel yy_modelWithDictionary:dataDic];
            strongSelf.model = model;
            
            NSString *orderStatusStr;
            if (model.orderStatus == 1) {
                orderStatusStr = @"请尽快赶往地点";
            }else {
                orderStatusStr = @"陪护中";
            }
            strongSelf.upView.orderStatusLabel.text = orderStatusStr;
            
            if ([model.position componentsSeparatedByString:@" "].count == 2) {
                CLLocationCoordinate2D parentCoordinate = CLLocationCoordinate2DMake([[model.position componentsSeparatedByString:@" "][0] doubleValue], [[model.position componentsSeparatedByString:@" "][1] doubleValue]);
                strongSelf->_parentCoordinate = parentCoordinate;
                
                [strongSelf.upView.mapView removeAnnotations:strongSelf.upView.mapView.annotations];
                MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
                pointAnnotation.coordinate = parentCoordinate;
                [strongSelf.upView.mapView addAnnotation:pointAnnotation];
                
                CLLocationCoordinate2D userCoordinate = strongSelf.upView.mapView.userLocation.location.coordinate;
                if (userCoordinate.latitude != 0 || userCoordinate.longitude != 0) {
                    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((userCoordinate.latitude + parentCoordinate.latitude) / 2, (userCoordinate.longitude + parentCoordinate.longitude) / 2);
                    MACoordinateSpan span = MACoordinateSpanMake(ABS(userCoordinate.latitude - parentCoordinate.latitude) * 2, ABS(userCoordinate.longitude - parentCoordinate.longitude) * 2);
                    MACoordinateRegion region = MACoordinateRegionMake(center, span);
                    
                    [strongSelf.upView.mapView setRegion:region animated:YES];
                }
            }
            
            strongSelf.downView.addressLabel.text = model.address;
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
    }];
}


- (void)clickChangeButton {
    NSLog(@"变更状态");
    
    __weak typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] updateOrderStatusWithOrderStatus:_model.orderStatus + 1 orderID:_orderID finished:^(id  _Nullable result, NSError * _Nullable error) {
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
        
        if (weakSelf.model.orderStatus + 1 == 3) {
            [[NetworkTool sharedTool] parentChapBindingDeleteWithChapCode:weakSelf.model.escortName parentCode:weakSelf.model.parentEscort finished:^(id  _Nullable result, NSError * _Nullable error) {
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
                
                [RQProgressHUD rq_showSuccessWithStatus:@"变更状态成功" completion:^{
                    [weakSelf.tableView.mj_header beginRefreshing];
                }];
            }];
        }else {
            [RQProgressHUD rq_showSuccessWithStatus:@"变更状态成功" completion:^{
                [weakSelf.tableView.mj_header beginRefreshing];
            }];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.contentView addSubview:self.upView];
        
        [self.upView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top);
            make.left.equalTo(cell.contentView.mas_left);
            make.right.equalTo(cell.contentView.mas_right);
            make.height.mas_equalTo(230.f);
            
            make.bottom.equalTo(cell.contentView.mas_bottom);
        }];
        
        return cell;
    }else {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.contentView addSubview:self.downView];
        
        [self.downView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top);
            make.left.equalTo(cell.contentView.mas_left);
            make.right.equalTo(cell.contentView.mas_right);
            make.height.mas_equalTo(335.f);
            
            make.bottom.equalTo(cell.contentView.mas_bottom);
        }];
        
        return cell;
    }
}


- (void)didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    NSString *position = [NSString stringWithFormat:@"%lf %lf",userLocation.coordinate.latitude,userLocation.coordinate.longitude];
    [[NetworkTool sharedTool] chapUpdateWithParamters:@{@"id": @(self.chapModel.userID), @"escortPosition": position} finished:^(id  _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
            
            return;
        }
        
        NSLog(@"%@",result);
    }];
    
    if (_parentCoordinate.latitude == 0 && _parentCoordinate.longitude == 0) {
        return;
    }
    
    CLLocationCoordinate2D userCoordinate = userLocation.location.coordinate;
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((userCoordinate.latitude + _parentCoordinate.latitude) / 2, (userCoordinate.longitude + _parentCoordinate.longitude) / 2);
    MACoordinateSpan span = MACoordinateSpanMake(ABS(userCoordinate.latitude - _parentCoordinate.latitude) * 2, ABS(userCoordinate.longitude - _parentCoordinate.longitude) * 2);
    MACoordinateRegion region = MACoordinateRegionMake(center, span);

    [_upView.mapView setRegion:region animated:YES];
}

- (ChapOrderUpView *)upView {
    if (!_upView) {
        _upView = [[ChapOrderUpView alloc] init];
        _upView.delegate = self;
        _upView.hidden = YES;
    }
    
    return _upView;
}

- (ChapOrderDownView *)downView {
    if (!_downView) {
        _downView = [ChapOrderDownView chapOrderDownView];
        _downView.hidden = YES;
    }
    
    return _downView;
}

- (void)setupUI {
    // 创建控件
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 200;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.sectionHeaderHeight = 10.f;
    _tableView.sectionFooterHeight = 0.01f;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    _noOrderLabel = [[UILabel alloc] init];
    _noOrderLabel.text = @"暂无订单";
    _noOrderLabel.textAlignment = NSTextAlignmentCenter;
    _noOrderLabel.font = [UIFont boldSystemFontOfSize:25.f];
    _noOrderLabel.textColor = [UIColor grayColor];
    [self.tableView addSubview:_noOrderLabel];
    
    _changeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_changeButton setTitle:@"变更状态" forState:UIControlStateNormal];
    [_changeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _changeButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    _changeButton.layer.borderWidth = 1;
    _changeButton.layer.borderColor = [UIColor blackColor].CGColor;
    _changeButton.layer.cornerRadius = 5;
    _changeButton.layer.masksToBounds = YES;
    _changeButton.backgroundColor = [UIColor whiteColor];
    _changeButton.hidden = YES;
    [_changeButton addTarget:self action:@selector(clickChangeButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView addSubview:_changeButton];
    
    // 添加布局
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [_noOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
        make.size.mas_equalTo(CGSizeMake(101.33f, 25.f));
    }];
    
    [_changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableView.mas_centerX);
        make.centerY.equalTo(self.tableView.mas_centerY).offset(285.f);
        make.size.mas_equalTo(CGSizeMake(345.f, 45.f));
    }];
}

@end
