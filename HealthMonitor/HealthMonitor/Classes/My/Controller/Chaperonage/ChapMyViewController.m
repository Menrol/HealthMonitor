//
//  ChapMyViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/15.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "ChapMyViewController.h"
#import "MessageView.h"
#import "ChapModel.h"
#import "MainViewController.h"
#import <Masonry/Masonry.h>

@interface ChapMyViewController ()
@property(strong,nonatomic) UIImageView      *iconImageView;
@property(strong,nonatomic) UILabel          *nameLabel;
@property(strong,nonatomic) MessageView      *sexView;
@property(strong,nonatomic) MessageView      *ageView;
@property(strong,nonatomic) MessageView      *workTypeView;
@property(strong,nonatomic) MessageView      *workTimeView;
@property(strong,nonatomic) MessageView      *intelligenceView;
@property(strong,nonatomic) ChapModel        *model;

@end

@implementation ChapMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    MainViewController *vc = (MainViewController *)self.tabBarController;
    _model = vc.model;
    
    _nameLabel.text = _model.name;
    _sexView.textLabel.text = _model.gender;
    _ageView.textLabel.text = [NSString stringWithFormat:@"%ld",_model.age];
    NSString *workTypeStr;
    if (_model.workType == 0) {
        workTypeStr = @"兼职";
    }else {
        workTypeStr = @"全职";
    }
    _workTimeView.textLabel.text = _model.workTime;
    
}

- (void)clickExitButton {
    NSLog(@"退出登录");
}

- (void)clickEditButton:(UIButton *)btn {
    NSLog(@"编辑");
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
    _nameLabel.text = @"王悦";
    [self.view addSubview:_nameLabel];
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setImage:[UIImage imageNamed:@"pen"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(clickEditButton:) forControlEvents:UIControlEventTouchUpInside];
    editButton.tag = 100;
    [self.view addSubview:editButton];
    
    UIView *downView = [[UIView alloc] init];
    downView.layer.borderColor = [UIColor blackColor].CGColor;
    downView.layer.borderWidth = 0.5;
    downView.userInteractionEnabled = YES;
    [self.view addSubview:downView];
    
    _sexView = [MessageView messageView];
    _sexView.titleLabel.text = @"性别：";
    _sexView.layer.borderColor = [UIColor blackColor].CGColor;
    _sexView.layer.borderWidth = 0.5;
    [_sexView.editButton addTarget:self action:@selector(clickEditButton:) forControlEvents:UIControlEventTouchUpInside];
    _sexView.editButton.tag = 101;
    // TODO: 测试数据
    _sexView.textLabel.text = @"女";
    [downView addSubview:_sexView];
    
    _ageView = [MessageView messageView];
    _ageView.titleLabel.text = @"年龄：";
    _ageView.layer.borderColor = [UIColor blackColor].CGColor;
    _ageView.layer.borderWidth = 0.5;
    [_ageView.editButton addTarget:self action:@selector(clickEditButton:) forControlEvents:UIControlEventTouchUpInside];
    _ageView.editButton.tag = 102;
    // TODO: 测试数据
    _ageView.textLabel.text = @"36";
    [downView addSubview:_ageView];
    
    _workTypeView = [MessageView messageView];
    _workTypeView.titleLabel.text = @"工作类型：";
    _workTypeView.layer.borderColor = [UIColor blackColor].CGColor;
    _workTypeView.layer.borderWidth = 0.5;
    [_workTypeView.editButton addTarget:self action:@selector(clickEditButton:) forControlEvents:UIControlEventTouchUpInside];
    _workTypeView.editButton.tag = 103;
    // TODO: 测试数据
    _workTypeView.textLabel.text = @"全职";
    [downView addSubview:_workTypeView];
    
    _workTimeView = [MessageView messageView];
    _workTimeView.titleLabel.text = @"工作时间：";
    _workTimeView.layer.borderColor = [UIColor blackColor].CGColor;
    _workTimeView.layer.borderWidth = 0.5;
    [_workTimeView.editButton addTarget:self action:@selector(clickEditButton:) forControlEvents:UIControlEventTouchUpInside];
    _workTimeView.editButton.tag = 104;
    // TODO: 测试数据
    _workTimeView.textLabel.text = @"任何时间全天";
    [downView addSubview:_workTimeView];
    
    _intelligenceView = [MessageView messageView];
    _intelligenceView.titleLabel.text = @"资质认证：";
    _intelligenceView.layer.borderColor = [UIColor blackColor].CGColor;
    _intelligenceView.layer.borderWidth = 0.5;
    _intelligenceView.editButton.hidden = YES;
    // TODO: 测试数据
    _intelligenceView.textLabel.text = @"已通过";
    [downView addSubview:_intelligenceView];
    
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
    
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15.f);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(400.f);
    }];
    
    [_sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(downView.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(45.f);
    }];

    [_ageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sexView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(45.f);
    }];

    [_workTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ageView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(45.f);
    }];

    [_workTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.workTypeView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(45.f);
    }];

    [_intelligenceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.workTypeView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(45.f);
    }];

    [exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(downView.mas_bottom).offset(15.f);
        make.left.equalTo(self.view.mas_left).offset(15.f);
        make.right.equalTo(self.view.mas_right).offset(-15.f);
        make.bottom.equalTo(self.view.mas_bottom).offset(-15.f - TabBarHeight);
    }];
}

@end
