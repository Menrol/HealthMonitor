//
//  RecieveOrderViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/16.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "RecieveOrderViewController.h"
#import "RecieveOrderTableViewCell.h"
#import "ReOrderDetailViewController.h"
#import "NetworkTool.h"
#import "RQProgressHUD.h"
#import "OrderModel.h"
#import "ChapModel.h"
#import "MainViewController.h"
#import <YYModel/YYModel.h>
#import <MJRefresh/MJRefresh.h>
#import <Masonry/Masonry.h>

NSString * const RecieveOrderTableViewCellID = @"RecieveOrderTableViewCellID";

@interface RecieveOrderViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(strong,nonatomic) UITableView                      *tableView;
@property(strong,nonatomic) ChapModel                        *model;
@property(strong,nonatomic) NSMutableArray<OrderModel *>     *orderList;

@end

@implementation RecieveOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _orderList = [[NSMutableArray alloc] init];
    
    [self setupUI];
    
    MainViewController *vc = (MainViewController *)self.tabBarController;
    _model = vc.model;
    
    [_tableView.mj_header beginRefreshing];
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] getReceivingOrderWithFinished:^(id  _Nullable result, NSError * _Nullable error) {
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
        
        NSArray *dataArray = result[@"data"];
        
        [weakSelf.orderList removeAllObjects];
        for (NSDictionary *dic in dataArray) {
            OrderModel *model = [OrderModel yy_modelWithDictionary:dic];
            [weakSelf.orderList addObject:model];
        }
        
        [weakSelf.tableView reloadData];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ReOrderDetailViewController *vc = [[ReOrderDetailViewController alloc] init];
    vc.orderNo = _orderList[indexPath.row].orderNo;
    vc.orderID = _orderList[indexPath.row].orderID;
    vc.nickname = _model.nickname;
    vc.chapID = _model.userID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _orderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecieveOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RecieveOrderTableViewCellID forIndexPath:indexPath];
    
    cell.model = _orderList[indexPath.row];
    
    return cell;
}

- (void)setupUI {
    // 创建控件
    _tableView = [[UITableView alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [_tableView registerClass:[RecieveOrderTableViewCell class] forCellReuseIdentifier:RecieveOrderTableViewCellID];
    [self.view addSubview:_tableView];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    // 设置布局
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

@end
