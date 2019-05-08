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

- (void)setBirthday:(NSString *)birthday {
    NSTimeInterval timeInterval = [birthday doubleValue] / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *birthdayStr = [formatter stringFromDate:date];
    
    _birthday = birthdayStr;
}

@end
