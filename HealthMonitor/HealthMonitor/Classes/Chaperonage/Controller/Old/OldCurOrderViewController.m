//
//  OldCurOrderViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/11.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "OldCurOrderViewController.h"
#import "OldOrderUpView.h"
#import "OldOrderDownView.h"
#import <Masonry/Masonry.h>

@interface OldCurOrderViewController ()<OldOrderUpViewDelegate>
@property(strong,nonatomic) OldOrderUpView    *upView;
@property(strong,nonatomic) OldOrderDownView  *downView;

@end

@implementation OldCurOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)didClickDetailButton {
    NSLog(@"查看详情");
}

- (void)setupUI {
    // 创建控件
    _upView = [[OldOrderUpView alloc] init];
    _upView.layer.borderColor = [UIColor blackColor].CGColor;
    _upView.layer.borderWidth = 0.5;
    _upView.delegate = self;
    // TODO: 测试数据
    _upView.orderStatusLabel.text = @"陪护员已接单";
    _upView.chaperonageLabel.text = @"王悦";
    [self.view addSubview:_upView];
    
    _downView = [OldOrderDownView oldOrderDownView];
    _downView.layer.borderColor = [UIColor blackColor].CGColor;
    _downView.layer.borderWidth = 0.5;
    [self.view addSubview:_downView];
    
    // 添加布局
    [_upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(340.f);
    }];
    
    [_downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.upView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

@end
