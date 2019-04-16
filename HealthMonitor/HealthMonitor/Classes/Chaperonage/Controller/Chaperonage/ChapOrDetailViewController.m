//
//  ChapOrDetailViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/16.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "ChapOrDetailViewController.h"
#import "ChapOrderUpView.h"
#import "ChapOrderDownView.h"
#import <Masonry/Masonry.h>

@interface ChapOrDetailViewController ()
@property(strong,nonatomic) ChapOrderUpView     *upView;
@property(strong,nonatomic) ChapOrderDownView   *downView;
@property(strong,nonatomic) UIButton            *recieveButton;

@end

@implementation ChapOrDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.controllerType == 1) {
        self.recieveButton.hidden = YES;
    }
}

- (void)clickRecieveButton {
    NSLog(@"接单");
}

- (void)clickReturn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupUI {
    self.title = @"订单详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrows_left"] style:UIBarButtonItemStylePlain target:self action:@selector(clickReturn)];
    
    // 创建控件
    _upView = [[ChapOrderUpView alloc] init];
    // TODO: 测试数据
    _upView.orderStatusLabel.text = @"请尽快赶往地点";
    [self.view addSubview:_upView];
    
    _downView = [ChapOrderDownView chapOrderDownView];
    [self.view addSubview:_downView];
    
    _recieveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_recieveButton setTitle:@"接单" forState:UIControlStateNormal];
    [_recieveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _recieveButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    _recieveButton.layer.borderWidth = 1;
    _recieveButton.layer.borderColor = [UIColor blackColor].CGColor;
    _recieveButton.layer.cornerRadius = 5;
    _recieveButton.layer.masksToBounds = YES;
    [_recieveButton addTarget:self action:@selector(clickRecieveButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recieveButton];
    
    // 添加布局
    [_upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(getRectNavAndStatusHeight);
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
    
    [_recieveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.downView.mas_bottom).offset(15.f);
        make.left.equalTo(self.view.mas_left).offset(15.f);
        make.right.equalTo(self.view.mas_right).offset(-15.f);
        make.bottom.equalTo(self.view.mas_bottom).offset(-TabBarHeight - 15);
    }];
}

@end
