//
//  ChildCurOrderViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/18.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "ChildCurOrderViewController.h"
#import "CurOrderUpView.h"
#import "CurOrderDownView.h"
#import "ChapDetailViewController.h"
#import "NetworkTool.h"
#import "RQProgressHUD.h"
#import "MainViewController.h"
#import "ParentModel.h"
#import "OrderDetailModel.h"
#import "MedicineModel.h"
#import <Masonry/Masonry.h>
#import <YYModel/YYModel.h>
#import <MJRefresh/MJRefresh.h>

@interface ChildCurOrderViewController ()<UITableViewDataSource, CurOrderUpViewDelegate>
@property(strong,nonatomic) CurOrderUpView              *upView;
@property(strong,nonatomic) CurOrderDownView            *downView;
@property(strong,nonatomic) UILabel                     *noOrderLabel;
@property(strong,nonatomic) UITableView                 *tableView;
@property(strong,nonatomic) OrderDetailModel            *model;
@property(strong,nonatomic) NSString                    *parentNickname;
@property(strong,nonatomic) NSTimer                     *timer;
@property(assign,nonatomic) CLLocationCoordinate2D      parentCoordinate;

@end

@implementation ChildCurOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    __weak typeof(self) weakSelf = self;
    _timer = [NSTimer timerWithTimeInterval:5 * 60 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (weakSelf.model == nil) {
            return;
        }
        
        [[NetworkTool sharedTool] chapGetMessageWithNickname:weakSelf.model.escortName finished:^(id  _Nullable result, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@",error);
                
                return;
            }
            
            NSLog(@"%@",result);
            
            NSInteger code = [result[@"code"] integerValue];
            if (code != 200) {
                return;
            }
            
            NSDictionary *dataDic = result[@"data"];
            NSString *positionStr = dataDic[@"escortPosition"];
            
            if ([positionStr componentsSeparatedByString:@" "].count < 2) {
                return;
            }
            
            CLLocationCoordinate2D chapCoordinate = CLLocationCoordinate2DMake([[positionStr componentsSeparatedByString:@" "][0] doubleValue], [[positionStr componentsSeparatedByString:@" "][1] doubleValue]);
            
            if (CLLocationCoordinate2DIsValid(chapCoordinate)) {
                return;
            }
            
            [weakSelf.upView.mapView removeAnnotations:weakSelf.upView.mapView.annotations];
            
            RQPointAnnotation *chapAnnotation = [[RQPointAnnotation alloc] initWithCoordinate:chapCoordinate index:1];
            [weakSelf.upView.mapView addAnnotation:chapAnnotation];
            [weakSelf.upView.mapView setCenterCoordinate:chapCoordinate animated:YES];
            
            if (CLLocationCoordinate2DIsValid(weakSelf.parentCoordinate) && CLLocationCoordinate2DIsValid(chapCoordinate)) {
                RQPointAnnotation *parentAnnotation = [[RQPointAnnotation alloc] initWithCoordinate:weakSelf.parentCoordinate index:0];
                
                [weakSelf.upView.mapView addAnnotation:parentAnnotation];
                CLLocationCoordinate2D center = CLLocationCoordinate2DMake((weakSelf.parentCoordinate.latitude + chapCoordinate.latitude) / 2, (weakSelf.parentCoordinate.longitude + chapCoordinate.longitude) / 2);
                MACoordinateSpan span = MACoordinateSpanMake(ABS(weakSelf.parentCoordinate.latitude - chapCoordinate.latitude) * 2, ABS(weakSelf.parentCoordinate.longitude - chapCoordinate.longitude) * 2);
                MACoordinateRegion region = MACoordinateRegionMake(center, span);
                [weakSelf.upView.mapView setRegion:region animated:YES];
            }
        }];
    }];
    
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)viewDidAppear:(BOOL)animated {
    MainViewController *vc = (MainViewController *)self.tabBarController;
    _parentNickname = vc.parentNickname;
    
    [_tableView.mj_header beginRefreshing];
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] getParentOrderWithNickname:weakSelf.parentNickname finished:^(id  _Nullable result, NSError * _Nullable error) {
        
        if (error) {
            [weakSelf.tableView.mj_header endRefreshing];
            NSLog(@"%@",error);
            
            weakSelf.noOrderLabel.hidden = NO;
            weakSelf.upView.hidden = YES;
            weakSelf.downView.hidden = YES;
            weakSelf.tableView.backgroundColor = [UIColor whiteColor];
            weakSelf.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            return;
        }
        
        NSLog(@"%@",result);
        
        NSInteger code = [result[@"code"] integerValue];
        if (code != 200) {
            [weakSelf.tableView.mj_header endRefreshing];
            [RQProgressHUD rq_showErrorWithStatus:result[@"msg"]];
            
            weakSelf.noOrderLabel.hidden = NO;
            weakSelf.upView.hidden = YES;
            weakSelf.downView.hidden = YES;
            weakSelf.tableView.backgroundColor = [UIColor whiteColor];
            weakSelf.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
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
            [weakSelf.tableView.mj_header endRefreshing];
            
            weakSelf.noOrderLabel.hidden = NO;
            weakSelf.upView.hidden = YES;
            weakSelf.downView.hidden = YES;
            weakSelf.tableView.backgroundColor = [UIColor whiteColor];
            weakSelf.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            return;
        }
        
        [[NetworkTool sharedTool] orderDetailWithOrderNo:orderNo finished:^(id  _Nullable result, NSError * _Nullable error) {
            [weakSelf.tableView.mj_header endRefreshing];
            
            if (error) {
                NSLog(@"%@",error);
                
                weakSelf.noOrderLabel.hidden = NO;
                weakSelf.upView.hidden = YES;
                weakSelf.downView.hidden = YES;
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
                weakSelf.tableView.backgroundColor = [UIColor whiteColor];
                weakSelf.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                
                return;
            }
            
            weakSelf.noOrderLabel.hidden = YES;
            weakSelf.upView.hidden = NO;
            weakSelf.downView.hidden = NO;
            weakSelf.tableView.backgroundColor = [UIColor colorWithRed:0.95 green:0.94 blue:0.95 alpha:1.00];
            weakSelf.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            
            NSDictionary *dataDic = result[@"data"];
            OrderDetailModel *model = [OrderDetailModel yy_modelWithDictionary:dataDic];
            weakSelf.model = model;
            
            NSString *orderStatusStr;
            if (model.orderStatus == 1) {
                orderStatusStr = @"陪护员已接单";
            }else {
                orderStatusStr = @"陪护中";
            }
            weakSelf.upView.orderStatusLabel.text = orderStatusStr;
            weakSelf.upView.chaperonageLabel.text = model.escortRealName;
            
            [weakSelf.upView.mapView removeAnnotations:weakSelf.upView.mapView.annotations];
            CLLocationCoordinate2D parentCoordinate = kCLLocationCoordinate2DInvalid;
            CLLocationCoordinate2D chapCoordinate = kCLLocationCoordinate2DInvalid;
            if ([model.position componentsSeparatedByString:@" "].count == 2) {
                parentCoordinate = CLLocationCoordinate2DMake([[model.position componentsSeparatedByString:@" "][0] doubleValue], [[model.position componentsSeparatedByString:@" "][1] doubleValue]);
                weakSelf.parentCoordinate = parentCoordinate;
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
    }];
}


- (void)didClickDetailButton {
    NSLog(@"查看详情");
    
    ChapDetailViewController *vc = [[ChapDetailViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.escortName = _model.escortName;
    [self.navigationController pushViewController:vc animated:YES];
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
        
        _upView = [[CurOrderUpView alloc] init];
        _upView.delegate = self;
        _upView.hidden = YES;
        [cell.contentView addSubview:_upView];
        
        [_upView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top);
            make.left.equalTo(cell.contentView.mas_left);
            make.right.equalTo(cell.contentView.mas_right);
            make.height.mas_equalTo(340.f);
            
            make.bottom.equalTo(cell.contentView.mas_bottom);
        }];
        
        return cell;
    }else {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _downView = [CurOrderDownView oldOrderDownView];
        _downView.hidden = YES;
        [cell.contentView addSubview:_downView];
        
        [_downView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top);
            make.left.equalTo(cell.contentView.mas_left);
            make.right.equalTo(cell.contentView.mas_right);
            make.height.mas_equalTo(264.f);
            
            make.bottom.equalTo(cell.contentView.mas_bottom);
        }];
        
        return cell;
    }
}

- (void)setupUI {
    // 创建控件
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 200;
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
    [_tableView addSubview:_noOrderLabel];
    
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
}

@end
