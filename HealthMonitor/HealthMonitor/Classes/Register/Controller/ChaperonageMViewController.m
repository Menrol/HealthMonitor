//
//  ChaperonageMViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/7.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "ChaperonageMViewController.h"
#import "LoginViewController.h"
#import <Masonry/Masonry.h>

extern CGFloat OldMessageTitleFont;
const CGFloat ChaperonageTipFont = 20.f;

@interface ChaperonageMViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    NSArray            *_sexDataArray;
    NSArray            *_workTypeArray;
}
@property(strong,nonatomic) UITextField    *nameTextField;
@property(strong,nonatomic) UITextField    *sexTextField;
@property(strong,nonatomic) UITextField    *ageTextField;
@property(strong,nonatomic) UITextField    *workTypeTextField;
@property(strong,nonatomic) UITextField    *workTimeTextField;
@property(strong,nonatomic) UITextField    *workExperienceTextField;
@property(strong,nonatomic) UIButton       *sexButton;
@property(strong,nonatomic) UITableView    *sexTableView;
@property(strong,nonatomic) UIButton       *workTypeButton;
@property(strong,nonatomic) UITableView    *workTypeTableView;

@end

@implementation ChaperonageMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sexDataArray = @[@"男", @"女"];
    _workTypeArray = @[@"全职", @"兼职"];
    
    [self setupUI];
}

- (void)clickSubmitButton {
    NSLog(@"提交信息");
    
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)clickShowDownWithButton:(UIButton *)btn {
    if (btn.tag == 1001) {
        _sexTableView.hidden = !_sexTableView.hidden;
    }else {
        _workTypeTableView.hidden = !_workTypeTableView.hidden;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 101) {
        NSString *text = [NSString stringWithFormat:@"  %@",_sexDataArray[indexPath.row]];
        _sexTextField.text = text;
        _sexTableView.hidden = YES;
    }else {
        NSString *text = [NSString stringWithFormat:@"  %@",_workTypeArray[indexPath.row]];
        _workTypeTextField.text = text;
        _workTypeTableView.hidden = YES;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 101) {
        return _sexDataArray.count;
    }else {
        return _workTypeArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier;
    if (tableView.tag == 101) {
        identifier = @"sexTableViewCell";
    }else {
        identifier = @"workTypeTableCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = [UIColor blackColor].CGColor;
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (tableView.tag == 101) {
        cell.textLabel.text = _sexDataArray[indexPath.row];
    }else {
        cell.textLabel.text = _workTypeArray[indexPath.row];
    }
    
    return cell;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _sexTableView.hidden = YES;
    _workTypeTableView.hidden = YES;
    [_nameTextField resignFirstResponder];
    [_workTimeTextField resignFirstResponder];
    [_ageTextField resignFirstResponder];
    [_workExperienceTextField resignFirstResponder];
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
    
    UILabel *otherLabel = [[UILabel alloc] init];
    otherLabel.text = @"管理员审核后您就可以开始接单啦！";
    otherLabel.font = [UIFont boldSystemFontOfSize:ChaperonageTipFont];
    [self.view addSubview:otherLabel];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"姓名";
    nameLabel.font = [UIFont boldSystemFontOfSize:OldMessageTitleFont];
    [self.view addSubview:nameLabel];
    
    _nameTextField = [[UITextField alloc] init];
    _nameTextField.placeholder = @"  请输入姓名";
    _nameTextField.layer.borderColor = [UIColor blackColor].CGColor;
    _nameTextField.layer.borderWidth = 1;
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
    _sexButton.tag = 1001;
    [self.view addSubview:_sexButton];
    
    _sexTableView = [[UITableView alloc] init];
    _sexTableView.delegate = self;
    _sexTableView.dataSource = self;
    _sexTableView.hidden = YES;
    _sexTableView.layer.borderColor = [UIColor blackColor].CGColor;
    _sexTableView.layer.borderWidth = 1;
    _sexTableView.backgroundColor = [UIColor whiteColor];
    _sexTableView.tag = 101;
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
    
    UILabel *workTypeLabel = [[UILabel alloc] init];
    workTypeLabel.text = @"工作类型";
    workTypeLabel.font = [UIFont boldSystemFontOfSize:OldMessageTitleFont];
    [self.view addSubview:workTypeLabel];
    
    _workTypeTextField = [[UITextField alloc] init];
    _workTypeTextField.text = @"  全职";
    _workTypeTextField.layer.borderColor = [UIColor blackColor].CGColor;
    _workTypeTextField.layer.borderWidth = 1;
    _workTypeTextField.delegate = self;
    [self.view addSubview:_workTypeTextField];
    
    _workTypeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _workTypeButton.layer.borderColor = [UIColor blackColor].CGColor;
    _workTypeButton.layer.borderWidth = 1;
    [_workTypeButton setImage:[UIImage imageNamed:@"arrows_down"] forState:UIControlStateNormal];
    [_workTypeButton addTarget:self action:@selector(clickShowDownWithButton:) forControlEvents:UIControlEventTouchUpInside];
    _workTypeButton.tag = 1002;
    [self.view addSubview:_workTypeButton];
    
    _workTypeTableView = [[UITableView alloc] init];
    _workTypeTableView.delegate = self;
    _workTypeTableView.dataSource = self;
    _workTypeTableView.hidden = YES;
    _workTypeTableView.layer.borderColor = [UIColor blackColor].CGColor;
    _workTypeTableView.layer.borderWidth = 1;
    _workTypeTableView.backgroundColor = [UIColor whiteColor];
    _workTypeTableView.tag = 102;
    [self.view addSubview:_workTypeTableView];
    
    UILabel *workTimeLabel = [[UILabel alloc] init];
    workTimeLabel.text = @"工作时间";
    workTimeLabel.font = [UIFont boldSystemFontOfSize:OldMessageTitleFont];
    [self.view addSubview:workTimeLabel];
    
    _workTimeTextField = [[UITextField alloc] init];
    _workTimeTextField.placeholder = @"  请输入可工作时间";
    _workTimeTextField.layer.borderColor = [UIColor blackColor].CGColor;
    _workTimeTextField.layer.borderWidth = 1;
    [self.view addSubview:_workTimeTextField];
    
    UILabel *workExperienceLabel = [[UILabel alloc] init];
    workExperienceLabel.text = @"工作经验";
    workExperienceLabel.font = [UIFont boldSystemFontOfSize:OldMessageTitleFont];
    [self.view addSubview:workExperienceLabel];
    
    _workExperienceTextField = [[UITextField alloc] init];
    _workExperienceTextField.placeholder = @"  请输入工作经验";
    _workExperienceTextField.layer.borderColor = [UIColor blackColor].CGColor;
    _workExperienceTextField.layer.borderWidth = 1;
    [self.view addSubview:_workExperienceTextField];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [submitButton setTitle:@"提交信息" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    submitButton.layer.borderWidth = 1;
    submitButton.layer.borderColor = [UIColor blackColor].CGColor;
    submitButton.layer.cornerRadius = 5;
    submitButton.layer.masksToBounds = YES;
    [submitButton addTarget:self action:@selector(clickSubmitButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    
    UILabel *affirmLabel = [[UILabel alloc] init];
    affirmLabel.text = @"*请确认您信息的真实性，将影响到您的审核";
    affirmLabel.font = [UIFont boldSystemFontOfSize:14.f];
    [self.view addSubview:affirmLabel];
    
    [self.view bringSubviewToFront:_workTypeTableView];
    [self.view bringSubviewToFront:_sexTableView];
    
    // 设置布局
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
    
    [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(completeLabel.mas_bottom).offset(5.f);
        make.left.equalTo(self.view.mas_left).offset(15.f);
        make.height.mas_equalTo(ChaperonageTipFont);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(otherLabel.mas_bottom).offset(30.f);
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
    
    [workTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ageTextField.mas_bottom).offset(20.f);
        make.left.equalTo(self.view.mas_left).offset(20.f);
        make.width.mas_equalTo(80.f);
        make.height.mas_equalTo(OldMessageTitleFont);
    }];
    
    [_workTypeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(workTypeLabel.mas_right).offset(10.f);
        make.centerY.equalTo(workTypeLabel.mas_centerY);
        make.right.equalTo(self.workTypeButton.mas_left);
        make.height.mas_equalTo(40.f);
    }];
    
    [_workTypeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(workTypeLabel.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20.f);
        make.width.mas_equalTo(24.f);
        make.height.mas_equalTo(40.f);
    }];
    
    [_workTypeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.workTypeTextField.mas_bottom);
        make.left.equalTo(self.workTypeTextField.mas_left);
        make.right.equalTo(self.workTypeButton.mas_right);
        make.height.mas_equalTo(80.f);
    }];
    
    [workTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.workTypeTextField.mas_bottom).offset(20.f);
        make.left.equalTo(self.view.mas_left).offset(20.f);
        make.width.mas_equalTo(80.f);
        make.height.mas_equalTo(OldMessageTitleFont);
    }];
    
    [_workTimeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(workTimeLabel.mas_right).offset(10.f);
        make.centerY.equalTo(workTimeLabel.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20.f);
        make.height.mas_equalTo(44.f);
    }];
    
    [workExperienceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.workTimeTextField.mas_bottom).offset(20.f);
        make.left.equalTo(self.view.mas_left).offset(20.f);
        make.width.mas_equalTo(80.f);
        make.height.mas_equalTo(OldMessageTitleFont);
    }];
    
    [_workExperienceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(workExperienceLabel.mas_right).offset(10.f);
        make.centerY.equalTo(workExperienceLabel.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20.f);
        make.height.mas_equalTo(44.f);
    }];
    
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.workExperienceTextField.mas_bottom).offset(15.f);
        make.left.equalTo(self.view.mas_left).offset(15.f);
        make.right.equalTo(self.view.mas_right).offset(-15.f);
        make.height.mas_equalTo(53.f);
    }];
    
    [affirmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(submitButton.mas_bottom).offset(15.f);
        make.left.equalTo(self.view.mas_left).offset(45.f);
        make.right.equalTo(self.view.mas_right).offset(-45.f);
        make.height.mas_equalTo(14.f);
    }];
}

@end
