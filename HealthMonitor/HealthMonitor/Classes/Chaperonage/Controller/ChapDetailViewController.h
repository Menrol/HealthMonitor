//
//  ChapDetailViewController.h
//  HealthMonitor
//
//  Created by WRQ on 2019/4/17.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChapDetailViewController : UIViewController
@property(strong,nonatomic) UIImageView    *iconImageView;
@property(strong,nonatomic) UILabel        *nameLabel;
@property(strong,nonatomic) UILabel        *sexLabel;
@property(strong,nonatomic) UILabel        *ageLabel;
@property(strong,nonatomic) UILabel        *experienceLabel;
@property(strong,nonatomic) UILabel        *chapTimeLabel;
@property(strong,nonatomic) UILabel        *intelligenceLabel;

@end

NS_ASSUME_NONNULL_END
