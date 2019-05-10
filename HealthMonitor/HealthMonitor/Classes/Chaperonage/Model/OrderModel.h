//
//  OrderModel.h
//  HealthMonitor
//
//  Created by WRQ on 2019/5/9.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderModel : NSObject
@property(strong,nonatomic) NSString          *address;
@property(strong,nonatomic) NSString          *desc;
@property(assign,nonatomic) NSInteger         emergencyStatus;
@property(strong,nonatomic) NSString          *escortEnd;
@property(strong,nonatomic) NSString          *escortName;
@property(strong,nonatomic) NSString          *escortRealName;
@property(strong,nonatomic) NSString          *escortStart;
@property(assign,nonatomic) NSInteger         escortType;
@property(assign,nonatomic) NSInteger         healthStatus;
@property(assign,nonatomic) NSInteger         orderID;
@property(strong,nonatomic) NSString          *orderNO;
@property(assign,nonatomic) NSInteger         orderStatus;
@property(strong,nonatomic) NSString          *parentEscort;
@property(strong,nonatomic) NSString          *parentName;
@property(strong,nonatomic) NSString          *position;

@end

NS_ASSUME_NONNULL_END
