
//
//  RQPointAnnotation.m
//  HealthMonitor
//
//  Created by WRQ on 2019/5/12.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "RQPointAnnotation.h"

@implementation RQPointAnnotation

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate index:(NSInteger)index {
    self = [super init];
    
    if (self) {
        self.index = index;
        self.coordinate = coordinate;
    }
    
    return self;
}

@end
