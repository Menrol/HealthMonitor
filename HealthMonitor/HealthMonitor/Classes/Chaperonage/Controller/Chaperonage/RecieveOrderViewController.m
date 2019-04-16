//
//  RecieveOrderViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/16.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "RecieveOrderViewController.h"
#import "RecieveOrderTableViewCell.h"
#import "ChapOrDetailViewController.h"
#import <Masonry/Masonry.h>

NSString * const RecieveOrderTableViewCellID = @"RecieveOrderTableViewCellID";

@interface RecieveOrderViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(strong,nonatomic) UITableView    *tableView;

@end

@implementation RecieveOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ChapOrDetailViewController *vc = [[ChapOrDetailViewController alloc] init];
    vc.controllerType = 0;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // TODO: 测试数据
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecieveOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RecieveOrderTableViewCellID forIndexPath:indexPath];
    
    // TODO: 测试数据
    cell.orderNumLabel.text = @"PT190228184832015";
    cell.orderTypeLabel.text = @"待接单";
    cell.orderTypeLabel.textColor = [UIColor colorWithRed:0.95 green:0.68 blue:0.31 alpha:1.00];
    cell.beChapLabel.text = @"张三";
    cell.healthLabel.text = @"健康";
    cell.addressLabel.text = @"陕西省西安市碑林区长安立交4号2号楼3单元1201";
    cell.chapTimeLabel.text = @"19-03-15 8:00-17:00";
    
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
    
    // 设置布局
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

@end
