//
//  ChildHomeViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/18.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "ChildHomeViewController.h"
#import "StepView.h"
#import "TipView.h"
#import "ChanageTableViewCell.h"
#import "MainViewController.h"
#import "ChildModel.h"
#import "ParentModel.h"
#import "NetworkTool.h"
#import "RQProgressHUD.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import <YYModel/YYModel.h>

NSString * const ChildHomeTableViewCellID = @"ChildHomeTableViewCellID";

@interface ChildHomeViewController ()<AMapSearchDelegate, UITableViewDataSource, ChangeTableViewCellDelegate, MAMapViewDelegate>
@property(strong,nonatomic) MAMapView                        *mapView;
@property(strong,nonatomic) UILabel                          *nameLabel;
@property(strong,nonatomic) UILabel                          *addressLabel;
@property(strong,nonatomic) AMapSearchAPI                    *search;
@property(strong,nonatomic) UIView                           *changeView;
@property(strong,nonatomic) UITableView                      *changeTableView;
@property(strong,nonatomic) StepView                         *stepView;
@property(strong,nonatomic) TipView                          *physicalTipView;
@property(strong,nonatomic) TipView                          *healthTipView;
@property(strong,nonatomic) UIButton                         *chageButton;
@property(strong,nonatomic) UITableView                      *tableView;
@property(strong,nonatomic) UILabel                          *noOrderLabel;
@property(strong,nonatomic) ChildModel                       *model;
@property(strong,nonatomic) NSTimer                          *timer;
@property(strong,nonatomic) ParentModel                      *curParentModel;
@property(strong,nonatomic) NSMutableArray<ParentModel *>    *parentList;

@end

@implementation ChildHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    MainViewController *vc = (MainViewController *)self.tabBarController;
    _model = vc.model;
    
    [_tableView.mj_header beginRefreshing];
    
    __weak typeof(self) weakSelf = self;
    _timer = [NSTimer timerWithTimeInterval:5 * 60 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (weakSelf.curParentModel == nil) {
            return;
        }
        
        [[NetworkTool sharedTool] parentMessageWithNickname:weakSelf.curParentModel.nickname finished:^(id  _Nullable result, NSError * _Nullable error) {
            [weakSelf.tableView.mj_header endRefreshing];
            
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
        
        [[NetworkTool sharedTool] getParentStepCountWithNickname:weakSelf.curParentModel.nickname finished:^(id  _Nullable result, NSError * _Nullable error) {            
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
            
            NSArray *dataArray = result[@"data"];
            
            if (dataArray == nil) {
                return;
            }
            
            NSMutableArray *stepArray = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in dataArray) {
                [stepArray addObject:dic[@"walkCount"]];
            }
            
            weakSelf.stepView.stepCountLabel.text = [NSString stringWithFormat:@"%d",[stepArray.lastObject intValue]];
            weakSelf.stepView.stepArray = stepArray;
        }];
    }];
    
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)dealloc {
    [_timer invalidate];
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] childGetParentWithNickname:_model.nickname finished:^(id  _Nullable result, NSError * _Nullable error) {
        if (error) {
            [weakSelf.tableView.mj_header endRefreshing];
            NSLog(@"%@",error);
            
            [weakSelf.parentList removeAllObjects];
            
            weakSelf.mapView.hidden = YES;
            weakSelf.stepView.hidden = YES;
            weakSelf.healthTipView.hidden = YES;
            weakSelf.physicalTipView.hidden = YES;
            weakSelf.noOrderLabel.hidden = NO;
            weakSelf.tableView.backgroundColor = [UIColor whiteColor];
            weakSelf.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            MainViewController *vc = (MainViewController *)self.tabBarController;
            vc.parentNickname = @"";
            weakSelf.curParentModel = nil;
            
            return;
        }
        
        NSLog(@"%@",result);
        
        NSInteger code = [result[@"code"] integerValue];
        if (code != 200) {
            [weakSelf.tableView.mj_header endRefreshing];
            [RQProgressHUD rq_showErrorWithStatus:result[@"msg"]];
            
            [weakSelf.parentList removeAllObjects];
            
            weakSelf.mapView.hidden = YES;
            weakSelf.stepView.hidden = YES;
            weakSelf.healthTipView.hidden = YES;
            weakSelf.physicalTipView.hidden = YES;
            weakSelf.noOrderLabel.hidden = NO;
            weakSelf.tableView.backgroundColor = [UIColor whiteColor];
            weakSelf.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            MainViewController *vc = (MainViewController *)self.tabBarController;
            vc.parentNickname = @"";
            weakSelf.curParentModel = nil;
            
            return;
        }
        
        NSDictionary *dataDic = result[@"data"];
        
        if (dataDic == nil) {
            [weakSelf.tableView.mj_header endRefreshing];
            
            [weakSelf.parentList removeAllObjects];
            
            weakSelf.mapView.hidden = YES;
            weakSelf.stepView.hidden = YES;
            weakSelf.healthTipView.hidden = YES;
            weakSelf.physicalTipView.hidden = YES;
            weakSelf.noOrderLabel.hidden = NO;
            weakSelf.tableView.backgroundColor = [UIColor whiteColor];
            weakSelf.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            MainViewController *vc = (MainViewController *)self.tabBarController;
            vc.parentNickname = @"";
            weakSelf.curParentModel = nil;
            
            return;
        }
        
        ChildModel *model = [ChildModel yy_modelWithDictionary:dataDic];
        weakSelf.parentList = [NSMutableArray arrayWithArray:model.parentList];
        
        int tag = 0;
        for (int i = 0; i < weakSelf.parentList.count; i++) {
            if ([weakSelf.parentList[i].nickname isEqualToString:weakSelf.curParentModel.nickname]) {
                tag = 1;
                break;
            }
        }
        
        if (tag == 0) {
            weakSelf.curParentModel = weakSelf.parentList[0];
        }
        
        weakSelf.mapView.hidden = NO;
        weakSelf.stepView.hidden = NO;
        weakSelf.healthTipView.hidden = NO;
        weakSelf.physicalTipView.hidden = NO;
        weakSelf.noOrderLabel.hidden = YES;
        weakSelf.tableView.backgroundColor = [UIColor colorWithRed:0.95 green:0.94 blue:0.95 alpha:1.00];
        weakSelf.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        [self changeParentWithParentModel:weakSelf.curParentModel];
    }];
}

- (void)changeParentWithParentModel:(ParentModel *)model {
    if (!_tableView.mj_header.isRefreshing) {
        [RQProgressHUD rq_show];
    }
    
    MainViewController *vc = (MainViewController *)self.tabBarController;
    vc.parentNickname = model.nickname;
    
    self.nameLabel.text = model.name;
    [_changeTableView reloadData];
    
    dispatch_group_t group = dispatch_group_create();
    
    __weak typeof(self) weakSelf = self;
    dispatch_group_enter(group);
    [[NetworkTool sharedTool] parentMessageWithNickname:model.nickname finished:^(id  _Nullable result, NSError * _Nullable error) {
        dispatch_group_leave(group);
        
        if (error) {
            NSLog(@"%@",error);
            [weakSelf.mapView removeAnnotations:weakSelf.mapView.annotations];
            weakSelf.addressLabel.text = nil;
            
            return;
        }
        
        NSLog(@"%@",result);
        
        NSInteger code = [result[@"code"] integerValue];
        if (code != 200) {
            [RQProgressHUD rq_showErrorWithStatus:result[@"msg"]];
            [weakSelf.mapView removeAnnotations:weakSelf.mapView.annotations];
            weakSelf.addressLabel.text = nil;
            
            return;
        }
        
        NSDictionary *dataDic = result[@"data"];
        NSString *positionStr = dataDic[@"position"];
        
        if ((NSNull *)positionStr == [NSNull null]) {
            [weakSelf.mapView removeAnnotations:weakSelf.mapView.annotations];
            weakSelf.addressLabel.text = nil;
            
            return;
        }
        
        if ([positionStr componentsSeparatedByString:@" "].count < 2) {
            [weakSelf.mapView removeAnnotations:weakSelf.mapView.annotations];
            weakSelf.addressLabel.text = nil;
            
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
    
    dispatch_group_enter(group);
    [[NetworkTool sharedTool] getParentStepCountWithNickname:model.nickname finished:^(id  _Nullable result, NSError * _Nullable error) {
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
        
        NSArray *dataArray = result[@"data"];
        
        if (dataArray == nil) {
            return;
        }
        
        NSMutableArray *stepArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in dataArray) {
            [stepArray addObject:dic[@"walkCount"]];
        }
        
        weakSelf.stepView.stepCountLabel.text = [NSString stringWithFormat:@"%d",[stepArray.lastObject intValue]];
        weakSelf.stepView.stepArray = stepArray;
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (weakSelf.tableView.mj_header.isRefreshing) {
            [weakSelf.tableView.mj_header endRefreshing];
        }else {
            [RQProgressHUD dismiss];
        }
    });
    
}

- (void)clickChangeButton {
    NSLog(@"切换");
    self.changeView.hidden = !self.changeView.hidden;
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if (response.regeocode == nil) {
        self.addressLabel.text = nil;
        
        return;
    }
    
    AMapReGeocode *r = response.regeocode;
    if ([r.addressComponent.district isEqualToString:@""] || [r.addressComponent.streetNumber.street isEqualToString:@""]) {
        NSLog(@"获取不到地址");
        self.addressLabel.text = nil;
    }else {
        self.addressLabel.text = [NSString stringWithFormat:@"%@,%@",r.addressComponent.district,r.addressComponent.streetNumber.street];
    }
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    self.addressLabel.text = nil;
    NSLog(@"Error: %@",error);
}

- (void)clickChangeButtonWithCell:(ChanageTableViewCell *)cell {
    NSLog(@"切换");
    self.changeView.hidden = YES;
    
    NSIndexPath *indexPath = [_changeTableView indexPathForCell:cell];
    _curParentModel = _parentList[indexPath.row];
    
    [self changeParentWithParentModel:_curParentModel];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 100) {
        return 1;
    }
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 100) {
        return _parentList.count;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 100) {
        ChanageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChildHomeTableViewCellID forIndexPath:indexPath];
        cell.delegate = self;
        
        cell.model = _parentList[indexPath.row];
        if ([_parentList[indexPath.row].nickname isEqualToString:_curParentModel.nickname]) {
            cell.changeButton.userInteractionEnabled =  NO;
            cell.changeButton.alpha = 0.4;
        }else {
            cell.changeButton.userInteractionEnabled = YES;
            cell.changeButton.alpha = 1.f;
        }
        
        return cell;
    }
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.contentView addSubview:self.mapView];
        
        [self.mapView addSubview:self.nameLabel];
        
        [self.mapView addSubview:self.addressLabel];
        
        [self.mapView addSubview:self.chageButton];
        
        [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top);
            make.left.equalTo(cell.contentView.mas_left);
            make.right.equalTo(cell.contentView.mas_right);
            make.height.mas_equalTo(200.f);
            
            make.bottom.equalTo(cell.contentView.mas_bottom);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mapView.mas_top).offset(20.f);
            make.left.equalTo(self.mapView.mas_left).offset(10.f);
            make.height.mas_equalTo(22.f);
        }];
        
        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_top);
            make.left.equalTo(self.nameLabel.mas_right).offset(10.f);
            make.height.mas_equalTo(22.f);
        }];
        
        [self.chageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.addressLabel.mas_centerY);
            make.right.equalTo(self.mapView.mas_right).offset(-10.f);
            make.height.mas_equalTo(30.f);
            make.width.mas_equalTo(70.f);
        }];
        
        
        return cell;
    }else if (indexPath.section == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.contentView addSubview:self.stepView];
        
        [self.stepView mas_makeConstraints:^(MASConstraintMaker *make) {
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
        
        [self.healthTipView mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (UIButton *)chageButton {
    if (!_chageButton) {
        _chageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_chageButton setTitle:@"切换" forState:UIControlStateNormal];
        [_chageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _chageButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        _chageButton.layer.borderColor = [UIColor blackColor].CGColor;
        _chageButton.layer.borderWidth = 1;
        _chageButton.layer.cornerRadius = 5;
        _chageButton.layer.masksToBounds = YES;
        _chageButton.backgroundColor = [UIColor whiteColor];
        [_chageButton addTarget:self action:@selector(clickChangeButton) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _chageButton;
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
    
    _changeView = [[UIView alloc] init];
    _changeView.layer.borderColor = [UIColor blackColor].CGColor;
    _changeView.layer.borderWidth = 1;
    _changeView.backgroundColor = [UIColor whiteColor];
    _changeView.hidden = YES;
    [self.view addSubview:_changeView];
    
    _changeTableView = [[UITableView alloc] init];
    _changeTableView.dataSource = self;
    [_changeTableView registerClass:[ChanageTableViewCell class] forCellReuseIdentifier:ChildHomeTableViewCellID];
    _changeTableView.tableFooterView = [[UIView alloc] init];
    _changeTableView.tag = 100;
    [_changeView addSubview:_changeTableView];
    
    _noOrderLabel = [[UILabel alloc] init];
    _noOrderLabel.text = @"暂无绑定的老人，请您前往我的页面绑定老人";
    _noOrderLabel.textAlignment = NSTextAlignmentCenter;
    _noOrderLabel.font = [UIFont boldSystemFontOfSize:20.f];
    _noOrderLabel.textColor = [UIColor grayColor];
    _noOrderLabel.numberOfLines = 0;
    [self.tableView addSubview:_noOrderLabel];
    
    // 设置布局
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(getRectNavAndStatusHeight, 0, -TabBarHeight, 0));
    }];
    
    [_changeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.height.mas_equalTo(130);
        make.width.mas_equalTo(MainScreenWith - 30);
    }];
    
    [_changeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.changeView);
        make.size.mas_equalTo(CGSizeMake(MainScreenWith - 60, 100));
    }];
    
    [_noOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_top).offset(200.f);
        make.centerX.equalTo(self.tableView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(MainScreenWith, 100.f));
    }];
}

@end
