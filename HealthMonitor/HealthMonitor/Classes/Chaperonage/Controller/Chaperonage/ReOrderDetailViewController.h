//
//  ReOrderDetailViewController.h
//  HealthMonitor
//
//  Created by WRQ on 2019/4/20.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReOrderDetailViewController : UIViewController
@property(strong,nonatomic) NSString     *orderNo;
@property(assign,nonatomic) NSInteger    orderID;
@property(strong,nonatomic) NSString     *nickname;
@property(assign,nonatomic) NSInteger    chapID;

@end

NS_ASSUME_NONNULL_END
