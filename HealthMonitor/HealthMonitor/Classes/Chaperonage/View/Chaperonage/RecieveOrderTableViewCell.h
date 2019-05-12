//
//  RecieveOrderTableViewCell.h
//  HealthMonitor
//
//  Created by WRQ on 2019/4/16.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;

NS_ASSUME_NONNULL_BEGIN

@interface RecieveOrderTableViewCell : UITableViewCell
@property(strong,nonatomic) UILabel      *orderNumLabel;
@property(strong,nonatomic) UILabel      *addressLabel;
@property(strong,nonatomic) UILabel      *beChapLabel;
@property(strong,nonatomic) UILabel      *healthLabel;
@property(strong,nonatomic) UILabel      *chapTimeLabel;
@property(strong,nonatomic) UILabel      *orderTypeLabel;
@property(strong,nonatomic) OrderModel   *model;

@end

NS_ASSUME_NONNULL_END
