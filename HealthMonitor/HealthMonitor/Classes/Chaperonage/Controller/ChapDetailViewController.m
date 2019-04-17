//
//  ChapDetailViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/17.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "ChapDetailViewController.h"
#import <Masonry/Masonry.h>

@interface ChapDetailViewController ()

@end

@implementation ChapDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)clickReturn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupUI {
    self.title = @"陪护员详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrows_left"] style:UIBarButtonItemStylePlain target:self action:@selector(clickReturn)];
    
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
    
    UIView *upView = [[UIView alloc] init];
    upView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    upView.layer.borderWidth = 0.5;
    [self.view addSubview:upView];
    
    _sexLabel = [[UILabel alloc] init];
    _sexLabel.font = [UIFont boldSystemFontOfSize:16.f];
    // TODO: 测试数据
    _sexLabel.text = @"女";
    _sexLabel.textAlignment = NSTextAlignmentCenter;
    [upView addSubview:_sexLabel];
    
    _ageLabel = [[UILabel alloc] init];
    _ageLabel.font = [UIFont boldSystemFontOfSize:16.f];
    // TODO: 测试数据
    _ageLabel.text = @"36岁";
    [upView addSubview:_ageLabel];
    
    _experienceLabel = [[UILabel alloc] init];
    _experienceLabel.font = [UIFont boldSystemFontOfSize:16.f];
    // TODO: 测试数据
    _experienceLabel.text = @"4年看护经验";
    [upView addSubview:_experienceLabel];
    
    UIView *middleView = [[UIView alloc] init];
    middleView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    middleView.layer.borderWidth = 0.5;
    [self.view addSubview:middleView];
    
    _chapTimeLabel = [[UILabel alloc] init];
    _chapTimeLabel.font = [UIFont boldSystemFontOfSize:16.f];
    _chapTimeLabel.textAlignment = NSTextAlignmentCenter;
    // TODO: 测试数据
    _chapTimeLabel.text = @"任意时间课全天陪护";
    [middleView addSubview:_chapTimeLabel];
    
    UIView *downView = [[UIView alloc] init];
    downView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    downView.layer.borderWidth = 0.5;
    [self.view addSubview:downView];
    
    _intelligenceLabel = [[UILabel alloc] init];
    _intelligenceLabel.font = [UIFont boldSystemFontOfSize:16.f];
    _intelligenceLabel.textAlignment = NSTextAlignmentCenter;
    // TODO: 测试数据
    _intelligenceLabel.text = @"已通过资质认证";
    [downView addSubview:_intelligenceLabel];
    
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
    
    [upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15.f);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(50.f);
    }];
    
    [_sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(upView.mas_top).offset(15.f);
        make.left.equalTo(upView.mas_left).offset(105.f);
        make.height.mas_equalTo(20.f);
        make.width.mas_equalTo(20.f);
    }];
    
    [_ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sexLabel.mas_top);
        make.left.equalTo(self.sexLabel.mas_right).offset(15.f);
        make.height.equalTo(self.sexLabel.mas_height);
        make.width.mas_equalTo(45.f);
    }];
    
    [_experienceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ageLabel.mas_top);
        make.left.equalTo(self.ageLabel.mas_right).offset(15.f);
        make.right.equalTo(upView.mas_right).offset(-15.f);
        make.height.equalTo(self.ageLabel.mas_height);
    }];
    
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(upView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(50.f);
    }];
    
    [_chapTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleView.mas_top).offset(15.f);
        make.left.equalTo(middleView.mas_left).offset(15.f);
        make.right.equalTo(middleView.mas_right).offset(15.f);
        make.height.mas_equalTo(20.f);
    }];
    
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(50.f);
    }];
    
    [_intelligenceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(downView.mas_top).offset(15.f);
        make.left.equalTo(downView.mas_left).offset(15.f);
        make.right.equalTo(downView.mas_right).offset(15.f);
        make.height.mas_equalTo(20.f);
    }];
}

@end
