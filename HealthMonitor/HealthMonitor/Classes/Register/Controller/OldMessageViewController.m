//
//  OldMessageViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/5.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "OldMessageViewController.h"
#import "OldBindingViewController.h"
#import <Masonry/Masonry.h>

@interface OldMessageViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    NSArray      *_dataArray;
}
@property(strong,nonatomic) UITextField    *nameTextField;
@property(strong,nonatomic) UITextField    *sexTextField;
@property(strong,nonatomic) UITextField    *birthdayTextField;
@property(strong,nonatomic) UITextField    *physicalTextField;
@property(strong,nonatomic) UITextField    *medicineTextField;
@property(strong,nonatomic) UIButton       *sexButton;
@property(strong,nonatomic) UITableView    *dropDownTableView;

@end

const CGFloat OldMessageBigFont = 25.f;
const CGFloat OldMessageTitleFont = 18.f;

@implementation OldMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = @[@"男",@"女"];
    
    [self setupUI];
    
}

- (void)clickNextButton {
    NSLog(@"下一步");
    OldBindingViewController *vc = [[OldBindingViewController alloc] init];
    [self presentViewController:vc animated:NO completion:nil];
}

- (void)clickShowDownButton {
    _dropDownTableView.hidden = !_dropDownTableView.hidden;
}

- (void)datePickerChange:(UIDatePicker *)datePicker {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM/dd/yyyy";
    NSString *dateString = [NSString stringWithFormat:@"  %@",[formatter stringFromDate:datePicker.date]];
    _birthdayTextField.text = dateString;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _dropDownTableView.hidden = YES;
    NSString *text = [NSString stringWithFormat:@"  %@",_dataArray[indexPath.row]];
    _sexTextField.text = text;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"dropDownTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = [UIColor blackColor].CGColor;
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    
    return cell;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    self.dropDownTableView.hidden = YES;
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
    [_sexButton addTarget:self action:@selector(clickShowDownButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sexButton];
    
    _dropDownTableView = [[UITableView alloc] init];
    _dropDownTableView.delegate = self;
    _dropDownTableView.dataSource = self;
    _dropDownTableView.hidden = YES;
    _dropDownTableView.layer.borderColor = [UIColor blackColor].CGColor;
    _dropDownTableView.layer.borderWidth = 1;
    _dropDownTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_dropDownTableView];
    
    UILabel *birthdayLabel = [[UILabel alloc] init];
    birthdayLabel.text = @"出生日期";
    birthdayLabel.font = [UIFont boldSystemFontOfSize:OldMessageTitleFont];
    [self.view addSubview:birthdayLabel];
    
    _birthdayTextField = [[UITextField alloc] init];
    _birthdayTextField.layer.borderColor = [UIColor blackColor].CGColor;
    _birthdayTextField.layer.borderWidth = 1;
    _birthdayTextField.text = @"  03/10/2014";
    [self.view addSubview:_birthdayTextField];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(datePickerChange:) forControlEvents:UIControlEventValueChanged];
    
    _birthdayTextField.inputView = datePicker;
    
    UILabel *physicalLabel = [[UILabel alloc] init];
    physicalLabel.text = @"身体状况";
    physicalLabel.font = [UIFont boldSystemFontOfSize:OldMessageTitleFont];
    [self.view addSubview:physicalLabel];
    
    _physicalTextField = [[UITextField alloc] init];
    _physicalTextField.placeholder = @"  请输入身体情况";
    _physicalTextField.layer.borderColor = [UIColor blackColor].CGColor;
    _physicalTextField.layer.borderWidth = 1;
    [self.view addSubview:_physicalTextField];
    
    UILabel *medicineLabel = [[UILabel alloc] init];
    medicineLabel.text = @"服药情况";
    medicineLabel.font = [UIFont boldSystemFontOfSize:OldMessageTitleFont];
    [self.view addSubview:medicineLabel];
    
    _medicineTextField = [[UITextField alloc] init];
    _medicineTextField.placeholder = @"  请输入服药情况";
    _medicineTextField.layer.borderColor = [UIColor blackColor].CGColor;
    _medicineTextField.layer.borderWidth = 1;
    [self.view addSubview:_medicineTextField];
    
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
    
    [self.view bringSubviewToFront:_dropDownTableView];
    
    // 设置布局
    [successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(80.f);
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
        make.height.mas_equalTo(40.f);
    }];
    
    [_sexButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sexTextField.mas_right);
        make.centerY.equalTo(sexLabel.mas_centerY);
        make.height.mas_equalTo(40.f);
    }];
    
    [_dropDownTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sexTextField.mas_bottom);
        make.left.equalTo(self.sexTextField.mas_left);
        make.right.equalTo(self.sexButton.mas_right);
        make.height.mas_equalTo(80.f);
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
    
    [_physicalTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(physicalLabel.mas_right).offset(10.f);
        make.centerY.equalTo(physicalLabel.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20.f);
        make.height.mas_equalTo(44.f);
    }];
    
    [medicineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.physicalTextField.mas_bottom).offset(30.f);
        make.left.equalTo(self.view.mas_left).offset(20.f);
        make.width.mas_equalTo(80.f);
        make.height.mas_equalTo(OldMessageTitleFont);
    }];
    
    [_medicineTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(medicineLabel.mas_right).offset(10.f);
        make.centerY.equalTo(medicineLabel.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20.f);
        make.height.mas_equalTo(44.f);
    }];
    
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.medicineTextField.mas_bottom).offset(30.f);
        make.left.equalTo(medicineLabel.mas_left);
        make.right.equalTo(self.medicineTextField.mas_right);
        make.height.mas_equalTo(53.f);
    }];
}

@end
