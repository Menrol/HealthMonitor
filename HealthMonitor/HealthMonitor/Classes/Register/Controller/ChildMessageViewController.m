//
//  ChildMessageViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/5/7.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "ChildMessageViewController.h"
#import "ChildrenBindingViewController.h"
#import "RQProgressHUD.h"
#import "NetworkTool.h"
#import <Masonry/Masonry.h>

extern CGFloat OldMessageTitleFont;
extern CGFloat ChaperonageTipFont;

@interface ChildMessageViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    NSArray            *_sexDataArray;
}
@property(strong,nonatomic) UITextField    *nameTextField;
@property(strong,nonatomic) UITextField    *sexTextField;
@property(strong,nonatomic) UIButton       *sexButton;
@property(strong,nonatomic) UITableView    *sexTableView;
@property(strong,nonatomic) UITextField    *ageTextField;

@end

@implementation ChildMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sexDataArray = @[@"男", @"女"];
    
    [self setupUI];
}

- (void)clickNextButton {
    NSLog(@"下一步");
    
    if (_nameTextField.text.length == 0) {
        [RQProgressHUD rq_showInfoWithStatus:@"姓名不能为空"];
        
        return;
    }
    
    if (_ageTextField.text.length == 0) {
        [RQProgressHUD rq_showInfoWithStatus:@"年龄不能为空"];
        
        return;
    }
    
    NSString *sexStr = [_sexTextField.text componentsSeparatedByString:@"  "][1];
    
    [RQProgressHUD show];
    __weak typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] childRegisterWithNickname:_nickname password:_password age:[_ageTextField.text integerValue] gender:sexStr name:_nameTextField.text finished:^(id  _Nullable result, NSError * _Nullable error) {
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
        
        __strong typeof(self) strongSelf = weakSelf;
        [[NetworkTool sharedTool] childMessageWithNickname:strongSelf->_nickname finished:^(id  _Nullable result, NSError * _Nullable error) {
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
            NSString *childCode = dataDic[@"childCode"];
            NSInteger userID = [dataDic[@"id"] integerValue];
            
            ChildrenBindingViewController *vc = [[ChildrenBindingViewController alloc] init];
            vc.childCode = childCode;
            vc.userID = userID;
            [strongSelf presentViewController:vc animated:NO completion:nil];
        }];
        
    }];
}

- (void)clickShowDownWithButton:(UIButton *)btn {
    _sexTableView.hidden = !_sexTableView.hidden;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = [NSString stringWithFormat:@"  %@",_sexDataArray[indexPath.row]];
    _sexTextField.text = text;
    _sexTableView.hidden = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sexDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"sexTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = [UIColor blackColor].CGColor;
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    cell.textLabel.text = _sexDataArray[indexPath.row];
    
    return cell;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _sexTableView.hidden = YES;
    [_nameTextField resignFirstResponder];
    [_ageTextField resignFirstResponder];
}

- (void)setupUI {
    // 创建控件
    UILabel *successLabel = [[UILabel alloc] init];
    successLabel.text = @"注册成功！";
    successLabel.font = [UIFont boldSystemFontOfSize:ChaperonageTipFont];
    [self.view addSubview:successLabel];
    
    UILabel *completeLabel = [[UILabel alloc] init];
    completeLabel.text = @"请完善您的信息";
    completeLabel.font = [UIFont boldSystemFontOfSize:ChaperonageTipFont];
    [self.view addSubview:completeLabel];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"姓名";
    nameLabel.font = [UIFont boldSystemFontOfSize:OldMessageTitleFont];
    [self.view addSubview:nameLabel];
    
    _nameTextField = [[UITextField alloc] init];
    _nameTextField.placeholder = @"请输入姓名";
    _nameTextField.layer.borderColor = [UIColor blackColor].CGColor;
    _nameTextField.layer.borderWidth = 1;
    _nameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    _nameTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_nameTextField];
    
    UILabel *sexLabel = [[UILabel alloc] init];
    sexLabel.text = @"性别";
    sexLabel.font = [UIFont boldSystemFontOfSize:OldMessageTitleFont];
    [self.view addSubview:sexLabel];
    
    _sexTextField = [[UITextField alloc] init];
    _sexTextField.text = @"  男";
    _sexTextField.layer.borderColor = [UIColor blackColor].CGColor;
    _sexTextField.layer.borderWidth = 1;
    _sexTextField.delegate = self;
    [self.view addSubview:_sexTextField];
    
    _sexButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sexButton.layer.borderColor = [UIColor blackColor].CGColor;
    _sexButton.layer.borderWidth = 1;
    [_sexButton setImage:[UIImage imageNamed:@"arrows_down"] forState:UIControlStateNormal];
    [_sexButton addTarget:self action:@selector(clickShowDownWithButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sexButton];
    
    _sexTableView = [[UITableView alloc] init];
    _sexTableView.delegate = self;
    _sexTableView.dataSource = self;
    _sexTableView.hidden = YES;
    _sexTableView.layer.borderColor = [UIColor blackColor].CGColor;
    _sexTableView.layer.borderWidth = 1;
    _sexTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_sexTableView];
    
    UILabel *ageLabel = [[UILabel alloc] init];
    ageLabel.text = @"年龄";
    ageLabel.font = [UIFont boldSystemFontOfSize:OldMessageTitleFont];
    [self.view addSubview:ageLabel];
    
    _ageTextField = [[UITextField alloc] init];
    _ageTextField.placeholder = @"  请输入年龄";
    _ageTextField.layer.borderColor = [UIColor blackColor].CGColor;
    _ageTextField.layer.borderWidth = 1;
    [self.view addSubview:_ageTextField];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    nextButton.layer.borderWidth = 1;
    nextButton.layer.borderColor = [UIColor blackColor].CGColor;
    nextButton.layer.cornerRadius = 5;
    nextButton.layer.masksToBounds = YES;
    [nextButton addTarget:self action:@selector(clickNextButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    [self.view bringSubviewToFront:_sexTableView];
    
    [successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(150.f);
        make.left.equalTo(self.view.mas_left).offset(14.f);
        make.height.mas_equalTo(ChaperonageTipFont);
    }];
    
    [completeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(successLabel.mas_bottom).offset(5.f);
        make.left.equalTo(self.view.mas_left).offset(15.f);
        make.height.mas_equalTo(ChaperonageTipFont);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(completeLabel.mas_bottom).offset(30.f);
        make.left.equalTo(self.view.mas_left).offset(20.f);
        make.width.mas_equalTo(40.f);
        make.height.mas_equalTo(OldMessageTitleFont);
    }];
    
    [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right).offset(10.f);
        make.centerY.equalTo(nameLabel.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20.f);
        make.height.mas_equalTo(44.f);
    }];
    
    [sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameTextField.mas_bottom).offset(20.f);
        make.left.equalTo(self.view.mas_left).offset(20.f);
        make.width.mas_equalTo(40.f);
        make.height.mas_equalTo(OldMessageTitleFont);
    }];
    
    [_sexTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sexLabel.mas_right).offset(10.f);
        make.centerY.equalTo(sexLabel.mas_centerY);
        make.width.mas_equalTo(60.f);
        make.height.mas_equalTo(40.f);
    }];
    
    [_sexButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sexTextField.mas_right);
        make.centerY.equalTo(sexLabel.mas_centerY);
        make.width.mas_equalTo(24.f);
        make.height.mas_equalTo(40.f);
    }];
    
    [_sexTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sexTextField.mas_bottom);
        make.left.equalTo(self.sexTextField.mas_left);
        make.right.equalTo(self.sexButton.mas_right);
        make.height.mas_equalTo(80.f);
    }];
    
    [ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sexLabel.mas_top);
        make.left.equalTo(self.sexButton.mas_right).offset(40.f);
        make.width.mas_equalTo(40.f);
        make.height.mas_equalTo(OldMessageTitleFont);
    }];
    
    [_ageTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ageLabel.mas_right).offset(10.f);
        make.centerY.equalTo(ageLabel.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20.f);
        make.height.mas_equalTo(44.f);
    }];
    
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ageTextField.mas_bottom).offset(30.f);
        make.left.equalTo(self.view.mas_left).offset(15.f);
        make.right.equalTo(self.view.mas_right).offset(-15.f);
        make.height.mas_equalTo(53.f);
    }];

}

@end
