//
//  ChanageTableViewCell.h
//  HealthMonitor
//
//  Created by WRQ on 2019/4/15.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChanageTableViewCell;

@protocol ChangeTableViewCellDelegate <NSObject>

- (void)clickChangeButtonWithCell:(ChanageTableViewCell *_Nonnull)cell;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ChanageTableViewCell : UITableViewCell
@property(strong,nonatomic) UILabel                           *nameLabel;
@property(strong,nonatomic) UILabel                           *relationLabel;
@property(strong,nonatomic) UIButton                          *changeButton;
@property(weak,nonatomic)id<ChangeTableViewCellDelegate>    delegate;

@end

NS_ASSUME_NONNULL_END
