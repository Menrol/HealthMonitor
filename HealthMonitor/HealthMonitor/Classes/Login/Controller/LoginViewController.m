//
//  LoginViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/4.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "LoginViewController.h"
#import <Masonry/Masonry.h>

@interface LoginViewController ()
@property(strong,nonatomic) UITextField *accontTextField;
@property(strong,nonatomic) UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置界面
    [self setupUI];
}

- (void)clickLogin {
    NSLog(@"登录");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.accontTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (void)setupUI {
    // 创建控件
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.tintColor = [UIColor whiteColor];
    iconImageView.layer.cornerRadius = 5;
    iconImageView.layer.masksToBounds = YES;
    iconImageView.layer.borderWidth = 1;
    iconImageView.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:iconImageView];
    
    _accontTextField = [[UITextField alloc] init];
    _accontTextField.placeholder = @"  请输入账号";
    _accontTextField.layer.cornerRadius = 5;
    _accontTextField.layer.masksToBounds = YES;
    _accontTextField.layer.borderWidth = 1;
    _accontTextField.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:_accontTextField];
    
    _passwordTextField = [[UITextField alloc] init];
    _passwordTextField.placeholder = @"  请输入密码";
    _passwordTextField.layer.cornerRadius = 5;
    _passwordTextField.layer.masksToBounds = YES;
    _passwordTextField.layer.borderWidth = 1;
    _passwordTextField.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:_passwordTextField];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    loginButton.layer.borderWidth = 1;
    loginButton.layer.borderColor = [UIColor blackColor].CGColor;
    loginButton.layer.cornerRadius = 5;
    loginButton.layer.masksToBounds = YES;
    [loginButton addTarget:self action:@selector(clickLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    UIButton *forgetPasButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [forgetPasButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetPasButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    forgetPasButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [self.view addSubview:forgetPasButton];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [registerButton setTitle:@"新用户注册账号" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [self.view addSubview:registerButton];
    
    
    // 设置布局
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_top).offset(200.f);
        make.width.mas_equalTo(68.f);
        make.height.mas_equalTo(68.f);
    }];
    
    
    [_accontTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView.mas_bottom).offset(58.f);
        make.left.equalTo(self.view.mas_left).offset(30.f);
        make.right.equalTo(self.view.mas_right).offset(-30.f);
        make.height.mas_equalTo(48.f);
    }];
    
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accontTextField.mas_bottom).offset(15.f);
        make.left.equalTo(self.view.mas_left).offset(30.f);
        make.right.equalTo(self.view.mas_right).offset(-30.f);
        make.height.mas_equalTo(48.f);
    }];
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(30.f);
        make.left.equalTo(self.view.mas_left).offset(30.f);
        make.right.equalTo(self.view.mas_right).offset(-30.f);
        make.height.mas_equalTo(53.f);
    }];
    
    [forgetPasButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginButton.mas_bottom).offset(10.f);
        make.left.equalTo(loginButton.mas_left);
        make.height.mas_equalTo(30.f);
    }];
    
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginButton.mas_bottom).offset(10.f);
        make.right.equalTo(loginButton.mas_right);
        make.height.mas_equalTo(30.f);
    }];
}


@end
