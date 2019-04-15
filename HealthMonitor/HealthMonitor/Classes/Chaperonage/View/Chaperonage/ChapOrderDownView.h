//
//  ChapOrderDownView.h
//  HealthMonitor
//
//  Created by WRQ on 2019/4/15.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChapOrderDownView : UIView
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *beChapNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *chapTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *healthConditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *chapTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sicknessHistoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *medicineLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;

+ (ChapOrderDownView *)chapOrderDownView;

@end

NS_ASSUME_NONNULL_END
