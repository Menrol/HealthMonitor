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
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <Masonry/Masonry.h>

NSString * const ChildHomeTableViewCellID = @"ChildHomeTableViewCellID";

@interface ChildHomeViewController ()<AMapSearchDelegate, UITableViewDataSource, ChangeTableViewCellDelegate, MAMapViewDelegate> {
    ParentModel             *_curParentModel;
}
@property(strong,nonatomic) MAMapView       *mapView;
@property(strong,nonatomic) UILabel         *nameLabel;
@property(strong,nonatomic) UILabel         *addressLabel;
@property(strong,nonatomic) AMapSearchAPI   *search;
@property(strong,nonatomic) UIView          *changeView;
@property(strong,nonatomic) UITableView     *changeTableView;
@property(strong,nonatomic) StepView        *stepView;
@property(strong,nonatomic) TipView         *physicalTipView;
@property(strong,nonatomic) TipView         *healthTipView;
@property(strong,nonatomic) UITableView     *tableView;
@property(strong,nonatomic) ChildModel      *model;

@end

@implementation ChildHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    MainViewController *vc = (MainViewController *)self.tabBarController;
    _model = vc.model;
    _curParentModel = _model.parentList[0];
    vc.parentNickname = _curParentModel.nickname;
}

- (void)viewDidAppear:(BOOL)animated {
    [self changeParentWithParentModel:_curParentModel];
}

- (void)changeParentWithParentModel:(ParentModel *)model {
    _nameLabel.text = model.name;
    
    [_changeTableView reloadData];
}

- (void)clickChangeButton {
    NSLog(@"切换");
    self.changeView.hidden = !self.changeView.hidden;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    
    AMapReGeocodeSearchRequest *rego = [[AMapReGeocodeSearchRequest alloc] init];
    rego.location = [AMapGeoPoint locationWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
    rego.requireExtension = YES;
    
    [self.search AMapReGoecodeSearch:rego];
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if (response.regeocode != nil) {
        AMapReGeocode *r = response.regeocode;
        // TODO: 地址获取不到
        if ([r.addressComponent.district isEqualToString:@""] || [r.addressComponent.streetNumber.street isEqualToString:@""]) {
            NSLog(@"获取不到地址");
        }else {
            self.addressLabel.text = [NSString stringWithFormat:@"%@,%@",r.addressComponent.district,r.addressComponent.streetNumber.street];
        }
    }
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"Error: %@",error);
}

- (void)clickChangeButtonWithCell:(ChanageTableViewCell *)cell {
    NSLog(@"切换");
    self.changeView.hidden = YES;
    
    NSIndexPath *indexPath = [_changeTableView indexPathForCell:cell];
    _curParentModel = _model.parentList[indexPath.row];
    
    MainViewController *vc = (MainViewController *)self.tabBarController;
    vc.parentNickname = _curParentModel.nickname;
    
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
        return _model.parentList.count;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 100) {
        ChanageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChildHomeTableViewCellID forIndexPath:indexPath];
        cell.delegate = self;
        
        cell.model = _model.parentList[indexPath.row];
        if (_model.parentList[indexPath.row] == _curParentModel) {
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
        
        _mapView = [[MAMapView alloc] init];
        _mapView.showsUserLocation = YES;
        _mapView.showsCompass = NO;
        _mapView.showsScale = NO;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        _mapView.delegate = self;
        [_mapView setZoomLevel:15.f];
        [cell.contentView addSubview:_mapView];
        
        // 自定义定位点
        MAUserLocationRepresentation * r = [[MAUserLocationRepresentation alloc] init];
        r.showsAccuracyRing = NO;
        r.showsHeadingIndicator = NO;
        r.image = [UIImage imageNamed:@"location"];
        [_mapView updateUserLocationRepresentation:r];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:22.f];
        [self.mapView addSubview:_nameLabel];
        
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.backgroundColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00];
        _addressLabel.textColor = [UIColor whiteColor];
        _addressLabel.font = [UIFont boldSystemFontOfSize:22.f];
        [self.mapView addSubview:_addressLabel];
        
        UIButton *chageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [chageButton setTitle:@"切换" forState:UIControlStateNormal];
        [chageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        chageButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        chageButton.layer.borderColor = [UIColor blackColor].CGColor;
        chageButton.layer.borderWidth = 1;
        chageButton.layer.cornerRadius = 5;
        chageButton.layer.masksToBounds = YES;
        chageButton.backgroundColor = [UIColor whiteColor];
        [chageButton addTarget:self action:@selector(clickChangeButton) forControlEvents:UIControlEventTouchUpInside];
        [self.mapView addSubview:chageButton];
        
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
        
        [chageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.addressLabel.mas_centerY);
            make.right.equalTo(self.mapView.mas_right).offset(-10.f);
            make.height.mas_equalTo(30.f);
            make.width.mas_equalTo(70.f);
        }];
        
        
        return cell;
    }else if (indexPath.section == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _stepView = [[StepView alloc] init];
        [cell.contentView addSubview:_stepView];
        
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
        
        _physicalTipView = [[TipView alloc] init];
        _physicalTipView.titleLabel.text = @"老人当前健康状况：";
        _physicalTipView.tipLabel.text = @"良好！请继续保持";
        [cell.contentView addSubview:_physicalTipView];
        
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
        
        _healthTipView = [[TipView alloc] init];
        _healthTipView.titleLabel.text = @"健康提醒：";
        _healthTipView.tipLabel.text = @"现在是中午，到老人使用XXX药的时候了";
        [cell.contentView addSubview:_healthTipView];
        
        
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

- (AMapSearchAPI *)search {
    if (!_search) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    
    return _search;
}

- (void)setupUI {
    // 创建控件
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 200;
    _tableView.backgroundColor = [UIColor colorWithRed:0.95 green:0.94 blue:0.95 alpha:1.00];
    _tableView.sectionHeaderHeight = 10.f;
    _tableView.sectionFooterHeight = 0.01f;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
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
}

@end
