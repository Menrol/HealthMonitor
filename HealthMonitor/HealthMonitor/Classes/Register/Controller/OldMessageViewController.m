//
//  OldMessageViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/5.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "OldMessageViewController.h"
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

const CGFloat BigFont = 25.f;
const CGFloat TitleFont = 18.f;

@implementation OldMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = @[@"男",@"女"];
    
    [self setupUI];
    
}

- (void)clickShowDownButton {
    NSLog(@"选择性别");
    _dropDownTableView.hidden = !_dropDownTableView.hidden;
    
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

- (void)setupUI {
    // 创建控件
    UILabel *successLabel = [[UILabel alloc] init];
    successLabel.text = @"注册成功！";
    successLabel.font = [UIFont boldSystemFontOfSize:BigFont];
    [self.view addSubview:successLabel];
    
    UILabel *completeLabel = [[UILabel alloc] init];
    completeLabel.text = @"请完善您的信息";
    completeLabel.font = [UIFont boldSystemFontOfSize:BigFont];
    [self.view addSubview:completeLabel];
    
    UILabel *otherLabel = [[UILabel alloc] init];
    otherLabel.text = @"以便获取更精准的数据";
    otherLabel.font = [UIFont boldSystemFontOfSize:BigFont];
    [self.view addSubview:otherLabel];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"姓名";
    nameLabel.font = [UIFont boldSystemFontOfSize:TitleFont];
    [self.view addSubview:nameLabel];
    
    _nameTextField = [[UITextField alloc] init];
    _nameTextField.placeholder = @"  请输入姓名";
    _nameTextField.layer.borderColor = [UIColor blackColor].CGColor;
    _nameTextField.layer.borderWidth = 1;
    [self.view addSubview:_nameTextField];
    
    UILabel *sexLabel = [[UILabel alloc] init];
    sexLabel.text = @"性别";
    sexLabel.font = [UIFont boldSystemFontOfSize:TitleFont];
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
    birthdayLabel.font = [UIFont boldSystemFontOfSize:TitleFont];
    [self.view addSubview:birthdayLabel];
    
    [self.view bringSubviewToFront:_dropDownTableView];
    
    // 设置布局
    [successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(80.f);
        make.left.equalTo(self.view.mas_left).offset(15.f);
        make.height.mas_equalTo(BigFont);
    }];
    
    [completeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(successLabel.mas_bottom).offset(5.f);
        make.left.equalTo(self.view.mas_left).offset(15.f);
        make.height.mas_equalTo(BigFont);
    }];
    
    [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(completeLabel.mas_bottom).offset(5.f);
        make.left.equalTo(self.view.mas_left).offset(15.f);
        make.height.mas_equalTo(BigFont);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(otherLabel.mas_bottom).offset(20.f);
        make.left.equalTo(self.view.mas_left).offset(20.f);
        make.width.mas_equalTo(40.f);
        make.height.mas_equalTo(TitleFont);
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
        make.height.mas_equalTo(TitleFont);
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
        make.top.equalTo(self.sexTextField.mas_bottom).offset(20.f);
        make.left.equalTo(self.view.mas_left).offset(20.f);
        make.width.mas_equalTo(80.f);
        make.height.mas_equalTo(TitleFont);
    }];
}

@end
