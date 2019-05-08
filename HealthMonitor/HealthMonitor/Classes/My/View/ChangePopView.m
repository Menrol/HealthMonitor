//
//  ChangePopView.m
//  HealthMonitor
//
//  Created by WRQ on 2019/5/5.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "ChangePopView.h"

@interface ChangePopView()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    NSArray            *_dataArray;
    ChangePopViewType  _type;
    NSString           *_originalText;
}
@property(strong,nonatomic) UITextField     *changeTextField;
@property(strong,nonatomic) UIView          *maskView;
@property(strong,nonatomic) UITableView     *tableView;

@end

@implementation ChangePopView

+ (instancetype)changePopViewWithTip:(NSString *)tip type:(ChangePopViewType)type text:(NSString *)text {
    return [[self alloc] initWithTip:tip type:type text:text];
}

- (instancetype)initWithTip:(NSString *)tip type:(ChangePopViewType)type text:(NSString *)text{
    self = [super initWithFrame:CGRectMake((MainScreenWith - 300) / 2, (MainScreenHeight - 150) / 2, 300, 150)];
    
    if (self) {
        _type = type;
        _originalText = text;
        
        [self setupUIWithTip:tip text:text];
        
        if (type == ChangePopViewTypeDefult) {
            _changeTextField.hidden = YES;
            return  self;
        }
        
        if (type == ChangePopViewTypeName || type == ChangePopViewTypeBinding) {
            return self;
        }
        
        if (type == ChangePopViewTypeDate) {
            UIDatePicker *datePicker = [[UIDatePicker alloc] init];
            datePicker.datePickerMode = UIDatePickerModeDate;
            [datePicker addTarget:self action:@selector(datePickerChange:) forControlEvents:UIControlEventValueChanged];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd";
            
            if (_changeTextField.text.length > 0) {
                NSDate *date = [formatter dateFromString:_changeTextField.text];
                datePicker.date = date;
            }else {
                _changeTextField.text = [formatter stringFromDate:[NSDate date]];
            }
            
            _changeTextField.inputView = datePicker;
            
            return self;
        }
        
        _changeTextField.delegate = self;
        _changeTextField.rightViewMode = UITextFieldViewModeAlways;
        
        CGRect frame = [self convertRect:_changeTextField.frame toView:[UIApplication sharedApplication].keyWindow];
        
        if (type == ChangePopViewTypeHealth) {
            _dataArray = @[@"健康", @"不健康"];
            
            _tableView.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMaxY(frame), CGRectGetWidth(frame), _dataArray.count * 40);
        }
        
        if (type == ChangePopViewTypeMedicine) {
            _dataArray = @[@"未知", @"无需服药", @"服药"];
            
            _tableView.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMaxY(frame), CGRectGetWidth(frame), _dataArray.count * 40);
        }
        
        if (type == ChangePopViewTypeSex) {
            _dataArray = @[@"男", @"女"];
            
            _tableView.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMaxY(frame), CGRectGetWidth(frame), _dataArray.count * 40);
        }
    }
    
    return self;
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:_maskView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_tableView];
    
    self.alpha = 0.f;
    self.transform = CGAffineTransformMakeScale(0, 0);
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.f;
        self.transform = CGAffineTransformIdentity;
    }];
}

- (void)dismiss {
    [_changeTextField resignFirstResponder];
    [_maskView removeFromSuperview];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.f;
        self.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)clickShowDownButton {
    NSLog(@"下拉菜单");
    
    _tableView.hidden = !_tableView.hidden;
    
}

- (void)clickConfirm {
    NSLog(@"确定");
    
    if (([_originalText isEqualToString:_changeTextField.text] || _changeTextField.text.length == 0) && _type != ChangePopViewTypeDefult) {
        [self dismiss];
        return;
    }
    
    [_delegate changePopViewDidClickConfirmWithText:_changeTextField.text type:_type];
}

- (void)clickCancel {
    NSLog(@"取消");
    
    [self dismiss];
}

- (void)datePickerChange:(UIDatePicker *)datePicker {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:datePicker.date];
    _changeTextField.text = dateString;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _tableView.hidden = YES;
    _changeTextField.text = _dataArray[indexPath.row];
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
        cell.layer.borderColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1.00].CGColor;
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    
    return cell;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

- (void)setupUIWithTip:(NSString *)tip text:(NSString *)text {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 10.f;
    self.layer.masksToBounds = YES;
    
    _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _maskView.backgroundColor = [UIColor grayColor];
    _maskView.alpha = 0.5;
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 300 - 30, 20)];
    tipLabel.text = tip;
    tipLabel.font = [UIFont systemFontOfSize:20.f];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:tipLabel];
    
    _changeTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(tipLabel.frame) + 15, 300 - 30, 35)];
    _changeTextField.layer.borderWidth = 0.5;
    _changeTextField.layer.borderColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1.00].CGColor;
    _changeTextField.textAlignment = NSTextAlignmentCenter;
    _changeTextField.text = text;
    [self addSubview:_changeTextField];
    
    UIButton *pullButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pullButton.frame = CGRectMake(0, 0, 35, 35);
    pullButton.layer.borderColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1.00].CGColor;
    pullButton.layer.borderWidth = 0.5;
    [pullButton setImage:[UIImage imageNamed:@"arrows_down"] forState:UIControlStateNormal];
    [pullButton addTarget:self action:@selector(clickShowDownButton) forControlEvents:UIControlEventTouchUpInside];
    _changeTextField.rightView = pullButton;
    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.hidden = YES;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = [[UIView alloc] init];
    [[UIApplication sharedApplication].keyWindow addSubview:_tableView];
    
    UIView *upLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_changeTextField.frame) + 15, 300, 0.5)];
    upLineView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00];
    [self addSubview:upLineView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(_changeTextField.frame) + 15, 300 / 2.f , 45);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    
    UIView *middleLineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cancelBtn.frame), CGRectGetMaxY(_changeTextField.frame) + 15, 0.5, 45)];
    middleLineView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00];
    [self addSubview:middleLineView];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    confirmBtn.frame = CGRectMake(CGRectGetMaxX(cancelBtn.frame), CGRectGetMaxY(_changeTextField.frame) + 15, 300 / 2.f , 45);
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(clickConfirm) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
}

@end
