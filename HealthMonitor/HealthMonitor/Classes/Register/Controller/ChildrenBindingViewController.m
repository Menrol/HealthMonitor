//
//  ChildrenBindingViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/8.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "ChildrenBindingViewController.h"
#import "LoginViewController.h"
#import "RQProgressHUD.h"
#import "NetworkTool.h"
#import <Masonry/Masonry.h>

extern CGFloat OldMessageBigFont;
extern CGFloat OldMessageTitleFont;

@interface ChildrenBindingViewController ()
@property(strong,nonatomic) UITextField       *numberTextField;
@property(strong,nonatomic) UILabel           *numberLabel;

@end

@implementation ChildrenBindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    _numberLabel.text = _childCode;
}

- (void)clickSkipButton {
    NSLog(@"跳过绑定");
    
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)clickBindingButton {
    NSLog(@"绑定");
    
    [RQProgressHUD rq_show];
    [[NetworkTool sharedTool] parentChildBindingSaveWithChildCode:_childCode userID:_userID parentCode:_numberTextField.text status:1 finished:^(id  _Nullable result, NSError * _Nullable error) {
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
        
        __weak typeof(self) weakSelf = self;
        [RQProgressHUD rq_showSuccessWithStatus:@"绑定成功" completion:^{
            LoginViewController *vc = [[LoginViewController alloc] init];
            [weakSelf presentViewController:vc animated:YES completion:nil];
        }];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_numberTextField resignFirstResponder];
}

- (void)setupUI {
    // 创建界面
    UILabel *successLabel = [[UILabel alloc] init];
    successLabel.text = @"注册成功！";
    successLabel.font = [UIFont boldSystemFontOfSize:OldMessageBigFont];
    [self.view addSubview:successLabel];
    
    UILabel *bindingLabel = [[UILabel alloc] init];
    bindingLabel.text = @"请输入您老人的账号编码，以绑定老人账号。绑定后可实时查看老人的位置及健康数据。";
    bindingLabel.font = [UIFont boldSystemFontOfSize:OldMessageTitleFont];
    bindingLabel.numberOfLines = 0;
    [self.view addSubview:bindingLabel];
    
    _numberTextField = [[UITextField alloc] init];
    _numberTextField.placeholder = @"请输入老人编码";
    _numberTextField.layer.borderColor = [UIColor blackColor].CGColor;
    _numberTextField.layer.borderWidth = 1;
    _numberTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    _numberTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_numberTextField];
    
    UIButton *bindingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bindingButton setTitle:@"绑定" forState:UIControlStateNormal];
    [bindingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    bindingButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    bindingButton.layer.borderWidth = 1;
    bindingButton.layer.borderColor = [UIColor blackColor].CGColor;
    bindingButton.layer.cornerRadius = 5;
    bindingButton.layer.masksToBounds = YES;
    [bindingButton addTarget:self action:@selector(clickBindingButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bindingButton];
    
    UILabel *numberTitleLabel = [[UILabel alloc] init];
    numberTitleLabel.text = @"您的用户编码为：";
    numberTitleLabel.font = [UIFont boldSystemFontOfSize:OldMessageBigFont];
    [self.view addSubview:numberTitleLabel];
    
    _numberLabel = [[UILabel alloc] init];
    // TODO: 测试数据
    _numberLabel.text = @"Z100001";
    _numberLabel.font = [UIFont boldSystemFontOfSize:OldMessageBigFont];
    [self.view addSubview:_numberLabel];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"如您的老人还未注册账号，请老人注册账号后输入您的用户编码，即可绑定。";
    tipLabel.font = [UIFont boldSystemFontOfSize:OldMessageTitleFont];
    tipLabel.numberOfLines = 0;
    [self.view addSubview:tipLabel];
    
    UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [skipButton setTitle:@"跳过，之后再绑定" forState:UIControlStateNormal];
    [skipButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    skipButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    skipButton.layer.borderWidth = 1;
    skipButton.layer.borderColor = [UIColor blackColor].CGColor;
    skipButton.layer.cornerRadius = 5;
    skipButton.layer.masksToBounds = YES;
    [skipButton addTarget:self action:@selector(clickSkipButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:skipButton];
    
    // 设置布局
    [successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(150.f);
        make.left.equalTo(self.view.mas_left).offset(15.f);
        make.height.mas_equalTo(OldMessageBigFont);
    }];
    
    [bindingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(successLabel.mas_bottom).offset(25.f);
        make.left.equalTo(self.view.mas_left).offset(15.f);
        make.right.equalTo(self.view.mas_right).offset(-30.f);
    }];
    
    [_numberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bindingLabel.mas_bottom).offset(15.f);
        make.left.equalTo(self.view.mas_left).offset(15.f);
        make.right.equalTo(self.view.mas_right).offset(-15.f);
        make.height.mas_equalTo(48.f);
    }];
    
    [bindingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numberTextField.mas_bottom).offset(15.f);
        make.left.equalTo(self.view.mas_left).offset(15.f);
        make.right.equalTo(self.view.mas_right).offset(-15.f);
        make.height.mas_equalTo(53.f);
    }];
    
    [numberTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bindingButton.mas_bottom).offset(80.f);
        make.left.equalTo(self.view.mas_left).offset(15.f);
        make.height.mas_equalTo(OldMessageBigFont);
    }];
    
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bindingButton.mas_bottom).offset(80.f);
        make.left.equalTo(numberTitleLabel.mas_right);
        make.height.mas_equalTo(OldMessageBigFont);
    }];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numberLabel.mas_bottom).offset(25.f);
        make.left.equalTo(self.view.mas_left).offset(15.f);
        make.right.equalTo(self.view.mas_right).offset(-30.f);
    }];
    
    [skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLabel.mas_bottom).offset(15.f);
        make.left.equalTo(self.view.mas_left).offset(15.f);
        make.right.equalTo(self.view.mas_right).offset(-15.f);
        make.height.mas_equalTo(53.f);
    }];
}

@end
