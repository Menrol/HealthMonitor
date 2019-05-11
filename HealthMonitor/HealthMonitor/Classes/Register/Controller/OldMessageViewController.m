//
//  OldMessageViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/5.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "OldMessageViewController.h"
#import "OldBindingViewController.h"
#import "NetworkTool.h"
#import "RQProgressHUD.h"
#import <Masonry/Masonry.h>

@interface OldMessageViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    NSArray      *_sexArray;
    NSArray      *_healthArray;
    NSArray      *_medicineArray;
    NSInteger    _healthStatus;
    NSInteger    _medicine;
}
@property(strong,nonatomic) UITextField    *nameTextField;
@property(strong,nonatomic) UITextField    *sexTextField;
@property(strong,nonatomic) UIButton       *sexButton;
@property(strong,nonatomic) UITableView    *sexTableView;
@property(strong,nonatomic) UITextField    *birthdayTextField;
@property(strong,nonatomic) UITextField    *healthTextField;
@property(strong,nonatomic) UIButton       *healthButton;
@property(strong,nonatomic) UITableView    *healthTableView;
@property(strong,nonatomic) UITextField    *medicineTextField;
@property(strong,nonatomic) UIButton       *medicineButton;
@property(strong,nonatomic) UITableView    *medicineTableView;

@end

const CGFloat OldMessageBigFont = 25.f;
const CGFloat OldMessageTitleFont = 18.f;

@implementation OldMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sexArray = @[@"男",@"女"];
    _healthArray = @[@"健康", @"不健康"];
    _medicineArray = @[@"未知", @"无需服药", @"服药"];
    
    [self setupUI];
    
}

- (void)clickNextButton {
    NSLog(@"下一步");
    
    if (_nameTextField.text.length == 0) {
        [RQProgressHUD rq_showInfoWithStatus:@"姓名不能为空"];
        
        return;
    }
    
    NSString *sexStr = [_sexTextField.text componentsSeparatedByString:@"  "][1];
    NSString *birthdayStr = [_birthdayTextField.text componentsSeparatedByString:@"  "][1];
    
    [RQProgressHUD show];
    __weak typeof(self) weakSelf = self;
    [[NetworkTool sharedTool] parentRegisterWithNickname:_nickname password:_password birthday:birthdayStr gender:sexStr healthStatus:_healthStatus medicine:_medicine name:_nameTextField.text finished:^(id  _Nullable result, NSError * _Nullable error) {
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
        [[NetworkTool sharedTool] parentMessageWithNickname:strongSelf->_nickname finished:^(id  _Nullable result, NSError * _Nullable error) {
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
            NSString *parentCode = dataDic[@"parentCode"];
            NSInteger userID = [dataDic[@"id"] integerValue];
            
            OldBindingViewController *vc = [[OldBindingViewController alloc] init];
            vc.parentCode = parentCode;
            vc.userID = userID;
            [strongSelf presentViewController:vc animated:NO completion:nil];
        }];
    }];
}

- (void)clickShowDownWithButton:(UIButton *)btn {
    if (btn.tag == 1000) {
        _sexTableView.hidden = !_sexTableView.hidden;
    }else if (btn.tag == 1001) {
        _healthTableView.hidden = !_healthTableView.hidden;
    }else {
        _medicineTableView.hidden = !_medicineTableView.hidden;
    }
    
}

- (void)datePickerChange:(UIDatePicker *)datePicker {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [NSString stringWithFormat:@"  %@",[formatter stringFromDate:datePicker.date]];
    _birthdayTextField.text = dateString;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 100) {
        NSString *text = [NSString stringWithFormat:@"  %@",_sexArray[indexPath.row]];
        _sexTextField.text = text;
        _sexTableView.hidden = YES;
    }else if (tableView.tag == 101) {
        NSString *text = [NSString stringWithFormat:@"  %@",_healthArray[indexPath.row]];
        _healthTextField.text = text;
        _healthTableView.hidden = YES;
        _healthStatus = indexPath.row;
    }else {
        NSString *text = [NSString stringWithFormat:@"  %@",_medicineArray[indexPath.row]];
        _medicineTextField.text = text;
        _medicineTableView.hidden = YES;
        _medicine = indexPath.row;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 100) {
        return _sexArray.count;
    }else if (tableView.tag == 101) {
        return _healthArray.count;
    }else {
        return _medicineArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier;
    if (tableView.tag == 100) {
        identifier = @"sexTableViewCell";
    }else if (tableView.tag == 101) {
        identifier = @"healthTableViewCell";
    }else {
        identifier = @"medicineTableCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = [UIColor blackColor].CGColor;
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (tableView.tag == 100) {
        cell.textLabel.text = _sexArray[indexPath.row];
    }else if (tableView.tag == 101) {
        cell.textLabel.text = _healthArray[indexPath.row];
    }else {
        cell.textLabel.text = _medicineArray[indexPath.row];
    }
    
    return cell;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    self.sexTableView.hidden = YES;
    self.healthTableView.hidden = YES;
    self.medicineTableView.hidden = YES;
}

- (void)setupUI {
    // 创建控件
    UILabel *successLabel = [[UILabel alloc] init];
    successLabel.text = @"注册成功！";
    successLabel.font = [UIFont boldSystemFontOfSize:OldMessageBigFont];
    [self.view addSubview:successLabel];
    
    UILabel *completeLabel = [[UILabel alloc] init];
    completeLabel.text = @"请完善您的信息";
    completeLabel.font = [UIFont boldSystemFontOfSize:OldMessageBigFont];
    [self.view addSubview:completeLabel];
    
    UILabel *otherLabel = [[UILabel alloc] init];
    otherLabel.text = @"以便获取更精准的数据";
    otherLabel.font = [UIFont boldSystemFontOfSize:OldMessageBigFont];
    [self.view addSubview:otherLabel];
    
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
    _sexButton.tag = 1000;
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
    _sexTableView.tag = 100;
    [self.view addSubview:_sexTableView];
    
    UILabel *birthdayLabel = [[UILabel alloc] init];
    birthdayLabel.text = @"出生日期";
    birthdayLabel.font = [UIFont boldSystemFontOfSize:OldMessageTitleFont];
    [self.view addSubview:birthdayLabel];
    
    _birthdayTextField = [[UITextField alloc] init];
    _birthdayTextField.layer.borderColor = [UIColor blackColor].CGColor;
    _birthdayTextField.layer.borderWidth = 1;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    _birthdayTextField.text = [NSString stringWithFormat:@"  %@",dateStr];
    [self.view addSubview:_birthdayTextField];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(datePickerChange:) forControlEvents:UIControlEventValueChanged];
    datePicker.date = [NSDate date];
    
    _birthdayTextField.inputView = datePicker;
    
    UILabel *physicalLabel = [[UILabel alloc] init];
    physicalLabel.text = @"身体状况";
    physicalLabel.font = [UIFont boldSystemFontOfSize:OldMessageTitleFont];
    [self.view addSubview:physicalLabel];
    
    _healthTextField = [[UITextField alloc] init];
    _healthTextField.text = @"  健康";
    _healthTextField.layer.borderColor = [UIColor blackColor].CGColor;
    _healthTextField.layer.borderWidth = 1;
    _healthTextField.delegate = self;
    [self.view addSubview:_healthTextField];
    
    _healthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _healthButton.layer.borderColor = [UIColor blackColor].CGColor;
    _healthButton.layer.borderWidth = 1;
    [_healthButton setImage:[UIImage imageNamed:@"arrows_down"] forState:UIControlStateNormal];
    [_healthButton addTarget:self action:@selector(clickShowDownWithButton:) forControlEvents:UIControlEventTouchUpInside];
    _healthButton.tag = 1001;
    [self.view addSubview:_healthButton];
    
    _healthTableView = [[UITableView alloc] init];
    _healthTableView.delegate = self;
    _healthTableView.dataSource = self;
    _healthTableView.hidden = YES;
    _healthTableView.layer.borderColor = [UIColor blackColor].CGColor;
    _healthTableView.layer.borderWidth = 1;
    _healthTableView.backgroundColor = [UIColor whiteColor];
    _healthTableView.tag = 101;
    [self.view addSubview:_healthTableView];
    
    UILabel *medicineLabel = [[UILabel alloc] init];
    medicineLabel.text = @"服药情况";
    medicineLabel.font = [UIFont boldSystemFontOfSize:OldMessageTitleFont];
    [self.view addSubview:medicineLabel];
    
    _medicineTextField = [[UITextField alloc] init];
    _medicineTextField.text = @"  未知";
    _medicineTextField.layer.borderColor = [UIColor blackColor].CGColor;
    _medicineTextField.layer.borderWidth = 1;
    _medicineTextField.delegate = self;
    [self.view addSubview:_medicineTextField];
    
    _medicineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _medicineButton.layer.borderColor = [UIColor blackColor].CGColor;
    _medicineButton.layer.borderWidth = 1;
    [_medicineButton setImage:[UIImage imageNamed:@"arrows_down"] forState:UIControlStateNormal];
    [_medicineButton addTarget:self action:@selector(clickShowDownWithButton:) forControlEvents:UIControlEventTouchUpInside];
    _medicineButton.tag = 1002;
    [self.view addSubview:_medicineButton];
    
    _medicineTableView = [[UITableView alloc] init];
    _medicineTableView.delegate = self;
    _medicineTableView.dataSource = self;
    _medicineTableView.hidden = YES;
    _medicineTableView.layer.borderColor = [UIColor blackColor].CGColor;
    _medicineTableView.layer.borderWidth = 1;
    _medicineTableView.backgroundColor = [UIColor whiteColor];
    _medicineTableView.tag = 102;
    [self.view addSubview:_medicineTableView];
    
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
    [self.view bringSubviewToFront:_healthTableView];
    [self.view bringSubviewToFront:_medicineTableView];
    
    // 设置布局
    [successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(150.f);
        make.left.equalTo(self.view.mas_left).offset(15.f);
        make.height.mas_equalTo(OldMessageBigFont);
    }];
    
    [completeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(successLabel.mas_bottom).offset(5.f);
        make.left.equalTo(self.view.mas_left).offset(15.f);
        make.height.mas_equalTo(OldMessageBigFont);
    }];
    
    [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(completeLabel.mas_bottom).offset(5.f);
        make.left.equalTo(self.view.mas_left).offset(15.f);
        make.height.mas_equalTo(OldMessageBigFont);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(otherLabel.mas_bottom).offset(20.f);
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
        make.height.mas_equalTo(44.f);
    }];
    
    [_sexButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sexTextField.mas_right);
        make.centerY.equalTo(sexLabel.mas_centerY);
        make.height.mas_equalTo(44.f);
    }];
    
    [_sexTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sexTextField.mas_bottom);
        make.left.equalTo(self.sexTextField.mas_left);
        make.right.equalTo(self.sexButton.mas_right);
        make.height.mas_equalTo(self->_sexArray.count * 40.f);
    }];
    
    [birthdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sexTextField.mas_bottom).offset(30.f);
        make.left.equalTo(self.view.mas_left).offset(20.f);
        make.width.mas_equalTo(80.f);
        make.height.mas_equalTo(OldMessageTitleFont);
    }];
    
    [_birthdayTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(birthdayLabel.mas_right).offset(10.f);
        make.centerY.equalTo(birthdayLabel.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20.f);
        make.height.mas_equalTo(44.f);
    }];
    
    [physicalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.birthdayTextField.mas_bottom).offset(30.f);
        make.left.equalTo(self.view.mas_left).offset(20.f);
        make.width.mas_equalTo(80.f);
        make.height.mas_equalTo(OldMessageTitleFont);
    }];
    
    [_healthTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(physicalLabel.mas_right).offset(10.f);
        make.centerY.equalTo(physicalLabel.mas_centerY);
        make.right.equalTo(self.healthButton.mas_left);
        make.height.mas_equalTo(44.f);
    }];
    
    [_healthButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.healthTextField.mas_right);
        make.centerY.equalTo(physicalLabel.mas_centerY);
        make.width.mas_equalTo(24.f);
        make.height.mas_equalTo(44.f);
        
        make.right.equalTo(self.view.mas_right).offset(-20.f);
    }];
    
    [_healthTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.healthTextField.mas_bottom);
        make.left.equalTo(self.healthTextField.mas_left);
        make.right.equalTo(self.healthButton.mas_right);
        make.height.mas_equalTo(self->_healthArray.count * 40.f);
    }];
    
    [medicineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.healthTextField.mas_bottom).offset(30.f);
        make.left.equalTo(self.view.mas_left).offset(20.f);
        make.width.mas_equalTo(80.f);
        make.height.mas_equalTo(OldMessageTitleFont);
    }];
    
    [_medicineTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(medicineLabel.mas_right).offset(10.f);
        make.centerY.equalTo(medicineLabel.mas_centerY);
        make.right.equalTo(self.medicineButton.mas_left);
        make.height.mas_equalTo(44.f);
    }];
    
    [_medicineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.medicineTextField.mas_right);
        make.centerY.equalTo(medicineLabel.mas_centerY);
        make.width.mas_equalTo(24.f);
        make.height.mas_equalTo(44.f);
        
        make.right.equalTo(self.view.mas_right).offset(-20.f);
    }];
    
    [_medicineTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.medicineTextField.mas_bottom);
        make.left.equalTo(self.medicineTextField.mas_left);
        make.right.equalTo(self.medicineButton.mas_right);
        make.height.mas_equalTo(self->_medicineArray.count * 40.f);
    }];
    
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.medicineTextField.mas_bottom).offset(30.f);
        make.left.equalTo(medicineLabel.mas_left);
        make.right.equalTo(self.medicineTextField.mas_right);
        make.height.mas_equalTo(53.f);
    }];
}

@end
