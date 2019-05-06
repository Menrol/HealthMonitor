//
//  ParentModel.m
//  HealthMonitor
//
//  Created by WRQ on 2019/5/6.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "ParentModel.h"
#import "ChapModel.h"
#import "ChildModel.h"

@implementation ParentModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userID": @"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"childList": [ChildModel class],
             @"escortList": [ChapModel class]};
}

@end
