//
//  OldOrderDownView.h
//  HealthMonitor
//
//  Created by WRQ on 2019/4/12.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OldOrderDownView : UIView
@property (weak, nonatomic) IBOutlet UILabel *ChapNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *chapTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *HealthConditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *ChapTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sicknessHistoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *medicineConditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *OrderTypeLabel;

+ (OldOrderDownView *)oldOrderDownView;

@end

NS_ASSUME_NONNULL_END
