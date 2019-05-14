//
//  StepView.h
//  HealthMonitor
//
//  Created by WRQ on 2019/4/10.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StepView : UIView
@property(strong,nonatomic) NSArray             *stepArray;
@property(strong,nonatomic) UILabel             *stepCountLabel;

@end

NS_ASSUME_NONNULL_END
