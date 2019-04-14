//
//  MessageView.h
//  HealthMonitor
//
//  Created by WRQ on 2019/4/14.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

+ (MessageView *)messageView;

@end

NS_ASSUME_NONNULL_END
