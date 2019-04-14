//
//  OldMyTableViewCell.h
//  HealthMonitor
//
//  Created by WRQ on 2019/4/14.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OldMyTableViewCell;

@protocol OldMyTableViewCellDelegate <NSObject>

- (void)clickDeleteButtonWithCell:(OldMyTableViewCell *_Nonnull)cell;
- (void)clickAddButtonWithCell:(OldMyTableViewCell *_Nonnull)cell;

@end

NS_ASSUME_NONNULL_BEGIN

@interface OldMyTableViewCell : UITableViewCell
@property(strong,nonatomic) UILabel                       *nameLabel;
@property(strong,nonatomic) UILabel                       *relationLabel;
@property(strong,nonatomic) UIButton                      *addButton;
@property(strong,nonatomic) UIButton                      *deleteButton;
@property(weak,nonatomic)id<OldMyTableViewCellDelegate>   delegate;

@end

NS_ASSUME_NONNULL_END
