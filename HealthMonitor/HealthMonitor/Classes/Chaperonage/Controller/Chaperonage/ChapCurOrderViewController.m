//
//  ChapCurOrderViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/15.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "ChapCurOrderViewController.h"
#import "ChapOrderUpView.h"
#import "ChapOrderDownView.h"
#import <Masonry/Masonry.h>

@interface ChapCurOrderViewController ()
@property(strong,nonatomic) ChapOrderUpView     *upView;
@property(strong,nonatomic) ChapOrderDownView   *downView;

@end

@implementation ChapCurOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)clickChangeButton {
    NSLog(@"变更状态");
}

- (void)setupUI {
    // 创建控件
    _upView = [[ChapOrderUpView alloc] init];
    // TODO: 测试数据
    _upView.orderStatusLabel.text = @"请尽快赶往地点";
    [self.view addSubview:_upView];
    
    _downView = [ChapOrderDownView chapOrderDownView];
    [self.view addSubview:_downView];
    
    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [changeButton setTitle:@"变更状态" forState:UIControlStateNormal];
    [changeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    changeButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    changeButton.layer.borderWidth = 1;
    changeButton.layer.borderColor = [UIColor blackColor].CGColor;
    changeButton.layer.cornerRadius = 5;
    changeButton.layer.masksToBounds = YES;
    [changeButton addTarget:self action:@selector(clickChangeButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeButton];
    
    // 添加布局
    [_upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(230.f);
    }];
    
    [_downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.upView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(335.f);
    }];
    
    [changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.downView.mas_bottom).offset(15.f);
        make.left.equalTo(self.view.mas_left).offset(15.f);
        make.right.equalTo(self.view.mas_right).offset(-15.f);
        make.bottom.equalTo(self.view.mas_bottom).offset(-15.f);
    }];
}

@end
