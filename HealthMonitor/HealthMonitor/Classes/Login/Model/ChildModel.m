//
//  ChildModel.m
//  HealthMonitor
//
//  Created by WRQ on 2019/5/6.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "ChildModel.h"
#import "ParentModel.h"

@implementation ChildModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userID": @"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"parentList": [ParentModel class]};
}


@end
