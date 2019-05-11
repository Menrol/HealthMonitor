//
//  MyTableViewCell.h
//  HealthMonitor
//
//  Created by WRQ on 2019/4/14.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyTableViewCell;

@protocol MyTableViewCellDelegate <NSObject>

- (void)clickDeleteButtonWithCell:(MyTableViewCell *_Nonnull)cell;
- (void)clickAddButtonWithCell:(MyTableViewCell *_Nonnull)cell;

@end

NS_ASSUME_NONNULL_BEGIN

@interface MyTableViewCell : UITableViewCell
@property(strong,nonatomic) UILabel                       *nameLabel;
@property(strong,nonatomic) UILabel                       *ageLabel;
@property(strong,nonatomic) UIButton                      *addButton;
@property(strong,nonatomic) UIButton                      *deleteButton;
@property(weak,nonatomic)id<MyTableViewCellDelegate>      delegate;

@end

NS_ASSUME_NONNULL_END
