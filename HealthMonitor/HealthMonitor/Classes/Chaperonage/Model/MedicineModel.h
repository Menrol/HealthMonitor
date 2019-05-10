//
//  MedicineModel.h
//  HealthMonitor
//
//  Created by WRQ on 2019/5/10.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MedicineModel : NSObject
@property(strong,nonatomic) NSString             *count;
@property(assign,nonatomic) NSInteger            medicineID;
@property(strong,nonatomic) NSString             *medicine;
@property(strong,nonatomic) NSString             *medicineTime;
@property(strong,nonatomic) NSString             *nickname;
@property(assign,nonatomic) NSInteger            status;

@end

NS_ASSUME_NONNULL_END
