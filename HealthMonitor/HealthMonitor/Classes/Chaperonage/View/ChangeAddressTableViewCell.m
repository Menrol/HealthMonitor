//
//  ChangeAddressTableViewCell.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/21.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "ChangeAddressTableViewCell.h"
#import <Masonry/Masonry.h>

@implementation ChangeAddressTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupUI];
    }
    
    return self;
}


- (void)setupUI {
    // 创建控件
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:16.f];
    _titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_titleLabel];
    
    _addressLabel = [[UILabel alloc] init];
    _addressLabel.font = [UIFont systemFontOfSize:13.f];
    _addressLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_addressLabel];
    
    _chooseImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choose"]];
    _chooseImageView.hidden = YES;
    [self.contentView addSubview:_chooseImageView];
    
    // 设置布局
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10.f);
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
        make.right.equalTo(self.chooseImageView.mas_left).offset(10.f);
    }];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10.f);
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(self.chooseImageView.mas_left).offset(10.f);
        make.height.mas_equalTo(13.f);
        
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10.f);
    }];
    
    [_chooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.size.mas_equalTo(CGSizeMake(16.f, 16.f));
    }];
    
}

@end
