//
//  ChapOrderListViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/16.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "ChapOrderListViewController.h"
#import "OrderListTableViewCell.h"
#import "ChapOrDetailViewController.h"
#import "NetworkTool.h"
#import "RQProgressHUD.h"
#import "ChapModel.h"
#import "OrderModel.h"
#import "MainViewController.h"
#import <Masonry/Masonry.h>
#import <YYModel/YYModel.h>
#import <MJRefresh/MJRefresh.h>

NSString * const ChapOrderListTableViewCellId = @"ChapOrderListTableViewCellId";

@interface ChapOrderListViewController ()<UITableViewDelegate, UITableViewDataSource> {
    UIButton                       *_preButton;
    NSArray<OrderModel *>          *_dataArray;
}
@property(strong,nonatomic) UITableView                      *tableView;
@property(strong,nonatomic) UILabel                          *noOrderLabel;
@property(strong,nonatomic) NSMutableArray<OrderModel *>     *orderList;
@property(strong,nonatomic) ChapModel                        *model;

@end

@implementation ChapOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _orderList = [[NSMutableArray alloc] init];
    
    [self setupUI];
    
    MainViewController *vc = (MainViewController *)self.tabBarController;
    _model = vc.model;
    
    [_tableView.mj_header beginRefreshing];
}

- (void)loadData {
    _preButton.selected = NO;
    _preButton.layer.borderColor = [UIColor blackColor].CGColor;
    _preButton = nil;
    
    __weak typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] getOrderListWithFinished:^(id  _Nullable result, NSError * _Nullable error) {
        [weakSelf.tableView.mj_header endRefreshing];
        
        if (error) {
            NSLog(@"%@",error);
            
            return;
        }
        
        NSLog(@"%@",result);
        
        NSInteger code = [result[@"code"] integerValue];
        if (code != 0) {
            [RQProgressHUD rq_showErrorWithStatus:result[@"msg"]];
            
            return;
        }
        
        NSArray *dataArray = result[@"data"];
        
        [weakSelf.orderList removeAllObjects];
        for (NSDictionary *dic in dataArray) {
            NSString *escortName = dic[@"escortName"];
            
            if ((NSNull *)escortName == [NSNull null]) {
                continue;
            }
            
            if ([weakSelf.model.nickname isEqualToString:escortName]) {
                OrderModel *model = [OrderModel yy_modelWithDictionary:dic];
                [weakSelf.orderList addObject:model];
            }
        }
        
        if (weakSelf.orderList.count == 0) {
            weakSelf.noOrderLabel.hidden = NO;
        }else {
            weakSelf.noOrderLabel.hidden = YES;
        }
        
        __strong typeof(self) strongSelf = weakSelf;
        
        strongSelf->_dataArray = strongSelf.orderList;
        [strongSelf.tableView reloadData];
    }];
}

- (void)clickButton:(UIButton *)btn {
    
    if (_preButton != btn) {
        _preButton.selected = NO;
        _preButton.layer.borderColor = [UIColor blackColor].CGColor;
    }
    
    if (btn.selected) {
        btn.selected = NO;
        btn.layer.borderColor = [UIColor blackColor].CGColor;
        NSLog(@"显示全部订单");
        
        _dataArray = _orderList;
        [_tableView reloadData];
    }else {
        _preButton = btn;
        btn.selected = YES;
        btn.layer.borderColor = [UIColor colorWithRed:0.41 green:0.77 blue:0.84 alpha:1.00].CGColor;
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        if (btn.tag == 100) {
            NSLog(@"进行中");
            
            for (OrderModel *model in _orderList) {
                if (model.orderStatus == 1 || model.orderStatus == 2) {
                    [array addObject:model];
                }
            }
        }else {
            NSLog(@"已完成");
            
            for (OrderModel *model in _orderList) {
                if (model.orderStatus == 3) {
                    [array addObject:model];
                }
            }
        }
        
        _dataArray = array;
        [_tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ChapOrDetailViewController *vc = [[ChapOrDetailViewController alloc] init];
    vc.orderNo = _dataArray[indexPath.row].orderNo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChapOrderListTableViewCellId forIndexPath:indexPath];
    
    cell.model = _dataArray[indexPath.row];
    
    return cell;
}

- (void)setupUI {
    // 添加控件
    UIButton *underwayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [underwayButton setTitle:@"进行中" forState:UIControlStateNormal];
    [underwayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [underwayButton setTitleColor:[UIColor colorWithRed:0.41 green:0.77 blue:0.84 alpha:1.00] forState:UIControlStateSelected];
    underwayButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    underwayButton.layer.borderWidth = 1;
    underwayButton.layer.borderColor = [UIColor blackColor].CGColor;
    underwayButton.layer.cornerRadius = 5;
    underwayButton.layer.masksToBounds = YES;
    underwayButton.tag = 100;
    [underwayButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:underwayButton];
    
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [completeButton setTitle:@"已完成" forState:UIControlStateNormal];
    [completeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [completeButton setTitleColor:[UIColor colorWithRed:0.41 green:0.77 blue:0.84 alpha:1.00] forState:UIControlStateSelected];
    completeButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    completeButton.layer.borderWidth = 1;
    completeButton.layer.borderColor = [UIColor blackColor].CGColor;
    completeButton.layer.cornerRadius = 5;
    completeButton.layer.masksToBounds = YES;
    completeButton.tag = 101;
    [completeButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:completeButton];
    
    _tableView = [[UITableView alloc] init];
    [_tableView registerClass:[OrderListTableViewCell class] forCellReuseIdentifier:ChapOrderListTableViewCellId];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.layer.borderColor = [UIColor blackColor].CGColor;
    _tableView.layer.borderWidth = 0.5;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    _noOrderLabel = [[UILabel alloc] init];
    _noOrderLabel.text = @"暂无订单";
    _noOrderLabel.textAlignment = NSTextAlignmentCenter;
    _noOrderLabel.font = [UIFont boldSystemFontOfSize:25.f];
    _noOrderLabel.textColor = [UIColor grayColor];
    _noOrderLabel.hidden = YES;
    [self.tableView addSubview:_noOrderLabel];
    
    // 设置布局
    [underwayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(15.f);
        make.left.equalTo(self.view.mas_left).offset(80.f);
        make.height.mas_equalTo(30.f);
        make.width.equalTo(completeButton.mas_width);
    }];
    
    [completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(underwayButton.mas_top);
        make.left.equalTo(underwayButton.mas_right).offset(15.f);
        make.height.equalTo(underwayButton.mas_height);
        make.right.equalTo(self.view.mas_right).offset(-80.f);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(underwayButton.mas_bottom).offset(15.f);
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
