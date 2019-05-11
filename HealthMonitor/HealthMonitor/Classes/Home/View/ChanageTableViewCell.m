//
//  ChanageTableViewCell.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/15.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "ChanageTableViewCell.h"
#import "ParentModel.h"
#import <Masonry/Masonry.h>

@implementation ChanageTableViewCell

- (void)setModel:(ParentModel *)model {
    _nameLabel.text = model.name;
    _ageLabel.text = [NSString stringWithFormat:@"%ld",model.age];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupUI];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    return self;
}

- (void)clickChangeButton {
    [_delegate clickChangeButtonWithCell:self];
}

- (void)setupUI {
    // 创建控件
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont boldSystemFontOfSize:18.f];
    [self.contentView addSubview:_nameLabel];
    
    _ageLabel = [[UILabel alloc] init];
    _ageLabel.font = [UIFont boldSystemFontOfSize:18.f];
    [self.contentView addSubview:_ageLabel];
    
    _changeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_changeButton setTitle:@"切换" forState:UIControlStateNormal];
    [_changeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _changeButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    _changeButton.layer.borderColor = [UIColor blackColor].CGColor;
    _changeButton.layer.borderWidth = 1;
    _changeButton.layer.cornerRadius = 5;
    _changeButton.layer.masksToBounds = YES;
    _changeButton.backgroundColor = [UIColor whiteColor];
    [_changeButton addTarget:self action:@selector(clickChangeButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_changeButton];

    // 设置布局
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15.f);
        make.left.equalTo(self.contentView.mas_left).offset(15.f);
        make.height.mas_equalTo(18.f);
    }];
    
    [_ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_top);
        make.left.equalTo(self.nameLabel.mas_right).offset(5.f);
        make.height.mas_equalTo(18.f);
        make.width.mas_equalTo(50.f);
    }];
    
    [_changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ageLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15.f);
        make.height.mas_equalTo(30.f);
        make.width.mas_equalTo(65.f);
    }];
}

@end
