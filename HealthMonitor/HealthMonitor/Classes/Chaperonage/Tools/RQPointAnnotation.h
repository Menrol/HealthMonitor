//
//  RQPointAnnotation.h
//  HealthMonitor
//
//  Created by WRQ on 2019/5/12.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RQPointAnnotation : MAPointAnnotation
@property(assign,nonatomic) NSInteger          index;

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
