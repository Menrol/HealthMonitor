//
//  OldOrderListTableViewCell.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/12.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "OrderListTableViewCell.h"
#import "OrderModel.h"
#import <Masonry/Masonry.h>

@implementation OrderListTableViewCell

- (void)setModel:(OrderModel *)model {
    _orderNumLabel.text = model.orderNo;
    if (model.orderStatus == 0) {
        _orderTypeLabel.text = @"待接单";
        _orderTypeLabel.textColor = [UIColor colorWithRed:0.95 green:0.68 blue:0.31 alpha:1.00];
        _chaperonageLabel.text = @"无";
    }else if (model.orderStatus == 1 || model.orderStatus == 2) {
        _orderTypeLabel.text = @"进行中";
        _orderTypeLabel.textColor = [UIColor colorWithRed:0.28 green:0.51 blue:0.36 alpha:1.00];
        _chaperonageLabel.text = model.escortRealName;
    }else {
        _orderTypeLabel.text = @"已完成";
        _orderTypeLabel.textColor = [UIColor colorWithRed:0.22 green:0.29 blue:0.96 alpha:1.00];
        _chaperonageLabel.text = model.escortRealName;
    }
    _beChapLabel.text = model.parentName;
    _chapTimeLabel.text = [NSString stringWithFormat:@"%@至%@",model.escortStart,model.escortEnd];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupUI];
        
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor blackColor].CGColor;
    }
    
    return self;
}

- (void)setupUI {
    // 创建控件
    UILabel *orderNumTitleLabel = [[UILabel alloc] init];
    orderNumTitleLabel.text = @"订单号：";
    orderNumTitleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [self.contentView addSubview:orderNumTitleLabel];
    
    _orderNumLabel = [[UILabel alloc] init];
    _orderNumLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [self.contentView addSubview:_orderNumLabel];
    
    _orderTypeLabel = [[UILabel alloc] init];
    _orderTypeLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [self.contentView addSubview:_orderTypeLabel];
    
    UILabel *beChapTitleLabel = [[UILabel alloc] init];
    beChapTitleLabel.text = @"被陪护人：";
    beChapTitleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [self.contentView addSubview:beChapTitleLabel];
    
    _beChapLabel = [[UILabel alloc] init];
    _beChapLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [self.contentView addSubview:_beChapLabel];
    
    UILabel *ChapTitleLabel = [[UILabel alloc] init];
    ChapTitleLabel.text = @"陪护员：";
    ChapTitleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [self.contentView addSubview:ChapTitleLabel];
    
    _chaperonageLabel = [[UILabel alloc] init];
    _chaperonageLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [self.contentView addSubview:_chaperonageLabel];
    
    UILabel *ChapTimeTitleLabel = [[UILabel alloc] init];
    ChapTimeTitleLabel.text = @"陪护时间：";
    ChapTimeTitleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [self.contentView addSubview:ChapTimeTitleLabel];
    
    _chapTimeLabel = [[UILabel alloc] init];
    _chapTimeLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [self.contentView addSubview:_chapTimeLabel];
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrows_right"]];
    [self.contentView addSubview:imageView];
    
    // 设置布局
    [orderNumTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15.f);
        make.left.equalTo(self.contentView.mas_left).offset(15.f);
        make.height.mas_equalTo(16.f);
    }];
    
    [_orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orderNumTitleLabel.mas_right);
        make.top.equalTo(orderNumTitleLabel.mas_top);
        make.height.mas_equalTo(16.f);
    }];
    
    [_orderTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderNumLabel.mas_right).offset(15.f);
        make.top.equalTo(self.orderNumLabel.mas_top);
        make.height.mas_equalTo(16.f);
    }];
    
    [beChapTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderNumTitleLabel.mas_bottom).offset(15.f);
        make.left.equalTo(self.contentView.mas_left).offset(15.f);
        make.height.mas_equalTo(16.f);
    }];
    
    [_beChapLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(beChapTitleLabel.mas_right);
        make.top.equalTo(beChapTitleLabel.mas_top);
        make.height.mas_equalTo(16.f);
    }];
    
    [ChapTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.beChapLabel.mas_top);
        make.left.equalTo(self.beChapLabel.mas_right).offset(15.f);
        make.height.mas_equalTo(16.f);
    }];
    
    [_chaperonageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ChapTitleLabel.mas_right);
        make.top.equalTo(ChapTitleLabel.mas_top);
        make.height.mas_equalTo(16.f);
    }];
    
    [ChapTimeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(beChapTitleLabel.mas_bottom).offset(15.f);
        make.left.equalTo(beChapTitleLabel.mas_left);
        make.height.mas_equalTo(16.f);
    }];
    
    [_chapTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ChapTimeTitleLabel.mas_right);
        make.top.equalTo(ChapTimeTitleLabel.mas_top).offset(-2.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.f);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15.f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}

@end
