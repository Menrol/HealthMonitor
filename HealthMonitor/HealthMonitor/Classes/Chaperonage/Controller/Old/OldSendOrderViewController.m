//
//  OldSendOrderViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/13.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "OldSendOrderViewController.h"
#import "ChangeAddressViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <Masonry/Masonry.h>

@interface OldSendOrderViewController ()<AMapSearchDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MAMapViewDelegate> {
    NSArray            *_healthDataArray;
    NSArray            *_chapTypeArray;
    NSString           *_city;
}
@property(strong,nonatomic) MAMapView       *mapView;
@property(strong,nonatomic) UILabel         *addressLabel;
@property(strong,nonatomic) AMapSearchAPI   *search;
@property(strong,nonatomic) UILabel         *emergencyLabel;
@property(strong,nonatomic) UILabel         *beChapLabel;
@property(strong,nonatomic) UITextField     *healthTextField;
@property(strong,nonatomic) UIButton        *healthButton;
@property(strong,nonatomic) UITableView     *healthTableView;
@property(strong,nonatomic) UITextField     *chapTypeTextField;
@property(strong,nonatomic) UIButton        *chapTypeButton;
@property(strong,nonatomic) UITableView     *chapTypeTableView;
@property(strong,nonatomic) UITextField     *chapStartTextField;
@property(strong,nonatomic) UITextField     *chapEndTextField;
@property(strong,nonatomic) UITextView      *remarkTextView;

@end

@implementation OldSendOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _chapTypeArray = @[@"临时陪护", @"长期陪护"];
    _healthDataArray = @[@"健康", @"患病"];
    
    [self setupUI];
}

- (void)clickSendButton {
    NSLog(@"发布");
}

- (void)clickShowDownWithButton:(UIButton *)btn {
    if (btn.tag == 1001) {
        _healthTableView.hidden = !_healthTableView.hidden;
    }else {
        _chapTypeTableView.hidden = !_chapTypeTableView.hidden;
    }
    
}

- (void)clickChangeAddressButton {
    NSLog(@"修改地址");
    ChangeAddressViewController *vc = [[ChangeAddressViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.userCoordinate = _mapView.userLocation.location.coordinate;
    vc.city = _city;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickReturn {
    [self.navigationController popViewControllerAnimated:YES];
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
        _addressLabel.text = r.formattedAddress;
        _city = r.addressComponent.city;
    }else {
        NSLog(@"获取不到地址");
    }
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"Error: %@",error);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 101) {
        NSString *text = [NSString stringWithFormat:@"  %@",_healthDataArray[indexPath.row]];
        _healthTextField.text = text;
        _healthTableView.hidden = YES;
    }else {
        NSString *text = [NSString stringWithFormat:@"  %@",_chapTypeArray[indexPath.row]];
        _chapTypeTextField.text = text;
        _chapTypeTableView.hidden = YES;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 101) {
        return _healthDataArray.count;
    }else {
        return _healthDataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier;
    if (tableView.tag == 101) {
        identifier = @"sexTableViewCell";
    }else {
        identifier = @"workTypeTableCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = [UIColor blackColor].CGColor;
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (tableView.tag == 101) {
        cell.textLabel.text = _healthDataArray[indexPath.row];
    }else {
        cell.textLabel.text = _chapTypeArray[indexPath.row];
    }
    
    return cell;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _healthTableView.hidden = YES;
    _chapTypeTableView.hidden = YES;
    [_healthTableView resignFirstResponder];
    [_chapTypeTextField resignFirstResponder];
    [_chapStartTextField resignFirstResponder];
    [_chapEndTextField resignFirstResponder];
    [_remarkTextView resignFirstResponder];
}

- (AMapSearchAPI *)search {
    if (!_search) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    
    return _search;
}

- (void)setupUI {
    self.title = @"发布新单";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrows_left"] style:UIBarButtonItemStylePlain target:self action:@selector(clickReturn)];
    
    // 创建控件
    UIView *upView = [[UIView alloc] init];
    upView.layer.borderColor = [UIColor blackColor].CGColor;
    upView.layer.borderWidth = 0.5;
    upView.backgroundColor = [UIColor whiteColor];
    upView.userInteractionEnabled = YES;
    [self.view addSubview:upView];
    
    _mapView = [[MAMapView alloc] init];
    _mapView.showsUserLocation = YES;
    _mapView.showsCompass = NO;
    _mapView.showsScale = NO;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    _mapView.delegate = self;
    [upView addSubview:_mapView];
    
    // 自定义定位点
    MAUserLocationRepresentation * r = [[MAUserLocationRepresentation alloc] init];
    r.showsAccuracyRing = NO;
    r.showsHeadingIndicator = NO;
    r.image = [UIImage imageNamed:@"location"];
    [_mapView updateUserLocationRepresentation:r];
    
    UILabel *addressTitleLabel = [[UILabel alloc] init];
    addressTitleLabel.text = @"地址：";
    addressTitleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [upView addSubview:addressTitleLabel];
    
    _addressLabel = [[UILabel alloc] init];
    _addressLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [upView addSubview:_addressLabel];
    
    UIButton *changeAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeAddressButton setImage:[UIImage imageNamed:@"arrows_right"] forState:UIControlStateNormal];
    [changeAddressButton addTarget:self action:@selector(clickChangeAddressButton) forControlEvents:UIControlEventTouchUpInside];
    [upView addSubview:changeAddressButton];
    
    UIView *downView = [[UIView alloc] init];
    downView.layer.borderColor = [UIColor blackColor].CGColor;
    downView.layer.borderWidth = 0.5;
    downView.userInteractionEnabled = YES;
    [self.view addSubview:downView];
    
    UILabel *emergencyTitleLabel = [[UILabel alloc] init];
    emergencyTitleLabel.text = @"紧急情况：";
    emergencyTitleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [downView addSubview:emergencyTitleLabel];
    
    _emergencyLabel = [[UILabel alloc] init];
    _emergencyLabel.font = [UIFont boldSystemFontOfSize:16.f];
    // TODO: 测试数据
    _emergencyLabel.text = @"普通陪护";
    [downView addSubview:_emergencyLabel];
    
    UILabel *beChapTitleLabel = [[UILabel alloc] init];
    beChapTitleLabel.text = @"被陪护人：";
    beChapTitleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [downView addSubview:beChapTitleLabel];
    
    _beChapLabel = [[UILabel alloc] init];
    _beChapLabel.font = [UIFont boldSystemFontOfSize:16.f];
    // TODO: 测试数据
    _beChapLabel.text = @"张三";
    [downView addSubview:_beChapLabel];
    
    UILabel *healthLabel = [[UILabel alloc] init];
    healthLabel.text = @"健康状况：";
    healthLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [downView addSubview:healthLabel];
    
    _healthTextField = [[UITextField alloc] init];
    _healthTextField.text = @"  健康";
    _healthTextField.layer.borderColor = [UIColor blackColor].CGColor;
    _healthTextField.layer.borderWidth = 1;
    _healthTextField.delegate = self;
    [downView addSubview:_healthTextField];
    
    _healthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _healthButton.layer.borderColor = [UIColor blackColor].CGColor;
    _healthButton.layer.borderWidth = 1;
    [_healthButton setImage:[UIImage imageNamed:@"arrows_down"] forState:UIControlStateNormal];
    [_healthButton addTarget:self action:@selector(clickShowDownWithButton:) forControlEvents:UIControlEventTouchUpInside];
    _healthButton.tag = 1001;
    [downView addSubview:_healthButton];
    
    _healthTableView = [[UITableView alloc] init];
    _healthTableView.delegate = self;
    _healthTableView.dataSource = self;
    _healthTableView.hidden = YES;
    _healthTableView.layer.borderColor = [UIColor blackColor].CGColor;
    _healthTableView.layer.borderWidth = 1;
    _healthTableView.backgroundColor = [UIColor whiteColor];
    _healthTableView.tag = 101;
    [downView addSubview:_healthTableView];
    
    UILabel *chapTypeLabel = [[UILabel alloc] init];
    chapTypeLabel.text = @"陪护类型：";
    chapTypeLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [downView addSubview:chapTypeLabel];
    
    _chapTypeTextField = [[UITextField alloc] init];
    _chapTypeTextField.text = @"  临时陪护";
    _chapTypeTextField.layer.borderColor = [UIColor blackColor].CGColor;
    _chapTypeTextField.layer.borderWidth = 1;
    _chapTypeTextField.delegate = self;
    [downView addSubview:_chapTypeTextField];
    
    _chapTypeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _chapTypeButton.layer.borderColor = [UIColor blackColor].CGColor;
    _chapTypeButton.layer.borderWidth = 1;
    [_chapTypeButton setImage:[UIImage imageNamed:@"arrows_down"] forState:UIControlStateNormal];
    [_chapTypeButton addTarget:self action:@selector(clickShowDownWithButton:) forControlEvents:UIControlEventTouchUpInside];
    _chapTypeButton.tag = 1002;
    [downView addSubview:_chapTypeButton];
    
    _chapTypeTableView = [[UITableView alloc] init];
    _chapTypeTableView.delegate = self;
    _chapTypeTableView.dataSource = self;
    _chapTypeTableView.hidden = YES;
    _chapTypeTableView.layer.borderColor = [UIColor blackColor].CGColor;
    _chapTypeTableView.layer.borderWidth = 1;
    _chapTypeTableView.backgroundColor = [UIColor whiteColor];
    _chapTypeTableView.tag = 102;
    [downView addSubview:_chapTypeTableView];
    
    UILabel *chapStartLabel = [[UILabel alloc] init];
    chapStartLabel.text = @"陪护开始时间：";
    chapStartLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [downView addSubview:chapStartLabel];
    
    _chapStartTextField = [[UITextField alloc] init];
    _chapStartTextField.placeholder = @"  请输入陪护开始时间";
    _chapStartTextField.layer.borderColor = [UIColor blackColor].CGColor;
    _chapStartTextField.layer.borderWidth = 1;
    [downView addSubview:_chapStartTextField];
    
    UILabel *chapEndLabel = [[UILabel alloc] init];
    chapEndLabel.text = @"陪护结束时间：";
    chapEndLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [downView addSubview:chapEndLabel];
    
    _chapEndTextField = [[UITextField alloc] init];
    _chapEndTextField.placeholder = @"  请输入陪护结束时间";
    _chapEndTextField.layer.borderColor = [UIColor blackColor].CGColor;
    _chapEndTextField.layer.borderWidth = 1;
    [downView addSubview:_chapEndTextField];
    
    UILabel *remarkLabel = [[UILabel alloc] init];
    remarkLabel.text = @"备注：";
    remarkLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [downView addSubview:remarkLabel];
    
    _remarkTextView = [[UITextView alloc] init];
    _remarkTextView.layer.borderColor = [UIColor blackColor].CGColor;
    _remarkTextView.layer.borderWidth = 1;
    [downView addSubview:_remarkTextView];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sendButton setTitle:@"发布" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    sendButton.layer.borderWidth = 1;
    sendButton.layer.borderColor = [UIColor blackColor].CGColor;
    sendButton.layer.cornerRadius = 5;
    sendButton.layer.masksToBounds = YES;
    [sendButton addTarget:self action:@selector(clickSendButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    
    [downView bringSubviewToFront:_healthTableView];
    [downView bringSubviewToFront:_chapTypeTableView];
    
    // 设置布局
    [upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(getRectNavAndStatusHeight);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(250.f);
    }];
    
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(upView.mas_top);
        make.left.equalTo(upView.mas_left);
        make.right.equalTo(upView.mas_right);
        make.height.mas_equalTo(200.f);
    }];
    
    [addressTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mapView.mas_bottom).offset(15.f);
        make.left.equalTo(upView.mas_left).offset(15.f);
        make.height.mas_equalTo(16.f);
    }];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressTitleLabel.mas_right);
        make.top.equalTo(addressTitleLabel.mas_top);
        make.height.equalTo(addressTitleLabel.mas_height);
        make.right.equalTo(changeAddressButton.mas_left).offset(-15.f);
    }];
    
    [changeAddressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLabel.mas_top);
        make.right.equalTo(upView.mas_right).offset(-15.f);
        make.height.mas_equalTo(16.f);
        make.width.mas_equalTo(16.f);
    }];
    
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(upView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-TabBarHeight);
    }];
    
    [emergencyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(downView.mas_top).offset(20.f);
        make.left.equalTo(downView.mas_left).offset(10.f);
        make.height.mas_equalTo(16.f);
        make.width.mas_equalTo(82.f);
    }];
    
    [_emergencyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(emergencyTitleLabel.mas_right);
        make.top.equalTo(emergencyTitleLabel.mas_top);
        make.height.equalTo(emergencyTitleLabel.mas_height);
        make.width.equalTo(emergencyTitleLabel.mas_width);
    }];
    
    [beChapTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emergencyLabel.mas_top);
        make.left.equalTo(chapTypeLabel.mas_left);
        make.height.equalTo(self.emergencyLabel.mas_height);
        make.width.equalTo(self.emergencyLabel.mas_width);
    }];
    
    [_beChapLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(beChapTitleLabel.mas_right);
        make.top.equalTo(beChapTitleLabel.mas_top);
        make.right.equalTo(downView.mas_right).offset(-10.f);
        make.height.mas_equalTo(16.f);
    }];
    
    [healthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(emergencyTitleLabel.mas_bottom).offset(25.f);
        make.left.equalTo(downView.mas_left).offset(10.f);
        make.height.mas_equalTo(16.f);
        make.width.mas_equalTo(82.f);
    }];
    
    [_healthTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(healthLabel.mas_right);
        make.centerY.equalTo(healthLabel.mas_centerY);
        make.width.mas_equalTo(50.f);
        make.height.mas_equalTo(40.f);
    }];
    
    [_healthButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.healthTextField.mas_right);
        make.centerY.equalTo(healthLabel.mas_centerY);
        make.width.mas_equalTo(24.f);
        make.height.mas_equalTo(40.f);
    }];
    
    [_healthTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.healthTextField.mas_bottom);
        make.left.equalTo(self.healthTextField.mas_left);
        make.right.equalTo(self.healthButton.mas_right);
        make.height.mas_equalTo(80.f);
    }];
    
    [chapTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(healthLabel.mas_top);
        make.left.equalTo(self.healthButton.mas_right).offset(10.f);
        make.height.mas_equalTo(16.f);
        make.width.mas_equalTo(82.f);
    }];
    
    [_chapTypeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(chapTypeLabel.mas_right);
        make.centerY.equalTo(chapTypeLabel.mas_centerY);
        make.height.mas_equalTo(40.f);
    }];
    
    [_chapTypeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chapTypeTextField.mas_right);
        make.centerY.equalTo(chapTypeLabel.mas_centerY);
        make.width.mas_equalTo(24.f);
        make.height.mas_equalTo(40.f);
        make.right.equalTo(downView.mas_right).offset(-10.f);
    }];
    
    [_chapTypeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chapTypeTextField.mas_bottom);
        make.left.equalTo(self.chapTypeTextField.mas_left);
        make.right.equalTo(self.chapTypeButton.mas_right);
        make.height.mas_equalTo(80.f);
    }];
    
    [chapStartLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(healthLabel.mas_bottom).offset(45.f);
        make.left.equalTo(downView.mas_left).offset(10.f);
        make.height.mas_equalTo(16.f);
    }];
    
    [_chapStartTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(chapStartLabel.mas_centerY);
        make.left.equalTo(chapStartLabel.mas_right);
        make.right.equalTo(downView.mas_right).offset(-10.f);
        make.height.mas_equalTo(40.f);
    }];
    
    [chapEndLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(chapStartLabel.mas_bottom).offset(35.f);
        make.left.equalTo(downView.mas_left).offset(10.f);
        make.height.mas_equalTo(16.f);
    }];
    
    [_chapEndTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(chapEndLabel.mas_centerY);
        make.left.equalTo(chapEndLabel.mas_right);
        make.right.equalTo(downView.mas_right).offset(-10.f);
        make.height.mas_equalTo(40.f);
    }];
    
    [remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(chapEndLabel.mas_bottom).offset(35.f);
        make.left.equalTo(downView.mas_left).offset(10.f);
        make.width.mas_equalTo(50.f);
        make.height.mas_equalTo(16.f);
    }];
    
    [_remarkTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remarkLabel.mas_bottom).offset(15.f);
        make.left.equalTo(remarkLabel.mas_left);
        make.right.equalTo(downView.mas_right).offset(-10.f);
        make.height.mas_equalTo(60.f);
    }];
    
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.remarkTextView.mas_bottom).offset(15.f);
        make.left.equalTo(downView.mas_left).offset(10.f);
        make.right.equalTo(downView.mas_right).offset(-10.f);
        make.bottom.equalTo(downView.mas_bottom).offset(-15.f);
    }];
}

@end
