//
//  LoginViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/4.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "LoginViewController.h"
#import <Masonry/Masonry.h>
#import "RegisterViewController.h"
#import "MainViewController.h"
#import "NetworkTool.h"
#import "ParentModel.h"
#import "ChildModel.h"
#import "ChapModel.h"
#import "RQProgressHUD.h"
#import <YYModel/YYModel.h>

#define buttonWidth [UIScreen mainScreen].bounds.size.width / 3

@interface LoginViewController () {
    NSInteger         _tag;
}
@property(strong,nonatomic) UIView      *lineView;
@property(strong,nonatomic) UIImageView *iconImageView;
@property(strong,nonatomic) UITextField *accountTextField;
@property(strong,nonatomic) UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置界面
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    _accountTextField.text = @"";
    _passwordTextField.text = @"";
}

- (void)clickLogin {
    NSLog(@"登录");
    
    [self.accountTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    if (_accountTextField.text.length == 0 || _passwordTextField.text.length == 0) {
        [RQProgressHUD rq_showInfoWithStatus:@"用户名或密码不能为空"];
        
        return;
    }
    
    [RQProgressHUD rq_show];
    
    if (_tag == 0) {
        [[NetworkTool sharedTool] parentLoginWithNickname:_accountTextField.text password:_passwordTextField.text finished:^(id  _Nullable result, NSError * _Nullable error) {
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
            
            NSDictionary *dataDic = result[@"data"];
            __block ParentModel *model = [ParentModel yy_modelWithDictionary:dataDic];
            
            __weak typeof(self) weakSelf = self;
            [[NetworkTool sharedTool] parentGetChildWithNickname:weakSelf.accountTextField.text finished:^(id  _Nullable result, NSError * _Nullable error) {
                
                
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
                if (dataDic != nil) {
                    model = [ParentModel yy_modelWithDictionary:dataDic];
                }
                
                MainViewController *vc = [[MainViewController alloc] init];
                vc.userType = strongSelf->_tag;
                vc.model = model;
                [strongSelf presentViewController:vc animated:YES completion:nil];
            }];
        }];
    }else if (_tag == 1) {
        [[NetworkTool sharedTool] childLoginWithNickname:_accountTextField.text password:_passwordTextField.text finished:^(id  _Nullable result, NSError * _Nullable error) {
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
            
            NSDictionary *dataDic = result[@"data"];
            __block ChildModel *model = [ChildModel yy_modelWithDictionary:dataDic];
            
            __weak typeof(self) weakSelf = self;
            [[NetworkTool sharedTool] childGetParentWithNickname:weakSelf.accountTextField.text finished:^(id  _Nullable result, NSError * _Nullable error) {
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
                
                NSDictionary *dataDic = result[@"data"];
                if (dataDic != nil) {
                    model = [ChildModel yy_modelWithDictionary:dataDic];
                }
                
                __strong typeof(self) strongSelf = weakSelf;
                
                MainViewController *vc = [[MainViewController alloc] init];
                vc.userType = strongSelf->_tag;
                vc.model = model;
                [strongSelf presentViewController:vc animated:YES completion:nil];
            }];
        }];
    }else {
        __weak typeof(self) weakSelf = self;
        [[NetworkTool sharedTool] chapLoginWithNickname:_accountTextField.text password:_passwordTextField.text finished:^(id  _Nullable result, NSError * _Nullable error) {
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
            
            NSDictionary *dataDic = result[@"data"];
            ChapModel *model = [ChapModel yy_modelWithDictionary:dataDic];
            
            __strong typeof(self) strongSelf = weakSelf;
            
            MainViewController *vc = [[MainViewController alloc] init];
            vc.userType = strongSelf->_tag;
            vc.model = model;
            [strongSelf presentViewController:vc animated:YES completion:nil];
        }];
    }
}

- (void)clickRegister {
    NSLog(@"注册");
    RegisterViewController *vc = [[RegisterViewController alloc] init];
    [self presentViewController:vc animated:NO completion:nil];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.accountTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    _iconImageView.tintColor = [UIColor whiteColor];
    _iconImageView.layer.cornerRadius = 10;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.borderWidth = 1;
    _iconImageView.layer.borderColor = [UIColor blackColor].CGColor;
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
    _passwordTextField.secureTextEntry = YES;
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
        make.width.mas_equalTo(64.f);
        make.height.mas_equalTo(64.f);
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
