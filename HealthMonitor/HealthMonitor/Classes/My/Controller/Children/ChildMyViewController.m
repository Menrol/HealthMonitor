//
//  ChildMyViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/18.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "ChildMyViewController.h"
#import "MyTableViewCell.h"
#import "ChildModel.h"
#import "ParentModel.h"
#import "MainViewController.h"
#import "ChangePopView.h"
#import "RQProgressHUD.h"
#import "NetworkTool.h"
#import <Masonry/Masonry.h>
#import <YYModel/YYModel.h>

NSString * const ChildMyTableViewCellId = @"ChildMyTableViewCellId";

@interface ChildMyViewController ()<UITableViewDataSource, MyTableViewCellDelegate, ChangePopViewDelegate> {
    NSMutableArray<ParentModel *>          *_parentList;
}
@property(strong,nonatomic) UIImageView      *iconImageView;
@property(strong,nonatomic) UILabel          *nameLabel;
@property(strong,nonatomic) UITableView      *bindingTableView;
@property(strong,nonatomic) ChildModel       *model;
@property(strong,nonatomic) ChangePopView    *popView;

@end

@implementation ChildMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    MainViewController *vc = (MainViewController *)self.tabBarController;
    _model = vc.model;
    
    _nameLabel.text = _model.name;
    _parentList = [NSMutableArray arrayWithArray:_model.parentList];
    
    [_bindingTableView reloadData];
}

- (void)clickEditButton {
    NSLog(@"编辑");
    
    _popView = [ChangePopView changePopViewWithTip:@"请输入姓名" type:ChangePopViewTypeName text:_nameLabel.text];
    _popView.delegate = self;
    [_popView show];
}

- (void)clickExitButton {
    NSLog(@"退出登录");
    
    _popView = [ChangePopView changePopViewWithTip:@"确定要退出登录吗？" type:ChangePopViewTypeDefult text:nil];
    _popView.delegate = self;
    [_popView show];
}

- (void)clickDeleteButtonWithCell:(MyTableViewCell *)cell {
    NSLog(@"删除Cell");
    NSIndexPath *indexPath = [_bindingTableView indexPathForCell:cell];
    ParentModel *model = _parentList[indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] parentChildBindingDeleteWithUserID:model.userID finished:^(id  _Nullable result, NSError * _Nullable error) {
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
        
        [strongSelf->_parentList removeObject:model];
        [strongSelf.bindingTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)clickAddButtonWithCell:(MyTableViewCell *)cell {
    NSLog(@"添加Cell");
    
    _popView = [ChangePopView changePopViewWithTip:@"请输入老人用户编码" type:ChangePopViewTypeBinding text:nil];
    _popView.delegate = self;
    [_popView show];
}

- (void)changePopViewDidClickConfirmWithText:(NSString *)text type:(ChangePopViewType)type {
    NSLog(@"修改为%@",text);
    
    if (type == ChangePopViewTypeDefult) {
        [_popView dismiss];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    if (type == ChangePopViewTypeBinding) {
        [_popView dismiss];
        
        [RQProgressHUD show];
       
        [[NetworkTool sharedTool] parentChildBindingSaveWithChildCode:_model.childCode userID:_model.userID parentCode:text status:1 finished:^(id  _Nullable result, NSError * _Nullable error) {
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
            [[NetworkTool sharedTool] childGetParentWithNickname:weakSelf.model.nickname finished:^(id  _Nullable result, NSError * _Nullable error) {
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
                ChildModel *model = [ChildModel yy_modelWithDictionary:dataDic];
                strongSelf->_parentList = [NSMutableArray arrayWithArray:model.parentList];
                
                [strongSelf.bindingTableView reloadData];
            }];
        }];
        
        return;
    }
    
    _model.name = text;
    NSDictionary *paramters = @{@"id": @(_model.userID),
                                @"name": _model.name
                                };
    
    [RQProgressHUD rq_show];
    
    __weak typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] childUpdateWithParamters:paramters finished:^(id  _Nullable result, NSError * _Nullable error) {
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
        
        weakSelf.nameLabel.text = text;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _parentList.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChildMyTableViewCellId forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    if (indexPath.row == _parentList.count) {
        cell.nameLabel.hidden = YES;
        cell.ageLabel.hidden = YES;
        cell.deleteButton.hidden = YES;
        cell.addButton.hidden = NO;
    }else {
        cell.nameLabel.hidden = NO;
        cell.ageLabel.hidden = NO;
        cell.deleteButton.hidden = NO;
        cell.addButton.hidden = YES;
        ParentModel *model = _parentList[indexPath.row];
        cell.nameLabel.text = model.name;
        cell.ageLabel.text = [NSString stringWithFormat:@"%ld岁",model.age];
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
    childrenTitleLabel.text = @"老年人绑定：";
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
