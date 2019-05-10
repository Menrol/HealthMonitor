//
//  OrderModel.m
//  HealthMonitor
//
//  Created by WRQ on 2019/5/9.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"orderID": @"id"};
}

- (void)setEscortStart:(NSString *)escortStart {
    NSTimeInterval timeInterval = [escortStart doubleValue] / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM-dd HH:mm";
    NSString *escortStartStr = [formatter stringFromDate:date];
    
    _escortStart = escortStartStr;
}

- (void)setEscortEnd:(NSString *)escortEnd {
    NSTimeInterval timeInterval = [escortEnd doubleValue] / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM-dd HH:mm";
    NSString *escortEndStr = [formatter stringFromDate:date];
    
    _escortEnd = escortEndStr;
}

@end
