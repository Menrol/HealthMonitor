//
//  HistogramCollectionViewCell.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/10.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "HistogramCollectionViewCell.h"

@implementation HistogramCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _hostogramView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _hostogramView.backgroundColor = [UIColor colorWithRed:0.44 green:0.62 blue:0.97 alpha:1.00];
        [self addSubview:_hostogramView];
    }
    
    return self;
}

@end
