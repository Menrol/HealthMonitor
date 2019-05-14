//
//  ChapHomeViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/15.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "ChapHomeViewController.h"
#import "StepView.h"
#import "TipView.h"
#import "ChanageTableViewCell.h"
#import "MainViewController.h"
#import "ChapModel.h"
#import "ParentModel.h"
#import "NetworkTool.h"
#import "RQProgressHUD.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import <YYModel/YYModel.h>

NSString * const ChapHomeTableViewCellID = @"ChapHomeTableViewCellID";

@interface ChapHomeViewController ()<AMapSearchDelegate, UITableViewDataSource, MAMapViewDelegate>
@property(strong,nonatomic) MAMapView                        *mapView;
@property(strong,nonatomic) UILabel                          *nameLabel;
@property(strong,nonatomic) UILabel                          *addressLabel;
@property(strong,nonatomic) AMapSearchAPI                    *search;
@property(strong,nonatomic) UIView                           *changeView;
@property(strong,nonatomic) UITableView                      *changeTableView;
@property(strong,nonatomic) StepView                         *stepView;
@property(strong,nonatomic) TipView                          *physicalTipView;
@property(strong,nonatomic) TipView                          *healthTipView;
@property(strong,nonatomic) UITableView                      *tableView;
@property(strong,nonatomic) UILabel                          *noOrderLabel;
@property(strong,nonatomic) ChapModel                        *model;
@property(strong,nonatomic) NSTimer                          *timer;
@property(strong,nonatomic) ParentModel                      *parentModel;

@end

@implementation ChapHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    MainViewController *vc = (MainViewController *)self.tabBarController;
    _model = vc.model;
    
    [_tableView.mj_header beginRefreshing];
    
    __weak typeof(self) weakSelf = self;
    _timer = [NSTimer timerWithTimeInterval:5 * 60 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (weakSelf.parentModel == nil) {
            return;
        }
        
        [[NetworkTool sharedTool] parentMessageWithNickname:weakSelf.parentModel.nickname finished:^(id  _Nullable result, NSError * _Nullable error) {
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
            NSString *positionStr = dataDic[@"position"];
            
            if ((NSNull *)positionStr == [NSNull null]) {
                return;
            }
            
            if ([positionStr componentsSeparatedByString:@" "].count < 2) {
                return;
            }
            
            CLLocationCoordinate2D parentCoordinate = CLLocationCoordinate2DMake([[positionStr componentsSeparatedByString:@" "][0] doubleValue], [[positionStr componentsSeparatedByString:@" "][1] doubleValue]);
            
            if (!CLLocationCoordinate2DIsValid(parentCoordinate)) {
                return;
            }
            
            [weakSelf.mapView removeAnnotations:weakSelf.mapView.annotations];
            
            MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
            annotation.coordinate = parentCoordinate;
            [weakSelf.mapView addAnnotation:annotation];
            [weakSelf.mapView setCenterCoordinate:parentCoordinate animated:YES];
            
            AMapReGeocodeSearchRequest *rego = [[AMapReGeocodeSearchRequest alloc] init];
            rego.location = [AMapGeoPoint locationWithLatitude:parentCoordinate.latitude longitude:parentCoordinate.longitude];
            rego.requireExtension = YES;
            
            [weakSelf.search AMapReGoecodeSearch:rego];
        }];
    }];
    
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)dealloc {
    [_timer invalidate];
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] chapGetParentMessageWithNickname:_model.nickname finished:^(id  _Nullable result, NSError * _Nullable error) {
        if (error) {
            [weakSelf.tableView.mj_header endRefreshing];
            NSLog(@"%@",error);
            
            return;
        }
        
        NSLog(@"%@",result);
        
        NSInteger code = [result[@"code"] integerValue];
        if (code != 200) {
            [weakSelf.tableView.mj_header endRefreshing];
            [RQProgressHUD rq_showErrorWithStatus:result[@"msg"]];
            
            return;
        }
        
        NSDictionary *dataDic = result[@"data"];
        
        if (dataDic == nil) {
            [weakSelf.tableView.mj_header endRefreshing];
            
            weakSelf.mapView.hidden = YES;
            weakSelf.stepView.hidden = YES;
            weakSelf.healthTipView.hidden = YES;
            weakSelf.physicalTipView.hidden = YES;
            weakSelf.noOrderLabel.hidden = NO;
            weakSelf.tableView.backgroundColor = [UIColor whiteColor];
            weakSelf.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            return;
        }
        
        ChapModel *model = [ChapModel yy_modelWithDictionary:dataDic];
        
        weakSelf.mapView.hidden = NO;
        weakSelf.stepView.hidden = NO;
        weakSelf.healthTipView.hidden = NO;
        weakSelf.physicalTipView.hidden = NO;
        weakSelf.noOrderLabel.hidden = YES;
        weakSelf.tableView.backgroundColor = [UIColor colorWithRed:0.95 green:0.94 blue:0.95 alpha:1.00];
        weakSelf.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        ParentModel *parentModel = model.parentList[0];
        weakSelf.parentModel = parentModel;
        
        weakSelf.nameLabel.text = weakSelf.parentModel.name;
        
        dispatch_group_t group = dispatch_group_create();

        dispatch_group_enter(group);
        [[NetworkTool sharedTool] parentMessageWithNickname:parentModel.nickname finished:^(id  _Nullable result, NSError * _Nullable error) {
            dispatch_group_leave(group);
            
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
            NSString *positionStr = dataDic[@"position"];
            
            if ((NSNull *)positionStr == [NSNull null]) {
                return;
            }
            
            if ([positionStr componentsSeparatedByString:@" "].count < 2) {
                return;
            }
            
            CLLocationCoordinate2D parentCoordinate = CLLocationCoordinate2DMake([[positionStr componentsSeparatedByString:@" "][0] doubleValue], [[positionStr componentsSeparatedByString:@" "][1] doubleValue]);
            
            if (!CLLocationCoordinate2DIsValid(parentCoordinate)) {
                return;
            }
            
            [weakSelf.mapView removeAnnotations:weakSelf.mapView.annotations];
            
            MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
            annotation.coordinate = parentCoordinate;
            [weakSelf.mapView addAnnotation:annotation];
            [weakSelf.mapView setCenterCoordinate:parentCoordinate animated:YES];
            
            AMapReGeocodeSearchRequest *rego = [[AMapReGeocodeSearchRequest alloc] init];
            rego.location = [AMapGeoPoint locationWithLatitude:parentCoordinate.latitude longitude:parentCoordinate.longitude];
            rego.requireExtension = YES;
            
            [weakSelf.search AMapReGoecodeSearch:rego];
        }];
        
        
        
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
    }];
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if (response.regeocode == nil) {
        return;
    }
    
    AMapReGeocode *r = response.regeocode;
    // TODO: 地址获取不到
    if ([r.addressComponent.district isEqualToString:@""] || [r.addressComponent.streetNumber.street isEqualToString:@""]) {
        NSLog(@"获取不到地址");
    }else {
        self.addressLabel.text = [NSString stringWithFormat:@"%@,%@",r.addressComponent.district,r.addressComponent.streetNumber.street];
    }
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"Error: %@",error);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.contentView addSubview:self.mapView];
        
        [self.mapView addSubview:self.nameLabel];
        
        [self.mapView addSubview:self.addressLabel];
        
        [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top);
            make.left.equalTo(cell.contentView.mas_left);
            make.right.equalTo(cell.contentView.mas_right);
            make.height.mas_equalTo(200.f);
            
            make.bottom.equalTo(cell.contentView.mas_bottom);
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
        
        return cell;
    }else if (indexPath.section == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.contentView addSubview:self.stepView];
        
        [_stepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top);
            make.left.equalTo(cell.contentView.mas_left);
            make.right.equalTo(cell.contentView.mas_right);
            make.height.mas_equalTo(250.f);
            
            make.bottom.equalTo(cell.contentView.mas_bottom);
        }];
        
        return cell;
    }else if (indexPath.section == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.contentView addSubview:self.physicalTipView];
        
        [_physicalTipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top);
            make.left.equalTo(cell.contentView.mas_left);
            make.right.equalTo(cell.contentView.mas_right);
            make.height.mas_equalTo(80.f);
            
            make.bottom.equalTo(cell.contentView.mas_bottom);
        }];
        
        return cell;
    }else {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.contentView addSubview:self.healthTipView];
        
        
        [_healthTipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top);
            make.left.equalTo(cell.contentView.mas_left);
            make.right.equalTo(cell.contentView.mas_right);
            make.height.mas_equalTo(80.f);
            
            make.bottom.equalTo(cell.contentView.mas_bottom);
        }];
        
        return cell;
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if (![annotation isKindOfClass:[MAPointAnnotation class]]) {
        return nil;
    }
    
    static NSString *reuseIndetifier = @"HomeParentPointReuseIndetifier";
    MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
    if (annotationView == nil) {
        annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
    }
    
    annotationView.image = [UIImage imageNamed:@"location"];
    
    return annotationView;
}

- (AMapSearchAPI *)search {
    if (!_search) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    
    return _search;
}

- (MAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MAMapView alloc] init];
        _mapView.showsUserLocation = NO;
        _mapView.showsCompass = NO;
        _mapView.showsScale = NO;
        _mapView.userTrackingMode = MAUserTrackingModeNone;
        _mapView.delegate = self;
        _mapView.hidden = YES;
        [_mapView setZoomLevel:15.f];
        
        // 自定义定位点
        MAUserLocationRepresentation * r = [[MAUserLocationRepresentation alloc] init];
        r.showsAccuracyRing = NO;
        r.showsHeadingIndicator = NO;
        r.image = [UIImage imageNamed:@"location"];
        [_mapView updateUserLocationRepresentation:r];
    }
    
    return _mapView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:22.f];
    }
    
    return _nameLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.backgroundColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00];
        _addressLabel.textColor = [UIColor whiteColor];
        _addressLabel.font = [UIFont boldSystemFontOfSize:22.f];
    }
    
    return _addressLabel;
}

- (StepView *)stepView {
    if (!_stepView) {
        _stepView = [[StepView alloc] init];
        _stepView.hidden = YES;
    }
    
    return _stepView;
}

- (TipView *)physicalTipView {
    if (!_physicalTipView) {
        _physicalTipView = [[TipView alloc] init];
        // TODO: 测试数据
        _physicalTipView.titleLabel.text = @"老人当前健康状况：";
        _physicalTipView.tipLabel.text = @"良好！请继续保持";
        _physicalTipView.hidden = YES;
    }
    
    return _physicalTipView;
}

- (TipView *)healthTipView {
    if (!_healthTipView) {
        _healthTipView = [[TipView alloc] init];
        // TODO: 测试数据
        _healthTipView.titleLabel.text = @"健康提醒：";
        _healthTipView.tipLabel.text = @"现在是中午，到老人使用XXX药的时候了";
        _healthTipView.hidden = YES;
    }
    
    return _healthTipView;
}

- (void)setupUI {
    // 创建控件
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 200;
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
    
    // 设置布局
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(getRectNavAndStatusHeight, 0, -TabBarHeight, 0));
    }];
    
    [_noOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_top).offset(200.f);
        make.centerX.equalTo(self.tableView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(101.33f, 25.f));
    }];
}

@end
