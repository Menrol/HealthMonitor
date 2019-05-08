//
//  TipView.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/11.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "TipView.h"
#import <Masonry/Masonry.h>

@implementation TipView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    // 添加控件
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self addSubview:_titleLabel];
    
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.font = [UIFont boldSystemFontOfSize:18.f];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_tipLabel];
    
    
    // 设置布局
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15.f);
        make.left.equalTo(self.mas_left).offset(15.f);
        make.height.mas_equalTo(15.f);
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15.f);
        make.left.equalTo(self.mas_left).offset(15.f);
        make.right.equalTo(self.mas_right).offset(-15.f);
        make.height.mas_equalTo(18.f);
    }];
}

@end
