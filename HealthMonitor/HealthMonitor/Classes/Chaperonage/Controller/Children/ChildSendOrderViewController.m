//
//  ChildSendOrderViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/18.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "ChildSendOrderViewController.h"
#import "ChangeAddressViewController.h"
#import "MainViewController.h"
#import "ChildModel.h"
#import "ParentModel.h"
#import "NetworkTool.h"
#import "RQProgressHUD.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <Masonry/Masonry.h>

@interface ChildSendOrderViewController ()<AMapSearchDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MAMapViewDelegate,ChangeAddressViewControllerDelegate> {
    NSArray                       *_healthDataArray;
    NSArray                       *_chapTypeArray;
    NSString                      *_city;
    CLLocationCoordinate2D        _curCoordinate;
    NSInteger                     _escortType;
    NSInteger                     _healthStatus;
    NSInteger                     _beChapIndex;
}
@property(strong,nonatomic) MAMapView       *mapView;
@property(strong,nonatomic) UILabel         *addressLabel;
@property(strong,nonatomic) AMapSearchAPI   *search;
@property(strong,nonatomic) UILabel         *emergencyLabel;
@property(strong,nonatomic) UITextField     *beChapTextField;
@property(strong,nonatomic) UIButton        *beChapButton;
@property(strong,nonatomic) UITableView     *beChapTableView;
@property(strong,nonatomic) NSMutableArray  *beChapArray;
@property(strong,nonatomic) UITextField     *healthTextField;
@property(strong,nonatomic) UIButton        *healthButton;
@property(strong,nonatomic) UITableView     *healthTableView;
@property(strong,nonatomic) UITextField     *chapTypeTextField;
@property(strong,nonatomic) UIButton        *chapTypeButton;
@property(strong,nonatomic) UITableView     *chapTypeTableView;
@property(strong,nonatomic) UITextField     *chapStartTextField;
@property(strong,nonatomic) UITextField     *chapEndTextField;
@property(strong,nonatomic) UITextView      *remarkTextView;
@property(strong,nonatomic) ChildModel      *model;

@end

@implementation ChildSendOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    _chapTypeArray = @[@"临时陪护", @"长期陪护"];
    _healthDataArray = @[@"健康", @"患病"];
    _beChapArray = [[NSMutableArray alloc] init];
    
    MainViewController *vc = (MainViewController *)self.tabBarController;
    _model = vc.model;
    
    for (ParentModel *model in _model.parentList) {
        [_beChapArray addObject:model.name];
    }
    
    _beChapTextField.text = [NSString stringWithFormat:@"  %@",_model.parentList[0].name];
    
    [_beChapTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.beChapTextField.mas_bottom);
        make.left.equalTo(self.beChapTextField.mas_left);
        make.right.equalTo(self.beChapButton.mas_right);
        
        if (self.beChapArray.count <= 4) {
            make.height.mas_equalTo(self.beChapArray.count * 40.f);
        }else {
            make.height.mas_equalTo(160.f);
        }
        
    }];
}

- (void)clickSendButton {
    NSLog(@"发布");
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *endDate = [formatter dateFromString:[_chapEndTextField.text componentsSeparatedByString:@"  "][1]];
    NSDate *startDate = [formatter dateFromString:[_chapStartTextField.text componentsSeparatedByString:@"  "][1]];
    
    NSComparisonResult result = [startDate compare:endDate];
    if (result == NSOrderedDescending || result == NSOrderedSame) {
        [RQProgressHUD rq_showErrorWithStatus:@"陪护结束时间不可早于或等于陪护开始时间"];
        
        return;
    }
    
    NSInteger escortStart = [startDate timeIntervalSince1970] * 1000;
    NSInteger escortEnd = [endDate timeIntervalSince1970] * 1000;
    NSString *positionStr = [NSString stringWithFormat:@"%f %f",_curCoordinate.latitude,_curCoordinate.longitude];

    [RQProgressHUD rq_show];
    [[NetworkTool sharedTool] sendOrderWithAddress:_addressLabel.text desc:_remarkTextView.text emergencyStatus:0 escortEnd:escortEnd escortStart:escortStart escortType:_escortType healthStatus:_healthStatus parentEscort:_model.parentList[_beChapIndex].nickname position:positionStr finished:^(id  _Nullable result, NSError * _Nullable error) {
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
        
        __weak typeof(self) weakSelf = self;
        [RQProgressHUD rq_showSuccessWithStatus:@"发布订单成功" completion:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

- (void)clickShowDownWithButton:(UIButton *)btn {
    if (btn.tag == 1000) {
        _beChapTableView.hidden = !_beChapTableView.hidden;
    }else if (btn.tag == 1001) {
        _healthTableView.hidden = !_healthTableView.hidden;
    }else {
        _chapTypeTableView.hidden = !_chapTypeTableView.hidden;
    }
    
}

- (void)clickChangeAddressButton {
    NSLog(@"修改地址");
    ChangeAddressViewController *vc = [[ChangeAddressViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.userCoordinate = _curCoordinate;
    vc.city = _city;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)datePickerChange:(UIDatePicker *)datePicker {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString = [NSString stringWithFormat:@"  %@",[formatter stringFromDate:datePicker.date]];
    
    if (datePicker.tag == 10000) {
        _chapStartTextField.text = dateString;
    }else {
        _chapEndTextField.text = dateString;
    }
}

- (void)clickReturn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeAddressControllerDidClickChooseWithAddress:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate {
    
    _curCoordinate = coordinate;
    
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = MAUserTrackingModeNone;
    
    [_mapView removeAnnotations:_mapView.annotations];
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    [_mapView addAnnotation:annotation];
    
    [_mapView setCenterCoordinate:coordinate];
    
    _addressLabel.text = address;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
    }else if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *reuseIndetifier = @"userPointReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        
        annotationView.image = [UIImage imageNamed:@"location"];
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    
    _curCoordinate = userLocation.location.coordinate;
    
    AMapReGeocodeSearchRequest *rego = [[AMapReGeocodeSearchRequest alloc] init];
    rego.location = [AMapGeoPoint locationWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
    rego.requireExtension = YES;
    
    [self.search AMapReGoecodeSearch:rego];
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if (response.regeocode != nil) {
        AMapReGeocode *r = response.regeocode;
        _addressLabel.text = r.formattedAddress;
    }else {
        NSLog(@"获取不到地址");
    }
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"Error: %@",error);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 100) {
        NSString *text = [NSString stringWithFormat:@"  %@",_beChapArray[indexPath.row]];
        _beChapTextField.text = text;
        _beChapTableView.hidden = YES;
        _beChapIndex = indexPath.row;
    }else if (tableView.tag == 101) {
        NSString *text = [NSString stringWithFormat:@"  %@",_healthDataArray[indexPath.row]];
        _healthTextField.text = text;
        _healthTableView.hidden = YES;
        _healthStatus = indexPath.row;
    }else {
        NSString *text = [NSString stringWithFormat:@"  %@",_chapTypeArray[indexPath.row]];
        _chapTypeTextField.text = text;
        _chapTypeTableView.hidden = YES;
        _escortType = indexPath.row;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 100) {
        return _beChapArray.count;
    }else if (tableView.tag == 101) {
        return _healthDataArray.count;
    }else {
        return _healthDataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier;
    if (tableView.tag == 100) {
        identifier = @"beChapTableViewCell";
    }else if (tableView.tag == 101) {
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
    
    if (tableView.tag == 100) {
        cell.textLabel.text = _beChapArray[indexPath.row];
    }else if (tableView.tag == 101) {
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
    _beChapTableView.hidden = YES;
    [_healthTextField resignFirstResponder];
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
    [_mapView setZoomLevel:15.f];
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
    
    _beChapTextField = [[UITextField alloc] init];
    _beChapTextField.text = @"  张三";
    _beChapTextField.layer.borderColor = [UIColor blackColor].CGColor;
    _beChapTextField.layer.borderWidth = 1;
    _beChapTextField.delegate = self;
    [downView addSubview:_beChapTextField];
    
    _beChapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _beChapButton.layer.borderColor = [UIColor blackColor].CGColor;
    _beChapButton.layer.borderWidth = 1;
    [_beChapButton setImage:[UIImage imageNamed:@"arrows_down"] forState:UIControlStateNormal];
    [_beChapButton addTarget:self action:@selector(clickShowDownWithButton:) forControlEvents:UIControlEventTouchUpInside];
    _beChapButton.tag = 1000;
    [downView addSubview:_beChapButton];
    
    _beChapTableView = [[UITableView alloc] init];
    _beChapTableView.delegate = self;
    _beChapTableView.dataSource = self;
    _beChapTableView.hidden = YES;
    _beChapTableView.layer.borderColor = [UIColor blackColor].CGColor;
    _beChapTableView.layer.borderWidth = 1;
    _beChapTableView.backgroundColor = [UIColor whiteColor];
    _beChapTableView.tag = 100;
    [downView addSubview:_beChapTableView];
    
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
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    
    _chapStartTextField = [[UITextField alloc] init];
    _chapStartTextField.placeholder = @"  请输入陪护开始时间";
    _chapStartTextField.layer.borderColor = [UIColor blackColor].CGColor;
    _chapStartTextField.layer.borderWidth = 1;
    _chapStartTextField.text = [NSString stringWithFormat:@"  %@",dateStr];
    [downView addSubview:_chapStartTextField];
    
    UIDatePicker *startDatePicker = [[UIDatePicker alloc] init];
    startDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [startDatePicker addTarget:self action:@selector(datePickerChange:) forControlEvents:UIControlEventValueChanged];
    startDatePicker.date = [NSDate date];
    startDatePicker.tag = 10000;
    _chapStartTextField.inputView = startDatePicker;
    
    UILabel *chapEndLabel = [[UILabel alloc] init];
    chapEndLabel.text = @"陪护结束时间：";
    chapEndLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [downView addSubview:chapEndLabel];
    
    _chapEndTextField = [[UITextField alloc] init];
    _chapEndTextField.placeholder = @"  请输入陪护结束时间";
    _chapEndTextField.layer.borderColor = [UIColor blackColor].CGColor;
    _chapEndTextField.layer.borderWidth = 1;
    _chapEndTextField.text = [NSString stringWithFormat:@"  %@",dateStr];
    [downView addSubview:_chapEndTextField];
    
    UIDatePicker *endDatePicker = [[UIDatePicker alloc] init];
    endDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [endDatePicker addTarget:self action:@selector(datePickerChange:) forControlEvents:UIControlEventValueChanged];
    endDatePicker.date = [NSDate date];
    endDatePicker.tag = 10001;
    _chapEndTextField.inputView = endDatePicker;
    
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
    [downView bringSubviewToFront:_beChapTableView];
    
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
        make.size.mas_equalTo(CGSizeMake(49.f, 16.f));
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
    
    [_beChapTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(beChapTitleLabel.mas_right);
        make.centerY.equalTo(beChapTitleLabel.mas_centerY);
        make.height.mas_equalTo(40.f);
    }];
    
    [_beChapButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.beChapTextField.mas_right);
        make.centerY.equalTo(beChapTitleLabel.mas_centerY);
        make.width.mas_equalTo(24.f);
        make.height.mas_equalTo(40.f);
        make.right.equalTo(downView.mas_right).offset(-10.f);
    }];
    
    [_beChapTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.beChapTextField.mas_bottom);
        make.left.equalTo(self.beChapTextField.mas_left);
        make.right.equalTo(self.beChapButton.mas_right);
        make.height.mas_equalTo(80.f);
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
        make.size.mas_equalTo(CGSizeMake(114.33, 16.f));
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
        make.size.mas_equalTo(CGSizeMake(114.33, 16.f));
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
