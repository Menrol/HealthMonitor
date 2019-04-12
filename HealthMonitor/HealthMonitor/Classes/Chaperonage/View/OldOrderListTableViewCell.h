//
//  OldOrderListTableViewCell.h
//  HealthMonitor
//
//  Created by WRQ on 2019/4/12.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OldOrderListTableViewCell : UITableViewCell
@property(strong,nonatomic) UILabel    *orderNumLabel;
@property(strong,nonatomic) UILabel    *beChapLabel;
@property(strong,nonatomic) UILabel    *chaperonageLabel;
@property(strong,nonatomic) UILabel    *chapTimeLabel;
@property(strong,nonatomic) UILabel    *orderTypeLabel;

@end

NS_ASSUME_NONNULL_END
