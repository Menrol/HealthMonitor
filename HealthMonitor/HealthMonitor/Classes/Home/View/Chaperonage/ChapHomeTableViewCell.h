//
//  ChapHomeTableViewCell.h
//  HealthMonitor
//
//  Created by WRQ on 2019/4/15.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChapHomeTableViewCell;

@protocol ChapHomeTableViewCellDelegate <NSObject>

- (void)clickChangeButtonWithCell:(ChapHomeTableViewCell *_Nonnull)cell;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ChapHomeTableViewCell : UITableViewCell
@property(strong,nonatomic) UILabel                           *nameLabel;
@property(strong,nonatomic) UILabel                           *relationLabel;
@property(strong,nonatomic) UIButton                          *changeButton;
@property(weak,nonatomic)id<ChapHomeTableViewCellDelegate>    delegate;

@end

NS_ASSUME_NONNULL_END
