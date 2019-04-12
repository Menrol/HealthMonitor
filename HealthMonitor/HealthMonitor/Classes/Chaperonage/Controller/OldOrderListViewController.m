//
//  OldOrderListViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/12.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "OldOrderListViewController.h"
#import "OldOrderListTableViewCell.h"
#import "OldOrderDetailViewController.h"
#import <Masonry/Masonry.h>

NSString * const OldOrderListTableViewCellID = @"OldOrderListTableViewCellID";

@interface OldOrderListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(strong,nonatomic) UITableView       *tableView;

@end

@implementation OldOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)clickSendButton {
    NSLog(@"发布新单");
}

- (void)clickButton:(UIButton *)btn {
    if (btn.tag == 100) {
        NSLog(@"进行中");
    }else if (btn.tag == 101) {
        NSLog(@"已完成");
    }else {
        NSLog(@"待接单");
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    OldOrderDetailViewController *vc = [[OldOrderDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // TODO: 测试数据
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OldOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OldOrderListTableViewCellID forIndexPath:indexPath];
    // TODO: 测试数据
    cell.orderNumLabel.text = @"PT190228184832015";
    cell.orderTypeLabel.text = @"待接单";
    cell.orderTypeLabel.textColor = [UIColor colorWithRed:0.95 green:0.68 blue:0.31 alpha:1.00];
    cell.beChapLabel.text = @"张三";
    cell.chaperonageLabel.text = @"王悦";
    cell.chapTimeLabel.text = @"19-03-15 8:00-17:00";
    
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
    
    UIButton *waitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [waitButton setTitle:@"待接单" forState:UIControlStateNormal];
    [waitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    waitButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    waitButton.layer.borderWidth = 1;
    waitButton.layer.borderColor = [UIColor blackColor].CGColor;
    waitButton.layer.cornerRadius = 5;
    waitButton.layer.masksToBounds = YES;
    waitButton.tag = 102;
    [waitButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:waitButton];
    
    _tableView = [[UITableView alloc] init];
    [_tableView registerClass:[OldOrderListTableViewCell class] forCellReuseIdentifier:OldOrderListTableViewCellID];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.layer.borderColor = [UIColor blackColor].CGColor;
    _tableView.layer.borderWidth = 0.5;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sendButton setTitle:@"发布新单" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    sendButton.layer.borderWidth = 0.5;
    sendButton.layer.borderColor = [UIColor blackColor].CGColor;
    [sendButton addTarget:self action:@selector(clickSendButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    
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
}

@end
