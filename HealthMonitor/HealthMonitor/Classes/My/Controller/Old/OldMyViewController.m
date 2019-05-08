//
//  OldMyViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/8.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "OldMyViewController.h"
#import "MyTableViewCell.h"
#import "MessageView.h"
#import "ChangePopView.h"
#import "ParentModel.h"
#import "ChildModel.h"
#import "MainViewController.h"
#import "NetworkTool.h"
#import "RQProgressHUD.h"
#import <Masonry/Masonry.h>
#import <YYModel/YYModel.h>

NSString * const OldMyTableViewCellId = @"OldMyTableViewCellId";

@interface OldMyViewController ()<UITableViewDataSource, MyTableViewCellDelegate, ChangePopViewDelegate> {
    NSMutableArray<ChildModel *>          *_childList;
}
@property(strong,nonatomic) UIImageView      *iconImageView;
@property(strong,nonatomic) UILabel          *nameLabel;
@property(strong,nonatomic) MessageView      *sexView;
@property(strong,nonatomic) MessageView      *birthdayView;
@property(strong,nonatomic) MessageView      *physicalView;
@property(strong,nonatomic) MessageView      *medicineView;
@property(strong,nonatomic) UITableView      *bindingTableView;
@property(strong,nonatomic) ChangePopView    *popView;
@property(strong,nonatomic) ParentModel      *model;

@end

@implementation OldMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    MainViewController *vc = (MainViewController *)self.tabBarController;
    _model = (ParentModel *)vc.model;
    
    [self updateUI];
    
    _childList = [NSMutableArray arrayWithArray:_model.childList];
    [_bindingTableView reloadData];
}

- (void)clickExitButton {
    NSLog(@"退出登录");
    
    _popView = [ChangePopView changePopViewWithTip:@"确定要退出登录吗？" type:ChangePopViewTypeDefult text:nil];
    _popView.delegate = self;
    [_popView show];
}

- (void)clickEditButton:(UIButton *)btn {
    NSLog(@"编辑");
    
    NSString *tipString;
    NSString *text;
    ChangePopViewType type;
    
    switch (btn.tag) {
        case 100:
            tipString = @"请输入姓名";
            text = _nameLabel.text;
            type = ChangePopViewTypeName;
            break;
        case 101:
            tipString = @"请选择性别";
            text = _sexView.textLabel.text;
            type = ChangePopViewTypeSex;
            break;
        case 102:
            tipString = @"请选择出生日期";
            text = _birthdayView.textLabel.text;
            type = ChangePopViewTypeDate;
            break;
        case 103:
            tipString = @"请选择身体情况";
            text = _physicalView.textLabel.text;
            type = ChangePopViewTypeHealth;
            break;
        case 104:
            tipString = @"请选择服药情况";
            text = _medicineView.textLabel.text;
            type = ChangePopViewTypeMedicine;
            break;
        default:
            type = ChangePopViewTypeDefult;
            break;
    }
    
    _popView = [ChangePopView changePopViewWithTip:tipString type:type text:text];
    _popView.delegate = self;
    [_popView show];
}

- (void)changePopViewDidClickConfirmWithText:(NSString *)text type:(ChangePopViewType)type {
    NSLog(@"修改为%@",text);
    
    if (type == ChangePopViewTypeBinding) {
        [_popView dismiss];
        
        [RQProgressHUD show];
        
        [[NetworkTool sharedTool] parentChildBindingSaveWithChildCode:text userID:_model.userID parentCode:_model.parentCode status:1 finished:^(id  _Nullable result, NSError * _Nullable error) {
            if (error) {
                [RQProgressHUD dismiss];
                
                NSLog(@"%@",error);
                return;
            }
            
            NSLog(@"%@",result);
            
            NSInteger code = [result[@"code"] integerValue];
            if (code != 200) {
                [RQProgressHUD dismiss];
                [RQProgressHUD rq_showErrorWithStatus:result[@"msg"]];
                
                return;
            }
            
            __weak typeof(self) weakSelf = self;
            [[NetworkTool sharedTool] parentGetChildWithNickname:weakSelf.model.nickname finished:^(id  _Nullable result, NSError * _Nullable error) {
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
                
                __strong typeof(self) strongSelf = weakSelf;
                
                NSDictionary *dataDic = result[@"data"];
                ParentModel *model = [ParentModel yy_modelWithDictionary:dataDic];
                strongSelf->_childList = [NSMutableArray arrayWithArray:model.childList];
                
                [strongSelf.bindingTableView reloadData];
            }];
        }];
        
        
        return;
    }
    
    NSMutableDictionary *paramters = [[NSMutableDictionary alloc] initWithDictionary:@{@"id": @(_model.userID)}];
    
    switch (type) {
        case ChangePopViewTypeDefult: {
            [_popView dismiss];
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        case ChangePopViewTypeName:
            _model.name = text;
            [paramters addEntriesFromDictionary:@{@"name": _model.name}];
            break;
        case ChangePopViewTypeSex:
            _model.gender = text;
            [paramters addEntriesFromDictionary:@{@"gender": _model.gender}];
            break;
        case ChangePopViewTypeDate: {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd";
            NSCalendar *calender = [NSCalendar currentCalendar];
            NSDate *nowDate = [NSDate date];
            NSDate *startDate = [formatter dateFromString:text];
            NSDateComponents *compoents = [calender components:NSCalendarUnitYear fromDate:startDate toDate:nowDate options:0];
            NSInteger age = [compoents year];
            if ([compoents month] < 0 || ([compoents month] == 0 && [compoents day] < 0)) {
                age -= 1;
            }
            NSInteger birthday = [startDate timeIntervalSince1970] * 1000;
            _model.birthday = [NSString stringWithFormat:@"%ld",birthday];
            [paramters addEntriesFromDictionary:@{@"birthday": @(birthday),
                                                  @"age": @(age)
                                                  }];
            break;
        }
        case ChangePopViewTypeHealth:
            if ([text isEqualToString:@"健康"]) {
                _model.healthStatus = 0;
            }else {
                _model.healthStatus = 1;
            }
            [paramters addEntriesFromDictionary:@{@"healthStatus": @(_model.healthStatus)}];
            break;
        case ChangePopViewTypeMedicine:
            if ([text isEqualToString:@"未知"]) {
                _model.medicine = 0;
            }else if ([text isEqualToString:@"无需服药"]) {
                _model.medicine = 1;
            }else {
                _model.medicine = 2;
            }
            [paramters addEntriesFromDictionary:@{@"medicine": @(_model.medicine)}];
            break;
        default:
            break;
    }
    
    [RQProgressHUD rq_show];
    
    __weak typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] parentUpdateWithParamters:paramters finished:^(id  _Nullable result, NSError * _Nullable error) {
        [RQProgressHUD dismiss];
        [weakSelf.popView dismiss];
        
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
        
        [self updateUI];
        
    }];
    
    
}

- (void)clickDeleteButtonWithCell:(MyTableViewCell *)cell {
    NSLog(@"删除Cell");
}

- (void)clickAddButtonWithCell:(MyTableViewCell *)cell {
    NSLog(@"添加Cell");
    
    _popView = [ChangePopView changePopViewWithTip:@"请输入子女用户编码" type:ChangePopViewTypeBinding text:nil];
    _popView.delegate = self;
    [_popView show];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _childList.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OldMyTableViewCellId forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    if (indexPath.row == _childList.count) {
        cell.nameLabel.hidden = YES;
        cell.ageLabel.hidden = YES;
        cell.deleteButton.hidden = YES;
        cell.addButton.hidden = NO;
    }else {
        cell.nameLabel.hidden = NO;
        cell.ageLabel.hidden = NO;
        cell.deleteButton.hidden = NO;
        cell.addButton.hidden = YES;
        ChildModel *model = _childList[indexPath.row];
        cell.nameLabel.text = model.name;
        cell.ageLabel.text = [NSString stringWithFormat:@"%ld岁",model.age];
    }
    
    
    return cell;
}

- (void)updateUI {
    _nameLabel.text = _model.name;
    _sexView.textLabel.text = _model.gender;
    _birthdayView.textLabel.text = _model.birthday;
    NSString *healthStr;
    if (_model.healthStatus == 0) {
        healthStr = @"健康";
    }else {
        healthStr = @"不健康";
    }
    _physicalView.textLabel.text = healthStr;
    NSString *medicineStr;
    if (_model.medicine == 0) {
        medicineStr = @"未知";
    }else if (_model.medicine == 1) {
        medicineStr = @"无需服药";
    }else {
        medicineStr = @"服药";
    }
    _medicineView.textLabel.text = medicineStr;
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    _nameLabel.text = @"张三";
    [self.view addSubview:_nameLabel];
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setImage:[UIImage imageNamed:@"pen"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(clickEditButton:) forControlEvents:UIControlEventTouchUpInside];
    editButton.tag = 100;
    [self.view addSubview:editButton];
    
    _sexView = [MessageView messageView];
    _sexView.titleLabel.text = @"性别：";
    _sexView.layer.borderColor = [UIColor blackColor].CGColor;
    _sexView.layer.borderWidth = 0.5;
    [_sexView.editButton addTarget:self action:@selector(clickEditButton:) forControlEvents:UIControlEventTouchUpInside];
    _sexView.editButton.tag = 101;
    // TODO: 测试数据
    _sexView.textLabel.text = @"男";
    [self.view addSubview:_sexView];
    
    _birthdayView = [MessageView messageView];
    _birthdayView.titleLabel.text = @"出生日期：";
    _birthdayView.layer.borderColor = [UIColor blackColor].CGColor;
    _birthdayView.layer.borderWidth = 0.5;
    [_birthdayView.editButton addTarget:self action:@selector(clickEditButton:) forControlEvents:UIControlEventTouchUpInside];
    _birthdayView.editButton.tag = 102;
    // TODO: 测试数据
    _birthdayView.textLabel.text = @"2019-01-01";
    [self.view addSubview:_birthdayView];
    
    _physicalView = [MessageView messageView];
    _physicalView.titleLabel.text = @"身体情况：";
    _physicalView.layer.borderColor = [UIColor blackColor].CGColor;
    _physicalView.layer.borderWidth = 0.5;
    [_physicalView.editButton addTarget:self action:@selector(clickEditButton:) forControlEvents:UIControlEventTouchUpInside];
    _physicalView.editButton.tag = 103;
    // TODO: 测试数据
    _physicalView.textLabel.text = @"健康";
    [self.view addSubview:_physicalView];
    
    _medicineView = [MessageView messageView];
    _medicineView.titleLabel.text = @"服药情况：";
    _medicineView.layer.borderColor = [UIColor blackColor].CGColor;
    _medicineView.layer.borderWidth = 0.5;
    [_medicineView.editButton addTarget:self action:@selector(clickEditButton:) forControlEvents:UIControlEventTouchUpInside];
    _medicineView.editButton.tag = 104;
    // TODO: 测试数据
    _medicineView.textLabel.text = @"无需服药";
    [self.view addSubview:_medicineView];
    
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
    [_bindingTableView registerClass:[MyTableViewCell class] forCellReuseIdentifier:OldMyTableViewCellId];
    _bindingTableView.tableFooterView = [[UIView alloc] init];
    _bindingTableView.separatorColor = [UIColor blackColor];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWith - 30, 0.5)];
    lineView.backgroundColor = [UIColor blackColor];
    _bindingTableView.tableHeaderView = lineView;
    [bindingView addSubview:_bindingTableView];
    
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
    
    [_sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15.f);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(45.f);
    }];
    
    [_birthdayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sexView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(45.f);
    }];
    
    [_physicalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.birthdayView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(45.f);
    }];
    
    [_medicineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.physicalView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(45.f);
    }];
    
    [bindingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.medicineView.mas_bottom);
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
        make.top.equalTo(bindingView.mas_bottom).offset(15.f);
        make.left.equalTo(self.view.mas_left).offset(15.f);
        make.right.equalTo(self.view.mas_right).offset(-15.f);
        make.bottom.equalTo(self.view.mas_bottom).offset(-15.f - TabBarHeight);
    }];
}

@end
