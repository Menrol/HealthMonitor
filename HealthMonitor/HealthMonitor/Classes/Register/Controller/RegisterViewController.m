//
//  RegisterViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/5.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "RegisterViewController.h"
#import "OldMessageViewController.h"
#import "ChaperonageMViewController.h"
#import "ChildrenBindingViewController.h"
#import <Masonry/Masonry.h>

#define buttonWidth [UIScreen mainScreen].bounds.size.width / 3

@interface RegisterViewController () {
    NSInteger          _tag;
}
@property(strong,nonatomic) UITextField *accountTextField;
@property(strong,nonatomic) UITextField *passwordTextField;
@property(strong,nonatomic) UITextField *confirmTextField;
@property(strong,nonatomic) UIView      *lineView;
@property(strong,nonatomic) UIImageView *iconImageView;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tag = 0;
    
    [self setupUI];
}

- (void)clickWithButton:(UIButton *)btn {
    // 移动横线
    _tag = btn.tag - 100;
    CGFloat offsetX = (2 * _tag + 1) * 25 + _tag * (buttonWidth - 50);
    [UIView animateWithDuration:0.5 animations:^{
        self.lineView.frame = CGRectMake(offsetX, 74, buttonWidth - 50, 2);
    }];
    
    // 设置图标
    UIImage *image;
    switch (_tag) {
        case 0:
            image = [UIImage imageNamed:@"oldpeople"];
            break;
        case 1:
            image = [UIImage imageNamed:@"children"];
            break;
        case 2:
            image = [UIImage imageNamed:@"chaperonage"];
            break;
        default:
            break;
    }
    self.iconImageView.image = image;
}

- (void)clickRegister {
    NSLog(@"注册------%ld",(long)_tag);
        
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic addEntriesFromDictionary:@{@"nickname": _accountTextField.text, @"password": _passwordTextField.text}];
    
    if (_tag == 0) {
        OldMessageViewController *vc = [[OldMessageViewController alloc] init];
        vc.parameters = dic;
        [self presentViewController:vc animated:NO completion:nil];
    }else if (_tag == 1) {
        ChildrenBindingViewController *vc = [[ChildrenBindingViewController alloc] init];
        [self presentViewController:vc animated:NO completion:nil];
    }else {
        ChaperonageMViewController *vc = [[ChaperonageMViewController alloc] init];
        [self presentViewController:vc animated:NO completion:nil];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.accountTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.confirmTextField resignFirstResponder];
}

- (void)setupUI {
    // 创建控件
    UIButton *oldButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [oldButton setTitle:@"我是老年人" forState:UIControlStateNormal];
    [oldButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    oldButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    oldButton.tag = 100;
    [oldButton addTarget:self action:@selector(clickWithButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:oldButton];
    
    UIButton *childrenButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [childrenButton setTitle:@"我是子女" forState:UIControlStateNormal];
    [childrenButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    childrenButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    childrenButton.tag = 101;
    [childrenButton addTarget:self action:@selector(clickWithButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:childrenButton];
    
    UIButton *chaperonageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [chaperonageButton setTitle:@"我是陪护员" forState:UIControlStateNormal];
    [chaperonageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    chaperonageButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    chaperonageButton.tag = 102;
    [chaperonageButton addTarget:self action:@selector(clickWithButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chaperonageButton];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(25, 74, buttonWidth - 50, 2)];
    _lineView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_lineView];
    
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.image = [UIImage imageNamed:@"oldpeople"];
    [self.view addSubview:_iconImageView];
    
    _accountTextField = [[UITextField alloc] init];
    _accountTextField.placeholder = @"  请输入账号";
    _accountTextField.layer.cornerRadius = 5;
    _accountTextField.layer.masksToBounds = YES;
    _accountTextField.layer.borderWidth = 1;
    _accountTextField.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:_accountTextField];
    
    _passwordTextField = [[UITextField alloc] init];
    _passwordTextField.placeholder = @"  请输入密码";
    _passwordTextField.layer.cornerRadius = 5;
    _passwordTextField.layer.masksToBounds = YES;
    _passwordTextField.layer.borderWidth = 1;
    _passwordTextField.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:_passwordTextField];
    
    _confirmTextField = [[UITextField alloc] init];
    _confirmTextField.placeholder = @"  请确认密码";
    _confirmTextField.layer.cornerRadius = 5;
    _confirmTextField.layer.masksToBounds = YES;
    _confirmTextField.layer.borderWidth = 1;
    _confirmTextField.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:_confirmTextField];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    registerButton.layer.borderWidth = 1;
    registerButton.layer.borderColor = [UIColor blackColor].CGColor;
    registerButton.layer.cornerRadius = 5;
    registerButton.layer.masksToBounds = YES;
    [registerButton addTarget:self action:@selector(clickRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
    // 设置布局
    [oldButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top).offset(44.f);
        make.width.equalTo(childrenButton.mas_width);
        make.height.mas_equalTo(30.f);
    }];
    
    [childrenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oldButton.mas_right);
        make.top.equalTo(oldButton.mas_top);
        make.width.equalTo(chaperonageButton.mas_width);
        make.height.mas_equalTo(30.f);
    }];
    
    [chaperonageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(childrenButton.mas_right);
        make.top.equalTo(childrenButton.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(30.f);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_top).offset(200.f);
        make.width.mas_equalTo(78.f);
        make.height.mas_equalTo(78.f);
    }];
    
    [_accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(58.f);
        make.left.equalTo(self.view.mas_left).offset(30.f);
        make.right.equalTo(self.view.mas_right).offset(-30.f);
        make.height.mas_equalTo(48.f);
    }];
    
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountTextField.mas_bottom).offset(15.f);
        make.left.equalTo(self.view.mas_left).offset(30.f);
        make.right.equalTo(self.view.mas_right).offset(-30.f);
        make.height.mas_equalTo(48.f);
    }];
    
    [_confirmTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(15.f);
        make.left.equalTo(self.view.mas_left).offset(30.f);
        make.right.equalTo(self.view.mas_right).offset(-30.f);
        make.height.mas_equalTo(48.f);
    }];
    
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confirmTextField.mas_bottom).offset(30.f);
        make.left.equalTo(self.view.mas_left).offset(30.f);
        make.right.equalTo(self.view.mas_right).offset(-30.f);
        make.height.mas_equalTo(53.f);
    }];
}

@end
