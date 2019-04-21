//
//  ChangeAddressTableViewCell.h
//  HealthMonitor
//
//  Created by WRQ on 2019/4/21.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChangeAddressTableViewCell : UITableViewCell
@property(nonatomic,strong) UILabel      *titleLabel;
@property(nonatomic,strong) UILabel      *addressLabel;
@property(nonatomic,strong) UIImageView  *chooseImageView;

@end

NS_ASSUME_NONNULL_END
