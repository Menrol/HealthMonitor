//
//  CurOrderUpView.h
//  HealthMonitor
//
//  Created by WRQ on 2019/4/11.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CurOrderUpViewDelegate <NSObject>

- (void)didClickDetailButton;

@end

@interface CurOrderUpView : UIView
@property(strong,nonatomic) UILabel                   *orderStatusLabel;
@property(strong,nonatomic) UILabel                   *chaperonageLabel;
@property(weak,nonatomic) id<CurOrderUpViewDelegate>  delegate;

@end

NS_ASSUME_NONNULL_END
