//
//  MyTableViewCell.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/14.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "MyTableViewCell.h"
#import <Masonry/Masonry.h>

@implementation MyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupUI];
    }
    
    return self;
}

- (void)clickDeleteButton {
    [_delegate clickDeleteButtonWithCell:self];
}

- (void)clickAddButton {
    [_delegate clickAddButtonWithCell:self];
}

- (void)setupUI {
    // 创建控件
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [self.contentView addSubview:_nameLabel];
    
    _ageLabel = [[UILabel alloc] init];
    _ageLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [self.contentView addSubview:_ageLabel];
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(clickDeleteButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteButton];
    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [_addButton addTarget:self action:@selector(clickAddButton) forControlEvents:UIControlEventTouchUpInside];
    _addButton.hidden = YES;
    [self.contentView addSubview:_addButton];
    
    // 设置布局
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(15.f);
        make.height.mas_equalTo(20.f);
    }];
    
    [_ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(15.f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(20.f);
        make.width.mas_equalTo(40.f);
    }];
    
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15.f);
        make.height.mas_equalTo(22.f);
        make.width.mas_equalTo(22.f);
    }];
    
    [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(22.f);
        make.width.mas_equalTo(22.f);
    }];
}

@end
