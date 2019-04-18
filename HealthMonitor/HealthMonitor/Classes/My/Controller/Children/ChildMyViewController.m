//
//  ChildMyViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/18.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "ChildMyViewController.h"
#import "MyTableViewCell.h"
#import <Masonry/Masonry.h>

NSString * const ChildMyTableViewCellId = @"ChildMyTableViewCellId";

@interface ChildMyViewController ()<UITableViewDataSource, MyTableViewCellDelegate>
@property(strong,nonatomic) UIImageView      *iconImageView;
@property(strong,nonatomic) UILabel          *nameLabel;
@property(strong,nonatomic) UITableView      *bindingTableView;

@end

@implementation ChildMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)clickEditButton {
    NSLog(@"编辑");
}

- (void)clickExitButton {
    NSLog(@"退出登录");
}

- (void)clickDeleteButtonWithCell:(MyTableViewCell *)cell {
    NSLog(@"删除Cell");
}

- (void)clickAddButtonWithCell:(MyTableViewCell *)cell {
    NSLog(@"添加Cell");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // TODO: 测试数据
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChildMyTableViewCellId forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    if (indexPath.row == 0) {
        cell.nameLabel.text = @"张明";
        cell.relationLabel.text = @"儿子";
    }else {
        cell.nameLabel.hidden = YES;
        cell.relationLabel.hidden = YES;
        cell.deleteButton.hidden = YES;
        cell.addButton.hidden = NO;
    }
    
    
    return cell;
}

- (void)setupUI {
    // 创建控件
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.layer.cornerRadius = 45.f;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.borderColor = [UIColor blackColor].CGColor;
    _iconImageView.layer.borderWidth = 1;
    [self.view addSubview:_iconImageView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont boldSystemFontOfSize:16.f];
    // TODO: 测试数据
    _nameLabel.text = @"张明";
    [self.view addSubview:_nameLabel];
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setImage:[UIImage imageNamed:@"pen"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(clickEditButton) forControlEvents:UIControlEventTouchUpInside];
    editButton.tag = 100;
    [self.view addSubview:editButton];
    
    UIView *bindingView = [[UIView alloc] init];
    bindingView.layer.borderWidth = 0.5;
    bindingView.layer.borderColor = [UIColor blackColor].CGColor;
    bindingView.userInteractionEnabled = YES;
    [self.view addSubview:bindingView];
    
    UILabel *childrenTitleLabel = [[UILabel alloc] init];
    childrenTitleLabel.text = @"子女绑定：";
    childrenTitleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [bindingView addSubview:childrenTitleLabel];
    
    _bindingTableView = [[UITableView alloc] init];
    _bindingTableView.dataSource = self;
    [_bindingTableView registerClass:[MyTableViewCell class] forCellReuseIdentifier:ChildMyTableViewCellId];
    _bindingTableView.tableFooterView = [[UIView alloc] init];
    _bindingTableView.separatorColor = [UIColor blackColor];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWith - 30, 0.5)];
    lineView.backgroundColor = [UIColor blackColor];
    _bindingTableView.tableHeaderView = lineView;
    [bindingView addSubview:_bindingTableView];
    
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [exitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    exitButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    exitButton.layer.borderWidth = 1;
    exitButton.layer.borderColor = [UIColor blackColor].CGColor;
    exitButton.layer.cornerRadius = 5;
    exitButton.layer.masksToBounds = YES;
    [exitButton addTarget:self action:@selector(clickExitButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitButton];
    
    // 设置布局
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(120.f);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(90.f);
        make.width.mas_equalTo(90.f);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(15.f);
        make.centerX.equalTo(self.iconImageView.mas_centerX);
        make.height.mas_equalTo(20.f);
    }];
    
    [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_top);
        make.left.equalTo(self.nameLabel.mas_right).offset(10.f);
        make.width.mas_equalTo(22.f);
        make.height.mas_equalTo(22.f);
    }];
    
    [bindingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15.f);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(225.f);
    }];
    
    [childrenTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bindingView.mas_top).offset(15.f);
        make.left.equalTo(bindingView.mas_left).offset(15.f);
        make.height.mas_equalTo(20.f);
    }];
    
    [_bindingTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(childrenTitleLabel.mas_bottom).offset(15.f);
        make.left.equalTo(bindingView.mas_left).offset(15.f);
        make.right.equalTo(bindingView.mas_right).offset(-15.f);
        make.bottom.equalTo(bindingView.mas_bottom);
    }];
    
    [exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15.f);
        make.right.equalTo(self.view.mas_right).offset(-15.f);
        make.bottom.equalTo(self.view.mas_bottom).offset(-15.f - TabBarHeight);
        make.height.mas_equalTo(40.f);
    }];
}

@end
