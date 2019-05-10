//
//  OrderDetailModel.h
//  HealthMonitor
//
//  Created by WRQ on 2019/5/10.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MedicineModel;

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetailModel : NSObject
@property(strong,nonatomic) NSString                   *address;
@property(assign,nonatomic) NSInteger                  emergencyStatus;
@property(assign,nonatomic) NSString                   *escortEnd;
@property(strong,nonatomic) NSString                   *escortName;
@property(strong,nonatomic) NSString                   *escortRealName;
@property(assign,nonatomic) NSString                   *escortStart;
@property(assign,nonatomic) NSInteger                  escortType;
@property(assign,nonatomic) NSInteger                  healthStatus;
@property(strong,nonatomic) NSString                   *illness;
@property(strong,nonatomic) NSArray<MedicineModel *>   *medicationComplianceList;
@property(strong,nonatomic) NSString                   *orderNo;
@property(assign,nonatomic) NSInteger                  orderStatus;
@property(assign,nonatomic) NSInteger                  parentAge;
@property(strong,nonatomic) NSString                   *parentEscort;
@property(strong,nonatomic) NSString                   *parentGender;
@property(strong,nonatomic) NSString                   *parentName;
@property(strong,nonatomic) NSString                   *position;

@end

NS_ASSUME_NONNULL_END
