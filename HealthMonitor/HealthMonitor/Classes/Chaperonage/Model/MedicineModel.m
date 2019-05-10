//
//  MedicineModel.m
//  HealthMonitor
//
//  Created by WRQ on 2019/5/10.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "MedicineModel.h"

@implementation MedicineModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"medicineID": @"id"};
}

@end
