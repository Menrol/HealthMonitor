//
//  ChildOrderListViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/18.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "ChildOrderListViewController.h"
#import "OrderListTableViewCell.h"
#import "ChildOrderDetailViewController.h"
#import "ChildSendOrderViewController.h"
#import "NetworkTool.h"
#import "RQProgressHUD.h"
#import "OrderModel.h"
#import "MainViewController.h"
#import <Masonry/Masonry.h>
#import <YYModel/YYModel.h>
#import <MJRefresh/MJRefresh.h>

NSString * const ChildOrderListTableViewCellID = @"ChildOrderListTableViewCellID";

@interface ChildOrderListViewController ()<UITableViewDelegate, UITableViewDataSource> {
    UIButton                       *_preButton;
    NSArray<OrderModel *>          *_dataArray;
}
@property(strong,nonatomic) UITableView       *tableView;
@property(strong,nonatomic) UILabel                          *noOrderLabel;
@property(strong,nonatomic) NSMutableArray<OrderModel *>     *orderList;
@property(strong,nonatomic) NSString                         *parentNickname;

@end

@implementation ChildOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _orderList = [[NSMutableArray alloc] init];
    
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated {
    MainViewController *vc = (MainViewController *)self.tabBarController;
    _parentNickname = vc.parentNickname;
    
    [_tableView.mj_header beginRefreshing];
}

- (void)LoadData {
    [_orderList removeAllObjects];
    
    __weak typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] getParentOrderWithNickname:_parentNickname finished:^(id  _Nullable result, NSError * _Nullable error) {
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
        
        __strong typeof(self) strongSelf = weakSelf;
        
        NSArray *dataArray = result[@"data"];
        
        if (dataArray.count == 0) {
            strongSelf.noOrderLabel.hidden = NO;
        }else {
            strongSelf.noOrderLabel.hidden = YES;
        }
        
        [strongSelf.orderList removeAllObjects];
        for (NSDictionary *dic in dataArray) {
            OrderModel *model = [OrderModel yy_modelWithDictionary:dic];
            [strongSelf.orderList addObject:model];
        }
        
        strongSelf->_dataArray = strongSelf.orderList;
        [strongSelf.tableView reloadData];
    }];
}

- (void)clickSendButton {
    NSLog(@"发布新单");
    
    ChildSendOrderViewController *vc = [[ChildSendOrderViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
        }else if (btn.tag == 101) {
            NSLog(@"已完成");
            
            for (OrderModel *model in _orderList) {
                if (model.orderStatus == 3) {
                    [array addObject:model];
                }
            }
        }else {
            NSLog(@"待接单");
            
            for (OrderModel *model in _orderList) {
                if (model.orderStatus == 0) {
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
    
    ChildOrderDetailViewController *vc = [[ChildOrderDetailViewController alloc] init];
    vc.orderNo = _dataArray[indexPath.row].orderNo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChildOrderListTableViewCellID forIndexPath:indexPath];
   
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
    
    UIButton *waitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [waitButton setTitle:@"待接单" forState:UIControlStateNormal];
    [waitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [waitButton setTitleColor:[UIColor colorWithRed:0.41 green:0.77 blue:0.84 alpha:1.00] forState:UIControlStateSelected];
    waitButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    waitButton.layer.borderWidth = 1;
    waitButton.layer.borderColor = [UIColor blackColor].CGColor;
    waitButton.layer.cornerRadius = 5;
    waitButton.layer.masksToBounds = YES;
    waitButton.tag = 102;
    [waitButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:waitButton];
    
    _tableView = [[UITableView alloc] init];
    [_tableView registerClass:[OrderListTableViewCell class] forCellReuseIdentifier:ChildOrderListTableViewCellID];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.layer.borderColor = [UIColor blackColor].CGColor;
    _tableView.layer.borderWidth = 0.5;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(LoadData)];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sendButton setTitle:@"发布新单" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    sendButton.layer.borderWidth = 0.5;
    sendButton.layer.borderColor = [UIColor blackColor].CGColor;
    [sendButton addTarget:self action:@selector(clickSendButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    
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
        make.left.equalTo(self.view.mas_left).offset(30.f);
        make.height.mas_equalTo(30.f);
        make.width.equalTo(completeButton.mas_width);
    }];
    
    [completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(underwayButton.mas_top);
        make.left.equalTo(underwayButton.mas_right).offset(15.f);
        make.height.equalTo(underwayButton.mas_height);
        make.width.equalTo(waitButton.mas_width);
    }];
    
    [waitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(completeButton.mas_top);
        make.left.equalTo(completeButton.mas_right).offset(15.f);
        make.height.equalTo(completeButton.mas_height);
        make.right.equalTo(self.view.mas_right).offset(-30.f);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(underwayButton.mas_bottom).offset(15.f);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(sendButton.mas_top);
    }];
    
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(45.f);
    }];
    
    [_noOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
        make.size.mas_equalTo(CGSizeMake(101.33f, 25.f));
    }];
}

@end
