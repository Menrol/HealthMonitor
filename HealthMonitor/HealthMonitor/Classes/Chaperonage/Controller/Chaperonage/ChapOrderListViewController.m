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
#import <Masonry/Masonry.h>

NSString * const ChapOrderListTableViewCellId = @"ChapOrderListTableViewCellId";

@interface ChapOrderListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(strong,nonatomic) UITableView       *tableView;

@end

@implementation ChapOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)clickButton:(UIButton *)btn {
    if (btn.tag == 100) {
        NSLog(@"进行中");
    }else {
        NSLog(@"已完成");
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ChapOrDetailViewController *vc = [[ChapOrDetailViewController alloc] init];
    vc.controllerType = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // TODO: 测试数据
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChapOrderListTableViewCellId forIndexPath:indexPath];
    // TODO: 测试数据
    if (indexPath.row == 0) {
        cell.orderNumLabel.text = @"PT190204110203001";
        cell.orderTypeLabel.text = @"进行中";
        cell.orderTypeLabel.textColor = [UIColor colorWithRed:0.21 green:0.44 blue:0.28 alpha:1.00];
        cell.beChapLabel.text = @"张三";
        cell.chaperonageLabel.text = @"王悦";
        cell.chapTimeLabel.text = @"19-02-04 8:00-17:00";
    }else {
        cell.orderNumLabel.text = @"JJ190122131503001";
        cell.orderTypeLabel.text = @"已完成";
        cell.orderTypeLabel.textColor = [UIColor colorWithRed:0.16 green:0.22 blue:0.96 alpha:1.00];
        cell.beChapLabel.text = @"张三";
        cell.chaperonageLabel.text = @"王悦";
        cell.chapTimeLabel.text = @"19-02-04 8:00-17:00";
    }
    
    
    return cell;
}

- (void)setupUI {
    // 添加控件
    UIButton *underwayButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [underwayButton setTitle:@"进行中" forState:UIControlStateNormal];
    [underwayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    underwayButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    underwayButton.layer.borderWidth = 1;
    underwayButton.layer.borderColor = [UIColor blackColor].CGColor;
    underwayButton.layer.cornerRadius = 5;
    underwayButton.layer.masksToBounds = YES;
    underwayButton.tag = 100;
    [underwayButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:underwayButton];
    
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [completeButton setTitle:@"已完成" forState:UIControlStateNormal];
    [completeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
}

@end
